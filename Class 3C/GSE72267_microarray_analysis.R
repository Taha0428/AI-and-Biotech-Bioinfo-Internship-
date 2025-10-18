
cat("\nChecking and installing required packages...\n")

cran_pkgs <- c("dplyr", "tibble", "ggplot2", "pheatmap")
bioc_pkgs <- c("GEOquery", "limma", "AnnotationDbi", "hgu133plus2.db")

install_if_missing <- function(pkg, bioc = FALSE) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    if (bioc) {
      if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager")
      BiocManager::install(pkg, ask = FALSE, update = FALSE)
    } else {
      install.packages(pkg, dependencies = TRUE)
    }
  }
  suppressPackageStartupMessages(library(pkg, character.only = TRUE))
}

for (p in cran_pkgs) install_if_missing(p)
for (p in bioc_pkgs) install_if_missing(p, bioc = TRUE)

cat("✅ All required packages loaded successfully.\n\n")


setwd("C:/Users/tahaj/Desktop/Microarray_Project")
cat("Working directory set to:", getwd(), "\n\n")


if (!file.exists("GSE72267.RData")) {
  cat("Downloading GSE72267 from GEO...\n")
  gset <- GEOquery::getGEO("GSE72267", GSEMatrix = TRUE)
  if (length(gset) > 1) gset <- gset[[1]]
  
  # Extract expression data and phenotype data
  processed_data <- exprs(gset)
  phenotype_data <- pData(gset)
  
  save(processed_data, phenotype_data, file = "GSE72267.RData")
  cat("✅ GSE72267 downloaded and saved as GSE72267.RData\n\n")
} else {
  cat("GSE72267.RData already exists — loading...\n")
  load("GSE72267.RData")
}

cat("Expression matrix dimensions:", dim(processed_data)[1], "probes ×", dim(processed_data)[2], "samples\n\n")

pval_cutoff <- 0.05        # adjusted p-value cutoff
logfc_cutoff <- 1           # log2 fold-change cutoff
top_n_table <- 50           # number of top DEGs to save
top_n_heatmap <- 25         # number of DEGs for heatmap

probe_ids <- rownames(processed_data)
gene_symbols <- AnnotationDbi::mapIds(
  hgu133plus2.db,
  keys = probe_ids,
  keytype = "PROBEID",
  column = "SYMBOL",
  multiVals = "first"
)

gene_map_df <- data.frame(PROBEID = names(gene_symbols),
                          SYMBOL = as.character(gene_symbols),
                          stringsAsFactors = FALSE)

processed_data_df <- processed_data %>%
  as.data.frame() %>%
  tibble::rownames_to_column("PROBEID") %>%
  left_join(gene_map_df, by = "PROBEID") %>%
  filter(!is.na(SYMBOL))

expr_only <- processed_data_df %>% select(-PROBEID, -SYMBOL)
averaged_data <- limma::avereps(expr_only, ID = processed_data_df$SYMBOL)
cat("Unique genes after collapsing probes:", nrow(averaged_data), "\n\n")
data <- as.matrix(averaged_data)

cat("Unique diagnosis values:\n"); print(unique(phenotype_data$`diagnosis:ch1`))

groups <- factor(ifelse(grepl("Parkinson", phenotype_data$`diagnosis:ch1`, ignore.case = TRUE),
                        "PD", "Healthy"))
cat("Samples per group:\n"); print(table(groups))

if (length(unique(groups)) < 2)
  stop("❌ Only one group found! Check phenotype_data$`diagnosis:ch1`.")

design <- model.matrix(~0 + groups)
colnames(design) <- levels(groups)
cat("Design matrix columns:", colnames(design), "\n")

fit <- lmFit(data, design)
contrast_matrix <- makeContrasts(PD_vs_Healthy = PD - Healthy, levels = design)
fit2 <- eBayes(contrasts.fit(fit, contrast_matrix))


deg_results <- topTable(fit2, coef = "PD_vs_Healthy", number = Inf, sort.by = "P") %>%
  tibble::rownames_to_column("SYMBOL") %>%
  mutate(
    p_value = P.Value,
    adj_p_value = adj.P.Val,
    threshold = case_when(
      adj_p_value < pval_cutoff & logFC > logfc_cutoff  ~ "Up_in_PD",
      adj_p_value < pval_cutoff & logFC < -logfc_cutoff ~ "Down_in_PD",
      TRUE                                              ~ "Not_significant"
    )
  ) %>%
  select(SYMBOL, logFC, AveExpr, t, p_value, adj_p_value, B, threshold)

n_up <- sum(deg_results$threshold == "Up_in_PD")
n_down <- sum(deg_results$threshold == "Down_in_PD")
n_total_sig <- n_up + n_down

cat("\n✅ DEG Summary:\n")
cat("Upregulated:", n_up, "\n")
cat("Downregulated:", n_down, "\n")
cat("Total DEGs:", n_total_sig, "\n\n")


