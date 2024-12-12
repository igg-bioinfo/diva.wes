import pandas as pd
import re
from scipy.stats import fisher_exact

# Load the newly uploaded file
new_file_path = 'filtered_qc_FC_VN_variants.csv'  # Replace with the actual file path
new_df = pd.read_csv(new_file_path)

# Define the group columns for VN and FC (Group 1 as VN, Group 2 as FC)
group1_columns = [col for col in new_df.columns if col.startswith('VN_T.') and '.GT' in col]
group2_columns = [col for col in new_df.columns if col not in group1_columns and '.GT' in col]

# Print the number of samples in Group 1 (VN) and Group 2 (FC)
num_samples_group1 = len(group1_columns)
num_samples_group2 = len(group2_columns)
print(f'Number of samples in Group 1 (VN): {num_samples_group1}')
print(f'Number of samples in Group 2 (FC): {num_samples_group2}')

# Function to classify genotypes for each sample
def classify_genotypes_for_variant(row, sample_columns):
    genotypes = {
        '0/0': 0, '0/1': 0, '1/1': 0,
        'Multi_Allele_Hetero': 0, 'Multiallele_Homo': 0
    }
    
    for col in sample_columns:
        genotype = row[col]
        alleles = re.split(r'[\/|]', genotype)
        alleles = sorted(alleles)

        # Normalize genotypes
        if genotype in ['0/0', '0|0']:
            normalized_genotype = '0/0'
        elif genotype in ['0/1', '0|1', '1|0','1/0']:
            normalized_genotype = '0/1'
        elif genotype in ['1/1', '1|1']:
            normalized_genotype = '1/1'
        elif genotype in ['0/2', '0|2', '0/3', '0|3', '0/4', '0|4']:
            normalized_genotype = 'Multi_Allele_Hetero'
        elif genotype in ['2/2', '2|2', '3/3', '3|3', '4/4', '4|4']:
            normalized_genotype = 'Multiallele_Homo'
        else:
            continue

        # Increment the count for the respective genotype
        if normalized_genotype in genotypes:
            genotypes[normalized_genotype] += 1
    
    return genotypes

# Function to classify genotypes for all variants and perform Fisher's test
def classify_genotypes_for_all_variants(df, group1_columns, group2_columns):
    results = []

    for index, row in df.iterrows():
        # Classify genotypes for Group 1 (VN) and Group 2 (FC)
        group1_genotypes = classify_genotypes_for_variant(row, group1_columns)
        group2_genotypes = classify_genotypes_for_variant(row, group2_columns)
        
        # Perform Fisher's Exact Test
        cases_mutant_fp = ((group2_genotypes['Multiallele_Homo'] * 2) + (group2_genotypes['1/1'] * 2) + 
                           group2_genotypes['Multi_Allele_Hetero'] + group2_genotypes['0/1'])
        cases_wildtype_fp = group2_genotypes['0/0'] * 2

        control_mutant = ((group1_genotypes['Multiallele_Homo'] * 2) + (group1_genotypes['1/1'] * 2) + 
                          group1_genotypes['Multi_Allele_Hetero'] + group1_genotypes['0/1'])
        control_wildtype = group1_genotypes['0/0'] * 2

        contingency_table = [
            [cases_mutant_fp, cases_wildtype_fp],
            [control_mutant, control_wildtype]
        ]

        # Apply Fisher's Exact Test for different alternatives
        _, p_value_two_sided = fisher_exact(contingency_table, alternative='two-sided')
        _, p_value_greater = fisher_exact(contingency_table, alternative='greater')
        _, p_value_less = fisher_exact(contingency_table, alternative='less')

        # Find the minimum p-value
        min_p_value = min(p_value_greater, p_value_two_sided, p_value_less)

        results.append({
            'CHROM': row['CHROM'],
            'POSITION': row['POSITION'],
            'ID': row['ID'],
            'VN_0/0': group1_genotypes['0/0'],
            'VN_0/1': group1_genotypes['0/1'],
            'VN_1/1': group1_genotypes['1/1'],
            'VN_Multi_Allele_Hetero': group1_genotypes['Multi_Allele_Hetero'],
            'VN_Multiallele_Homo': group1_genotypes['Multiallele_Homo'],
            'FC_0/0': group2_genotypes['0/0'],
            'FC_0/1': group2_genotypes['0/1'],
            'FC_1/1': group2_genotypes['1/1'],
            'FC_Multi_Allele_Hetero': group2_genotypes['Multi_Allele_Hetero'],
            'FC_Multiallele_Homo': group2_genotypes['Multiallele_Homo'],
            'Fisher_p_value_two_sided': p_value_two_sided,
            'Fisher_p_value_greater': p_value_greater,
            'Fisher_p_value_less': p_value_less,
            'Fisher_min_p_value': min_p_value
        })

    return pd.DataFrame(results)

# Apply the Fisher's Exact Test process on this new dataset (VN as group1, FC as group2)
classified_genotypes_df_new = classify_genotypes_for_all_variants(new_df, group1_columns, group2_columns)

# Merge original dataframe with genotype counts and Fisher's p-values
final_df_new = pd.concat([new_df, classified_genotypes_df_new.iloc[:, 3:]], axis=1)

# Save the final result to a CSV file
output_final_file_new = 'Fisher_FC_vn_with_min_p_value.csv'
final_df_new.to_csv(output_final_file_new, index=False)

# Output the file path of the result
output_final_file_new
