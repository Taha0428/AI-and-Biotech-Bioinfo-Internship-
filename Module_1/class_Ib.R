# Replace path with your actual directory path
setwd("C:/Users/tahaj/Documents/AI_Omics_Internship_2025")
getwd()  # Confirm working directory

dir.create("raw_data")
dir.create("clean_data")
dir.create("scripts")
dir.create("results")
dir.create("plots")

# Load the CSV from raw_data
data <- read.csv("raw_data/patient_info.csv")

# View structure and first few rows
str(data)
head(data)


# Convert gender to factor
data$gender <- as.factor(data$gender)

# Convert diagnosis to factor
data$diagnosis <- as.factor(data$diagnosis)

# Convert smoker to binary factor: 1 = Yes, 0 = No
data$smoking_binary <- ifelse(data$smoker == "Yes", 1, 0)
data$smoking_binary <- as.factor(data$smoking_binary)

# Check final structure
str(data)

write.csv(data, file = "clean_data/patient_info_clean.csv", row.names = FALSE)


