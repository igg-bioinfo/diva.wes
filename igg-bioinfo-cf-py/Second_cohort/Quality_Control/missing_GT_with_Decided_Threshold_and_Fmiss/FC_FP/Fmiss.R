# Load necessary libraries
library(ggplot2)

# Assuming your data is loaded into a data frame called 'data'
# Replace 'sample1.csv' with your actual file path
data <- read.csv("FP_VN.csv") 
#for example for_DP_GQ_SPID_VN_check.csv or other samples.csv file generated form previous python script  # 

# Extract genotype columns (columns ending with 'GT')
genotype_columns <- grep("GT$", colnames(data), value = TRUE)

# Define valid genotypes (these are the non-missing genotypes)
valid_genotypes <- c("0/0", "0/1", "1/1", "0|1", "1|1", "0|0", "1|0","1/0")

# Calculate N-MISS (Number of missing genotypes per SNP)
n_miss_per_snp <- apply(data[, genotype_columns], 1, function(row) {
  sum(!(row %in% valid_genotypes)) # Count anything that's not a valid genotype as missing
})

# Calculate Fmiss (Fraction of missing genotypes per SNP)
total_genotype_columns <- length(genotype_columns)
fmiss_per_snp <- n_miss_per_snp / total_genotype_columns

# Create a data frame for plotting
missing_distribution <- data.frame(
  CHROM = data$CHROM,
  POSITION = data$POSITION,
  N_MISS = n_miss_per_snp,
  Fmiss = fmiss_per_snp
)

# Plot the histogram of Fmiss distribution
plot <- ggplot(missing_distribution, aes(x = Fmiss)) +
  geom_histogram(binwidth = 0.02, fill = "blue", color = "black") +
  labs(
    title = "Distribution of Missing Genotype Fraction (Fmiss) per SNP (FP-VN)",
    x = "Fmiss (Fraction of Missing Genotypes)",
    y = "Frequency (Number of SNPs)"
  ) +
  theme_minimal()

# Save the plot to a file
ggsave("Fmiss_distribution_histogram.png", plot = plot, width = 10, height = 6, dpi = 300)

