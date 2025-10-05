if (!requireNamespace("BiocManager", quietly = TRUE)) 
  install.packages("BiocManager")

BiocManager::install(c("GEOquery","affy","arrayQualityMetrics","affyPLM",
                       "Biobase","AnnotationDbi","annotate","genefilter","limma","latticeExtra"), force = TRUE)
install.packages("dplyr")
install.packages("matrixStats")

library(GEOquery)
library(affy)
library(arrayQualityMetrics)
library(affyPLM)
library(Biobase)
library(AnnotationDbi)
library(annotate)
library(genefilter)
library(limma)
library(latticeExtra)
library(dplyr)
library(matrixStats)

setwd("C:/Users/tahaj/Desktop/GSE72267/CEL_Files")

raw_data <- ReadAffy()
raw_data

arrayQualityMetrics(expressionset = raw_data,
                    outdir = "Results/QC_Raw_Data",
                    force = TRUE,
                    do.logtransform = TRUE)

cat("\n✅ QC Report for Raw Data generated successfully!")
cat("\n📂 Check folder: C:/Users/tahaj/Desktop/GSE72267/CEL_Files/Results/QC_Raw_Data/index.html\n")

normalized_data <- rma(raw_data)
processed_data <- as.data.frame(exprs(normalized_data))
dim(processed_data)

arrayQualityMetrics(expressionset = normalized_data,
                    outdir = "Results/QC_Normalized_Data",
                    force = TRUE)

row_median <- rowMedians(as.matrix(processed_data))

hist(row_median,
     breaks = 100,
     freq = FALSE,
     main = "Median Intensity Distribution",
     xlab = "Median Intensity (log2)",
     col = "lightblue")

threshold <- 3.5
abline(v = threshold, col = "red", lwd = 2)

indx <- row_median > threshold
filtered_data <- processed_data[indx, ]

gse_data <- getGEO("GSE72267", GSEMatrix = TRUE)
phenotype_data <- pData(gse_data$GSE72267_series_matrix.txt.gz)
colnames(filtered_data) <- rownames(phenotype_data)

processed_data <- filtered_data

groups <- factor(phenotype_data$source_name_ch1,
                 levels = c("Blood from healthy control", "Blood from PD patient"),
                 labels = c("Normal","Cancer"))

cat("\n===========================================================")
cat("\n Microarray Preprocessing Summary — GSE72267")
cat("\n-----------------------------------------------------------")
cat("\n ✅ Raw CEL files loaded successfully")
cat("\n ✅ QC reports generated before and after normalization")
cat("\n ✅ RMA normalization completed")
cat("\n ✅ Low-variance probes filtered")
cat("\n ✅ Experimental groups defined (Normal vs Cancer)")
cat("\n===========================================================\n")





library(Biobase)
library(matrixStats)

# Use your normalized expression data
exprs_matrix <- exprs(normalized_data)

# -----------------------------
# 1. Hierarchical Clustering
# -----------------------------
dist_matrix <- dist(t(exprs_matrix))          # Euclidean distances between arrays
hc <- hclust(dist_matrix)                     # Hierarchical clustering

# Plot dendrogram
plot(hc, main="Hierarchical Clustering of Arrays")

# Cut tree into 2 clusters to identify potential outliers
clusters <- cutree(hc, k=2)
table(clusters)   # Check how many arrays in each cluster

# Arrays in the smaller cluster can be considered potential outliers
potential_outliers_hc <- names(clusters[clusters == which.min(table(clusters))])
cat("Potential outliers (hierarchical clustering):\n")
print(potential_outliers_hc)

# -----------------------------
# 2. PCA-based Detection
# -----------------------------
pca <- prcomp(t(exprs_matrix), scale.=TRUE)
pca_coords <- pca$x[,1:2]  # PC1 vs PC2

# Compute centroid of all arrays in PC1-PC2 space
centroid <- colMeans(pca_coords)

# Compute Euclidean distance from centroid
dist_from_centroid <- sqrt(rowSums((pca_coords - centroid)^2))

# Flag arrays with distance greater than 2 standard deviations
threshold <- mean(dist_from_centroid) + 2*sd(dist_from_centroid)
potential_outliers_pca <- names(dist_from_centroid[dist_from_centroid > threshold])
cat("Potential outliers (PCA):\n")
print(potential_outliers_pca)

# -----------------------------
# 3. Summary
# -----------------------------
all_outliers <- unique(c(potential_outliers_hc, potential_outliers_pca))
cat("\n✅ All flagged potential outlier arrays:\n")
print(all_outliers)

dim(processed_data)
nrow(filtered_data)


