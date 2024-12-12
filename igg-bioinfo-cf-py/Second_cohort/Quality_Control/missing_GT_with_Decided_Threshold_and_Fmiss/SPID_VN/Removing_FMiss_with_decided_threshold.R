# Load necessary libraries
library(dplyr)
library(rlang)

# Read the CSV file
data <- read.csv("SPID_VN.csv")

# Print the ID and ALT columns before processing
cat("ID and ALT for each variant:\n")
print(data %>% select(ID, ALT))

# Define valid genotypes
valid_genotypes <- c("0/0", "0/1", "1/1", "0|1", "1|1", "0|0", "1|0", "1/0")

# Extract genotype columns (columns ending with 'GT')
genotype_columns <- grep("GT$", colnames(data), value = TRUE)

# Calculate N_MISS (number of missing genotypes per SNP)
n_miss_per_snp <- apply(data[, genotype_columns], 1, function(row) {
  sum(!(row %in% valid_genotypes)) # Count anything that's not a valid genotype as missing
})

# Calculate Fmiss (Fraction of missing genotypes per SNP)
total_genotype_columns <- length(genotype_columns)
fmiss_per_snp <- n_miss_per_snp / total_genotype_columns

# Add Fmiss to the original data
data$Fmiss <- fmiss_per_snp

# Filter out rows where Fmiss > 0.10
filtered_data <- data %>% filter(Fmiss <= 0.10)
removed_data <- data %>% filter(Fmiss > 0.10)

# Save the filtered and removed data to new CSV files
write.csv(filtered_data, "filtered_qc_SPID_VN_variants.csv", row.names = FALSE)
write.csv(removed_data, "removed_qc_SPID_VN_variants.csv", row.names = FALSE)

# Print summary of the process
cat("Variants before filtering:", nrow(data), "\n")
cat("Variants after filtering:", nrow(filtered_data), "\n")
cat("Variants removed:", nrow(removed_data), "\n")



