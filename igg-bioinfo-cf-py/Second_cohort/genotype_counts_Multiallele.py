import vcf
import csv
import re

# Define the sample groups
sample_groups = {
    'VN': ['T-NGS_7989', 'T-NGS_7998', 'T-NGS_8058', 'T-NGS_8059', 'T-NGS_8060', 'T-NGS_8061', 'T-NGS_8062',
           'T-NGS_8063', 'T-NGS_8064', 'T-NGS_8065', 'T-NGS_8066', 'T-NGS_7999', 'T-NGS_8067', 'T-NGS_8068',
           'T-NGS_8069', 'T-NGS_8070', 'T-NGS_8071', 'T-NGS_8072', 'T-NGS_8073', 'T-NGS_8074', 'T-NGS_8075',
           'T-NGS_8076', 'T-NGS_8077', 'T-NGS_8078', 'T-NGS_8079', 'T-NGS_8080', 'T-NGS_8081', 'T-NGS_8000',
           'T-NGS_8082', 'T-NGS_8083', 'T-NGS_8084', 'T-NGS_8085', 'T-NGS_8086', 'T-NGS_8087', 'T-NGS_8088',
           'T-NGS_8947', 'T-NGS_8948', 'T-NGS_8949', 'T-NGS_8950', 'T-NGS_8951', 'T-NGS_8952', 'T-NGS_8001',
           'T-NGS_8953', 'T-NGS_8954', 'T-NGS_8955', 'T-NGS_8956', 'T-NGS_8957', 'T-NGS_8958', 'T-NGS_8959',
           'T-NGS_8960', 'T-NGS_8961', 'T-NGS_8962', 'T-NGS_8963', 'T-NGS_8964', 'T-NGS_8965', 'T-NGS_8002',
           'T-NGS_8003', 'T-NGS_7990', 'T-NGS_8004', 'T-NGS_8005', 'T-NGS_8006', 'T-NGS_8007', 'T-NGS_8008',
           'T-NGS_8009', 'T-NGS_7991', 'T-NGS_8010', 'T-NGS_8011', 'T-NGS_8012', 'T-NGS_8013', 'T-NGS_8014',
           'T-NGS_8015', 'T-NGS_8016', 'T-NGS_8017', 'T-NGS_7992', 'T-NGS_8018', 'T-NGS_8019', 'T-NGS_8020',
           'T-NGS_8021', 'T-NGS_8022', 'T-NGS_8023', 'T-NGS_8024', 'T-NGS_8025', 'T-NGS_8026', 'T-NGS_7993',
           'T-NGS_8027', 'T-NGS_8028', 'T-NGS_8029', 'T-NGS_8030', 'T-NGS_8031', 'T-NGS_7994', 'T-NGS_8032',
           'T-NGS_8033', 'T-NGS_8034', 'T-NGS_8035', 'T-NGS_8036', 'T-NGS_7995', 'T-NGS_8037', 'T-NGS_8038',
           'T-NGS_8039', 'T-NGS_8040', 'T-NGS_8041', 'T-NGS_8042', 'T-NGS_8043', 'T-NGS_7996', 'T-NGS_8044',
           'T-NGS_8045', 'T-NGS_8046', 'T-NGS_8047', 'T-NGS_8048', 'T-NGS_8049', 'T-NGS_8050', 'T-NGS_7997',
           'T-NGS_8051', 'T-NGS_8052', 'T-NGS_8053', 'T-NGS_8054', 'T-NGS_8055', 'T-NGS_8056', 'T-NGS_8057'],
    'FC': ['T-NGS_8089', 'T-NGS_8098', 'T-NGS_8099', 'T-NGS_8100', 'T-NGS_8101', 'T-NGS_8102', 'T-NGS_8103',
           'T-NGS_8104', 'T-NGS_8105', 'T-NGS_8106', 'T-NGS_8090', 'T-NGS_8107', 'T-NGS_8929', 'T-NGS_8091',
           'T-NGS_8092', 'T-NGS_8093', 'T-NGS_8094', 'T-NGS_8095', 'T-NGS_8096', 'T-NGS_8097', 'T-NGS_8928',
           'T-NGS_8108', 'T-NGS_8114', 'T-NGS_8115', 'T-NGS_8116', 'T-NGS_8117', 'T-NGS_8118', 'T-NGS_8119',
           'T-NGS_8120', 'T-NGS_8109', 'T-NGS_8966', 'T-NGS_8925', 'T-NGS_8110', 'T-NGS_8926', 'T-NGS_8927',
           'T-NGS_8111', 'T-NGS_8112', 'T-NGS_8113', 'T-NGS_8989', 'T-NGS_8977'],
    'FP': ['T-NGS_8121', 'T-NGS_8129', 'T-NGS_8130', 'T-NGS_8131', 'T-NGS_8132', 'T-NGS_8133', 'T-NGS_8134',
           'T-NGS_8135', 'T-NGS_8136', 'T-NGS_8137', 'T-NGS_8122', 'T-NGS_8138', 'T-NGS_8139', 'T-NGS_8140',
           'T-NGS_8141', 'T-NGS_8142', 'T-NGS_8143', 'T-NGS_8144', 'T-NGS_8145', 'T-NGS_8146', 'T-NGS_8123',
           'T-NGS_8147', 'T-NGS_8148', 'T-NGS_8149', 'T-NGS_8150', 'T-NGS_8151', 'T-NGS_8152', 'T-NGS_8153',
           'T-NGS_8154', 'T-NGS_8155', 'T-NGS_8156', 'T-NGS_8157', 'T-NGS_8158', 'T-NGS_8159', 'T-NGS_8160',
           'T-NGS_8161', 'T-NGS_8162', 'T-NGS_8163', 'T-NGS_8164', 'T-NGS_8930', 'T-NGS_8124', 'T-NGS_8931',
           'T-NGS_8932', 'T-NGS_8933', 'T-NGS_8934', 'T-NGS_8967', 'T-NGS_8968', 'T-NGS_8969', 'T-NGS_8970',
           'T-NGS_8125', 'T-NGS_8126', 'T-NGS_8127', 'T-NGS_8128', 'T-NGS_8171', 'T-NGS_8172', 'T-NGS_8173',
           'T-NGS_8174', 'T-NGS_8175', 'T-NGS_8165', 'T-NGS_8176', 'T-NGS_8177', 'T-NGS_8178', 'T-NGS_8179',
           'T-NGS_8180', 'T-NGS_8181', 'T-NGS_8182', 'T-NGS_8183', 'T-NGS_8184', 'T-NGS_8166', 'T-NGS_8185',
           'T-NGS_8186', 'T-NGS_8187', 'T-NGS_8935', 'T-NGS_8936', 'T-NGS_8937', 'T-NGS_8938', 'T-NGS_8939',
           'T-NGS_8940', 'T-NGS_8941', 'T-NGS_8167', 'T-NGS_8942', 'T-NGS_8943', 'T-NGS_8944', 'T-NGS_8945',
           'T-NGS_8946', 'T-NGS_8168', 'T-NGS_8169', 'T-NGS_8170', 'T-NGS_8971', 'T-NGS_8972', 'T-NGS_8973',
           'T-NGS_8974', 'T-NGS_8975', 'T-NGS_8976', 'T-NGS_8985', 'T-NGS_8988', 'T-NGS_8991', 'T-NGS_8992',
           'T-NGS_8978', 'T-NGS_8979', 'T-NGS_8980', 'T-NGS_8982', 'T-NGS_8984'],
    'SPID': ['T-NGS_8192', 'T-NGS_8191', 'T-NGS_8188', 'T-NGS_8189', 'T-NGS_8190', 'T-NGS_8196', 'T-NGS_8197',
             'T-NGS_8198', 'T-NGS_8911', 'T-NGS_8912', 'T-NGS_8913', 'T-NGS_8914', 'T-NGS_8915', 'T-NGS_8916',
             'T-NGS_8917', 'T-NGS_8918', 'T-NGS_8919', 'T-NGS_8920', 'T-NGS_8921', 'T-NGS_8922', 'T-NGS_8923',
             'T-NGS_8924', 'T-NGS_8193', 'T-NGS_8194', 'T-NGS_8195', 'T-NGS_8986', 'T-NGS_8987', 'T-NGS_8990',
             'T-NGS_8993', 'T-NGS_8981', 'T-NGS_8983']
}

