import vcfpy  # Import vcfpy to handle VCF file reading
import csv  # Import csv to handle writing CSV files

# Define the path to the input VCF file and the output CSV file
vcf_file = 'Multiallelic.vcf'  # Path to the VCF file containing variant data
csv_file = 'FC_FP.csv'  # Path where the output file (CSV report) will be saved

# Define the samples belonging to the FP and FC groups
fp_samples = {'T-NGS_8121', 'T-NGS_8129', 'T-NGS_8130', 'T-NGS_8131', 'T-NGS_8132', 'T-NGS_8133', 'T-NGS_8134',
    'T-NGS_8135', 'T-NGS_8136', 'T-NGS_8137', 'T-NGS_8122', 'T-NGS_8138', 'T-NGS_8139', 'T-NGS_8140',
    'T-NGS_8141', 'T-NGS_8142', 'T-NGS_8143', 'T-NGS_8144', 'T-NGS_8145', 'T-NGS_8146', 'T-NGS_8123',
    'T-NGS_8147', 'T-NGS_8148', 'T-NGS_8149', 'T-NGS_8150', 'T-NGS_8151', 'T-NGS_8152', 'T-NGS_8153',
    'T-NGS_8154', 'T-NGS_8155', 'T-NGS_8156', 'T-NGS_8157', 'T-NGS_8158', 'T-NGS_8159', 'T-NGS_8160',
    'T-NGS_8161', 'T-NGS_8162', 'T-NGS_8163', 'T-NGS_8164', 'T-NGS_8124', 'T-NGS_8125', 'T-NGS_8126',
    'T-NGS_8127', 'T-NGS_8128', 'T-NGS_8171', 'T-NGS_8172', 'T-NGS_8173', 'T-NGS_8174', 'T-NGS_8175',
    'T-NGS_8165', 'T-NGS_8176', 'T-NGS_8177', 'T-NGS_8178', 'T-NGS_8179', 'T-NGS_8180', 'T-NGS_8181',
    'T-NGS_8182', 'T-NGS_8183', 'T-NGS_8184', 'T-NGS_8166', 'T-NGS_8185', 'T-NGS_8186', 'T-NGS_8187',
    'T-NGS_8167', 'T-NGS_8168', 'T-NGS_8169', 'T-NGS_8170', 'T-NGS_8930', 'T-NGS_8931', 'T-NGS_8932',
    'T-NGS_8933', 'T-NGS_8934', 'T-NGS_8935', 'T-NGS_8936', 'T-NGS_8937', 'T-NGS_8938', 'T-NGS_8939',
    'T-NGS_8940', 'T-NGS_8941', 'T-NGS_8942', 'T-NGS_8943', 'T-NGS_8944', 'T-NGS_8945', 'T-NGS_8946',
    'T-NGS_8967', 'T-NGS_8968', 'T-NGS_8969', 'T-NGS_8970', 'T-NGS_8971', 'T-NGS_8972', 'T-NGS_8973',
    'T-NGS_8974', 'T-NGS_8975', 'T-NGS_8976', 'T-NGS_8978', 'T-NGS_8979', 'T-NGS_8980', 'T-NGS_8982',
    'T-NGS_8984', 'T-NGS_8985', 'T-NGS_8988', 'T-NGS_8991', 'T-NGS_8992'}

fc_samples = {'T-NGS_8089', 'T-NGS_8098', 'T-NGS_8099', 'T-NGS_8100', 'T-NGS_8101', 'T-NGS_8102','T-NGS_8103', 'T-NGS_8104',
           'T-NGS_8105', 'T-NGS_8106', 'T-NGS_8090', 'T-NGS_8107','T-NGS_8091', 'T-NGS_8092','T-NGS_8093', 'T-NGS_8094',
           'T-NGS_8095', 'T-NGS_8096', 'T-NGS_8097', 'T-NGS_8108', 'T-NGS_8114', 'T-NGS_8115','T-NGS_8116', 'T-NGS_8117',
           'T-NGS_8118', 'T-NGS_8119', 'T-NGS_8120', 'T-NGS_8109', 'T-NGS_8110', 'T-NGS_8111', 'T-NGS_8112', 'T-NGS_8113',
           'T-NGS_8925', 'T-NGS_8926', 'T-NGS_8927', 'T-NGS_8928', 'T-NGS_8929', 'T-NGS_8966',
           'T-NGS_8977', 'T-NGS_8989'
}

