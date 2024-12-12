import csv
import pandas as pd

# Try to read the variant list with error handling
variant_list = []

# Open the .txt file and handle errors for inconsistent rows
with open('variant_list.txt', 'r') as txt_file:
    for i, line in enumerate(txt_file):
        # Split the line into columns
        columns = line.strip().split('\t')
        
        # Check if the line has exactly 3 columns (Index, CH, Location)
        if len(columns) == 3:
            variant_list.append(columns)  # Append valid rows to the list
        else:
            print(f"Skipping row {i + 1}: {line.strip()} (unexpected number of columns)")

# Convert the valid list of rows into a DataFrame
variant_df = pd.DataFrame(variant_list, columns=["Index", "CH", "Location"])

# Initialize a counter for matches
match_count = 0

# Open the VCF file and output CSV file
with open('output_matches.csv', 'w', newline='') as output_csv:
    csv_writer = csv.writer(output_csv)
    csv_writer.writerow(['CH', 'Location', 'Other_Info'])  # Write header for the output CSV

    with open('Cystic_fibrosis_vep_targetregions.vcf', 'r') as vcf_file:
        for line in vcf_file:
            if line.startswith("#"):  # Skip header lines in VCF
                continue
            columns = line.strip().split('\t')
            vcf_ch = columns[0]  # Chromosome in VCF
            vcf_location = columns[1]  # Position in VCF
            
            # Check if this variant is in our variant list
            matches = variant_df[(variant_df['CH'] == vcf_ch) & (variant_df['Location'] == vcf_location)]
            
            if not matches.empty:  # If there are matches, write them to CSV
                for _, row in matches.iterrows():
                    csv_writer.writerow([row['CH'], row['Location'], line.strip()])  # Add all VCF data or customize if needed
                    match_count += 1  # Increment match counter

# Print the total count of matches found
print(f"Total matches found: {match_count}")