# Function to classify samples into genotypes for a given variant
def classify_samples_for_variant(record, sample_ids):
    genotypes = {
        '0/0': 0, '0/1': 0, '1/1': 0,
        'Mutli_Allele_Hetero': 0, 'Multiallele_Homo': 0
    }
    
    for call in record.samples:
        sample_id = call.sample
        if sample_id in sample_ids:
            genotype = call['GT']
            alleles = re.split(r'[\/|]', genotype)
            alleles = sorted(alleles)

            # Check for common genotypes and special cases
            if genotype in ['0/0', '0|0']:
                normalized_genotype = '0/0'
            elif genotype in ['0/1', '0|1', '1|0']:
                normalized_genotype = '0/1'
            elif genotype in ['1/1', '1|1']:
                normalized_genotype = '1/1'
            elif genotype in ['0/2', '0|2', '0/3', '0|3', '0/4', '0|4']:
                normalized_genotype = 'Mutli_Allele_Hetero'
            elif genotype in ['2/2', '2|2', '3/3', '3|3', '4/4', '4|4']:
                normalized_genotype = 'Multiallele_Homo'
            else:
                continue  # Skip if genotype is not recognized

            # Increment the count for the identified genotype
            if normalized_genotype in genotypes:
                genotypes[normalized_genotype] += 1
    
    return genotypes

# Input and output files
vcf_file = 'Multiallelic.vcf'
output_file = 'genotype_counts_Multiallele.csv'

# Create CSV file and write header
with open(output_file, 'w', newline='') as csvfile:
    fieldnames = ['Chromosome', 'Position'] + \
                 [f"{group}_{gt}" for group in sample_groups.keys() for gt in ['0/0', '0/1', '1/1', 'Mutli_Allele_Hetero', 'Multiallele_Homo']]
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
    writer.writeheader()

    # Open the VCF file and process
    with open(vcf_file, 'r') as vcf_fh:
        reader = vcf.Reader(vcf_fh)
        for record in reader:
            chrom = record.CHROM
            pos = record.POS
            row = {'Chromosome': chrom, 'Position': pos}
            
            # Iterate over each sample group
            for group, samples in sample_groups.items():
                genotypes = classify_samples_for_variant(record, samples)
                row.update({f"{group}_{gt}": genotypes[gt] for gt in ['0/0', '0/1', '1/1', 'Mutli_Allele_Hetero', 'Multiallele_Homo']})
            
            writer.writerow(row)

print(f"CSV report generated: {output_file}")
