# Load necessary libraries
library(ggplot2)

# Read the filtered and removed data
filtered_data <- read.csv("filtered_qc_variants.csv")
removed_data <- read.csv("removed_qc_variants.csv")

# Plot the distribution of Fmiss for filtered variants
ggplot(filtered_data, aes(x = Fmiss)) +
  geom_histogram(binwidth = 0.02, fill = "blue", color = "black") +
  labs(title = "Distribution of Missing Genotype Fraction (Fmiss) for Filtered Variants",
       x = "Fmiss (Fraction of Missing Genotypes)",
       y = "Frequency (Number of SNPs)") +
  theme_minimal()

# Save the filtered variants plot
ggsave("filtered_variants_fmiss_distribution.png")

# Plot the distribution of Fmiss for removed variants
ggplot(removed_data, aes(x = Fmiss)) +
  geom_histogram(binwidth = 0.02, fill = "red", color = "black") +
  labs(title = "Distribution of Missing Genotype Fraction (Fmiss) for Removed Variants",
       x = "Fmiss (Fraction of Missing Genotypes)",
       y = "Frequency (Number of SNPs)") +
  theme_minimal()

# Save the removed variants plot
ggsave("removed_variants_fmiss_distribution.png")
