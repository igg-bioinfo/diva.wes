import vcfpy  # Import vcfpy to handle VCF file reading
import csv  # Import csv to handle writing CSV files

# Define the path to the input VCF file and the output CSV file
vcf_file = 'Multiallelic.vcf'  # Path to the VCF file containing variant data
csv_file = 'FC_VN.csv'  # Path where the output file (CSV report) will be saved

# Define the samples belonging to the VN group
dna_vn_samples = {
    'T-NGS_7989', 'T-NGS_7990', 'T-NGS_7991', 'T-NGS_7992', 'T-NGS_7993', 'T-NGS_7994', 'T-NGS_7995',
    'T-NGS_7996', 'T-NGS_7997', 'T-NGS_7998', 'T-NGS_7999', 'T-NGS_8000', 'T-NGS_8001', 'T-NGS_8002',
    'T-NGS_8003', 'T-NGS_8004', 'T-NGS_8005', 'T-NGS_8006', 'T-NGS_8007', 'T-NGS_8008', 'T-NGS_8009',
    'T-NGS_8010', 'T-NGS_8011', 'T-NGS_8012', 'T-NGS_8013', 'T-NGS_8014', 'T-NGS_8015', 'T-NGS_8016',
    'T-NGS_8017', 'T-NGS_8018', 'T-NGS_8019', 'T-NGS_8020', 'T-NGS_8021', 'T-NGS_8022', 'T-NGS_8023',
    'T-NGS_8024', 'T-NGS_8025', 'T-NGS_8026', 'T-NGS_8027', 'T-NGS_8028', 'T-NGS_8029', 'T-NGS_8030',
    'T-NGS_8031', 'T-NGS_8032', 'T-NGS_8033', 'T-NGS_8034', 'T-NGS_8035', 'T-NGS_8036', 'T-NGS_8037',
    'T-NGS_8038', 'T-NGS_8039', 'T-NGS_8040', 'T-NGS_8041', 'T-NGS_8042', 'T-NGS_8043', 'T-NGS_8044',
    'T-NGS_8045', 'T-NGS_8046', 'T-NGS_8047', 'T-NGS_8048', 'T-NGS_8049', 'T-NGS_8050', 'T-NGS_8051',
    'T-NGS_8052', 'T-NGS_8053', 'T-NGS_8054', 'T-NGS_8055', 'T-NGS_8056', 'T-NGS_8057', 'T-NGS_8058',
    'T-NGS_8059', 'T-NGS_8060', 'T-NGS_8061', 'T-NGS_8062', 'T-NGS_8063', 'T-NGS_8064', 'T-NGS_8065',
    'T-NGS_8066', 'T-NGS_8067', 'T-NGS_8068', 'T-NGS_8069', 'T-NGS_8070', 'T-NGS_8071', 'T-NGS_8072',
    'T-NGS_8073', 'T-NGS_8074', 'T-NGS_8075', 'T-NGS_8076', 'T-NGS_8077', 'T-NGS_8078', 'T-NGS_8079',
    'T-NGS_8080', 'T-NGS_8081', 'T-NGS_8082', 'T-NGS_8083', 'T-NGS_8084', 'T-NGS_8085', 'T-NGS_8086',
    'T-NGS_8087', 'T-NGS_8088', 'T-NGS_8947', 'T-NGS_8948', 'T-NGS_8949', 'T-NGS_8950', 'T-NGS_8951',
    'T-NGS_8952', 'T-NGS_8953', 'T-NGS_8954', 'T-NGS_8955', 'T-NGS_8956', 'T-NGS_8957', 'T-NGS_8958',
    'T-NGS_8959', 'T-NGS_8960', 'T-NGS_8961', 'T-NGS_8962', 'T-NGS_8963', 'T-NGS_8964', 'T-NGS_8965'
}

# Define the samples belonging to the FC group
fc_samples = {
    'T-NGS_8089', 'T-NGS_8098', 'T-NGS_8099', 'T-NGS_8100', 'T-NGS_8101', 'T-NGS_8102', 'T-NGS_8103', 'T-NGS_8104',
    'T-NGS_8105', 'T-NGS_8106', 'T-NGS_8090', 'T-NGS_8107', 'T-NGS_8091', 'T-NGS_8092', 'T-NGS_8093', 'T-NGS_8094',
    'T-NGS_8095', 'T-NGS_8096', 'T-NGS_8097', 'T-NGS_8108', 'T-NGS_8114', 'T-NGS_8115', 'T-NGS_8116', 'T-NGS_8117',
    'T-NGS_8118', 'T-NGS_8119', 'T-NGS_8120', 'T-NGS_8109', 'T-NGS_8110', 'T-NGS_8111', 'T-NGS_8112', 'T-NGS_8113',
    'T-NGS_8925', 'T-NGS_8926', 'T-NGS_8927', 'T-NGS_8928', 'T-NGS_8929', 'T-NGS_8966', 'T-NGS_8977', 'T-NGS_8989'
}

# Print the number of samples in each group
print(f"Number of samples in FC group: {len(fc_samples)}")
print(f"Number of samples in VN group: {len(dna_vn_samples)}")

# Open the VCF file using vcfpy's Reader to read variant data
reader = vcfpy.Reader.from_path(vcf_file)

# Open a new CSV file to write the processed data
with open(csv_file, mode='w', newline='') as file:
    writer = csv.writer(file)
    
    # Retrieve the list of sample names from the VCF file's header
    samples = reader.header.samples.names
    
    # Prepare the header row for the CSV file
    header = ['CHROM', 'POSITION', 'ID', 'REF', 'ALT']
    
    # Add FC samples first, then VN samples
    for sample in samples:
        if sample in fc_samples:
            group = "FC"
            header += [f"{group}_{sample} GT", f"{group}_{sample} DP", f"{group}_{sample} GQ", f"{group}_{sample} AD"]
    
    # Add VN samples after FC samples
    for sample in samples:
        if sample in dna_vn_samples:
            group = "VN"
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
        
        # Process FC samples first, then VN samples
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
        
        # Process VN samples after FC samples
        for sample_name in samples:
            if sample_name in dna_vn_samples:
                group = "VN"
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