# Print the number of samples in each group
print(f"Number of samples in FP group: {len(fp_samples)}")
print(f"Number of samples in FC group: {len(fc_samples)}")

# Open the VCF file using vcfpy's Reader to read variant data
reader = vcfpy.Reader.from_path(vcf_file)

# Open a new CSV file to write the processed data
with open(csv_file, mode='w', newline='') as file:
    writer = csv.writer(file)
    
    # Retrieve the list of sample names from the VCF file's header
    samples = reader.header.samples.names
    
    # Prepare the header row for the CSV file
    header = ['CHROM', 'POSITION', 'ID', 'REF', 'ALT']
    
    # Add FP samples first, then FC samples
    for sample in samples:
        if sample in fp_samples:
            group = "FP"
            header += [f"{group}_{sample} GT", f"{group}_{sample} DP", f"{group}_{sample} GQ", f"{group}_{sample} AD"]
    
    # Add FC samples after FP samples
    for sample in samples:
        if sample in fc_samples:
            group = "FC"
            header += [f"{group}_{sample} GT", f"{group}_{sample} DP", f"{group}_{sample} GQ", f"{group}_{sample} AD"]
    
    # Write the header row to the CSV file
    writer.writerow(header)
    
    # Iterate through each record (variant) in the VCF file
    for record in reader:
        chromosome = record.CHROM
        position = record.POS
        id_field = record.ID[0] if isinstance(record.ID, list) and record.ID else ''
        ref = record.REF
        
        alt_values = [str(alt.value) if hasattr(alt, 'value') else str(alt) for alt in record.ALT]
        alt = ','.join(alt_values) if alt_values else ''
        
        row = [chromosome, position, id_field, ref, alt]
        
        # Process FP samples first
        for sample_name in samples:
            if sample_name in fp_samples:
                group = "FP"
                call = record.call_for_sample.get(sample_name, None)
                if call:
                    data = call.data
                    gt = data.get('GT', '')
                    if gt == '1/1':
                        gt = '1|1'
                    dp = data.get('DP', '')
                    gq = data.get('GQ', '')
                    ad = data.get('AD', [])
                    ad_values = ','.join(str(x) for x in ad) if isinstance(ad, list) else ad
                    
                    try:
                        dp_str = str(dp) if dp is not None else ''
                        gq_str = str(gq) if gq is not None else ''
                        
                        dp_val = int(dp_str) if dp_str.isdigit() else None
                        gq_val = int(gq_str) if gq_str.isdigit() else None
                        
                        # Apply thresholding for DP and GQ
                        if (dp_val is not None and dp_val < 8) or (gq_val is not None and gq_val < 20):
                            gt = './.'
                    except ValueError as e:
                        print(f"Warning: Value conversion issue for sample {sample_name}: {e}")
                        dp_str = ''
                        gq_str = ''
                        gt = './.'
                    
                    row += [gt, dp_str, gq_str, ad_values]
                else:
                    row += ['', '', '', '']
        
        # Process FC samples
        for sample_name in samples:
            if sample_name in fc_samples:
                group = "FC"
                call = record.call_for_sample.get(sample_name, None)
                if call:
                    data = call.data
                    gt = data.get('GT', '')
                    if gt == '1/1':
                        gt = '1|1'
                    dp = data.get('DP', '')
                    gq = data.get('GQ', '')
                    ad = data.get('AD', [])
                    ad_values = ','.join(str(x) for x in ad) if isinstance(ad, list) else ad
                    
                    try:
                        dp_str = str(dp) if dp is not None else ''
                        gq_str = str(gq) if gq is not None else ''
                        
                        dp_val = int(dp_str) if dp_str.isdigit() else None
                        gq_val = int(gq_str) if gq_str.isdigit() else None
                        
                        # Apply thresholding for DP and GQ
                        if (dp_val is not None and dp_val < 8) or (gq_val is not None and gq_val < 20):
                            gt = './.'
                    except ValueError as e:
                        print(f"Warning: Value conversion issue for sample {sample_name}: {e}")
                        dp_str = ''
                        gq_str = ''
                        gt = './.'
                    
                    row += [gt, dp_str, gq_str, ad_values]
                else:
                    row += ['', '', '', '']
        
        # Write the row to the CSV file
        writer.writerow(row)

# Print a message indicating that the CSV report has been successfully generated
print(f"\nCSV report generated: {csv_file}")