dir.create("Results", showWarnings = FALSE)

write.csv(deg_results, "Results/DEGs_full_table.csv", row.names = FALSE)
write.csv(deg_results %>% arrange(adj_p_value) %>% head(top_n_table),
          sprintf("Results/top%d_DEGs_all.csv", top_n_table), row.names = FALSE)
write.csv(deg_results %>% filter(threshold == "Up_in_PD") %>% arrange(adj_p_value) %>% head(top_n_table),
          sprintf("Results/top%d_Up_in_PD.csv", top_n_table), row.names = FALSE)
write.csv(deg_results %>% filter(threshold == "Down_in_PD") %>% arrange(adj_p_value) %>% head(top_n_table),
          sprintf("Results/top%d_Down_in_PD.csv", top_n_table), row.names = FALSE)


dir.create("Result_Plots", showWarnings = FALSE)
deg_results <- deg_results %>% mutate(negLog10AdjP = -log10(adj_p_value))
label_genes <- deg_results %>%
  filter(threshold != "Not_significant") %>%
  arrange(adj_p_value) %>%
  head(10) %>%
  pull(SYMBOL)

png("Result_Plots/volcano_PD_vs_Healthy.png", width = 2000, height = 1600, res = 300)
ggplot(deg_results, aes(x = logFC, y = negLog10AdjP, color = threshold)) +
  geom_point(alpha = 0.7, size = 1.6) +
  scale_color_manual(values = c("Up_in_PD" = "red", "Down_in_PD" = "blue", "Not_significant" = "grey")) +
  geom_vline(xintercept = c(-logfc_cutoff, logfc_cutoff), linetype = "dashed") +
  geom_hline(yintercept = -log10(pval_cutoff), linetype = "dashed") +
  theme_minimal(base_size = 14) +
  labs(title = "Volcano Plot — PD vs Healthy (GSE72267)",
       x = "log2 Fold Change (PD / Healthy)",
       y = expression(-log[10]~"(adj. P-value)"),
       color = "Regulation") +
  geom_text(data = subset(deg_results, SYMBOL %in% label_genes),
            aes(label = SYMBOL), vjust = -1.1, size = 3)
dev.off()
cat("✅ Volcano plot saved: Result_Plots/volcano_PD_vs_Healthy.png\n")


sig_genes <- deg_results %>% filter(threshold != "Not_significant") %>% arrange(adj_p_value)
if (nrow(sig_genes) > 0) {
  top_heat_genes <- head(sig_genes$SYMBOL, top_n_heatmap)
  existing_genes <- intersect(top_heat_genes, rownames(data))
  heatmap_data <- data[existing_genes, , drop = FALSE]
  scaled_heatmap_data <- t(scale(t(heatmap_data)))
  colnames(scaled_heatmap_data) <- paste0(groups, "_", seq_along(groups))
  
  png("Result_Plots/heatmap_top_DEGs_PD_vs_Healthy.png", width = 2000, height = 1600, res = 300)
  pheatmap(scaled_heatmap_data,
           cluster_rows = TRUE,
           cluster_cols = TRUE,
           show_rownames = TRUE,
           show_colnames = TRUE,
           fontsize_row = 6,
           main = sprintf("Top %d DEGs (PD vs Healthy)", length(existing_genes)))
  dev.off()
  cat("✅ Heatmap saved: Result_Plots/heatmap_top_DEGs_PD_vs_Healthy.png\n")
} else {
  cat("⚠️ No significant DEGs found; skipping heatmap.\n")
}


summary_text <- c(
  "Dataset: GSE72267",
  "Comparison: Parkinson's disease (PD) vs Healthy",
  sprintf("Thresholds: adj.P.Val < %g & |log2FC| > %g", pval_cutoff, logfc_cutoff),
  sprintf("Upregulated genes: %d", n_up),
  sprintf("Downregulated genes: %d", n_down),
  sprintf("Total significant: %d", n_total_sig),
  "Full DEG table: Results/DEGs_full_table.csv",
  "Top DEGs: Results/top50_DEGs_all.csv, Up_in_PD.csv, Down_in_PD.csv",
  "Plots: Result_Plots/volcano_PD_vs_Healthy.png, heatmap_top_DEGs_PD_vs_Healthy.png"
)
writeLines(summary_text, con = "Results/analysis_summary.txt")
cat("\n✅ Summary written to Results/analysis_summary.txt\n\n")

cat("====== FINAL SUMMARY ======\n")
cat("Thresholds: adj.P.Val <", pval_cutoff, ", |log2FC| >", logfc_cutoff, "\n")
cat("Upregulated in PD:", n_up, "\n")
cat("Downregulated in PD:", n_down, "\n")
cat("Full DEG table: Results/DEGs_full_table.csv\n")
cat("Plots: Volcano + Heatmap in Result_Plots/\n")
cat("===========================\n")
