import pandas as pd
from snakemake.utils import validate, min_version
##### set minimum snakemake version #####
min_version("5.10.0")

## User files ##
samples = pd.read_csv(config["samples"], index_col="sample", sep="\t")
units = pd.read_csv(config["units"], index_col=["unit"], dtype=str, sep="\t")
ped = pd.read_csv(config["ped"], header=None, dtype=str, sep="\t", names=['set','sample','father','mother','sex','affected'], index_col=False)
kits=pd.read_csv(config["kits"],index_col="kit", dtype=str, sep="\t")

## Local rules ##
# When using snakemake profiles to run the pipeline on a computer cluster,
# the following rules will be executed locally instead of being submitted
# by the job scheduler 
localrules: all, pre_rename_fastq_pe, post_rename_fastq_pe, pre_rename_fastq_se, post_rename_fastq_se

## Target files ##
rule all:
    input:
         # Final CRAM
#        expand("reads/recalibrated/{sample.sample}.dedup.recal.cram", sample=samples.reset_index().itertuples()),
         # Coverage statistics on target region
#        expand("reads/recalibrated/{sample.sample}.dedup.recal.hs.txt",sample=samples.reset_index().itertuples()),
         # Coverage statistics on ccds regions
#        expand("reads/recalibrated/{sample.sample}.ccds.dedup.recal.hs.txt",sample=samples.reset_index().itertuples()),
         # Interactive HTML QC report
#        "qc/multiqc.html",
         # Check relationships between each pair of samples
#        "qc/kinship/multiqc_heatmap.html",
         # Coverage plot for selected genes
#        "qc/bedtools/heatmap_enriched_regions.png",
         # Per sample g.vcf
#        expand("variant_calling/{sample.sample}.g.vcf.gz",sample=samples.reset_index().itertuples()),
         # GenomicsDBImport
#        "db/imports/check",
         # Variant calling on mtDNA - experimental
#        "variant_calling/mtDNA.vcf",
         # VCF before recalibration
#        "variant_calling/all.vcf.gz",
         # VCF after recalibration
#        "variant_calling/all.snp_recalibrated.indel_recalibrated.vcf.gz",
         # Final VCF, after genotype count
#        "variant_calling/all.snp_recalibrated.indel_recalibrated.caseControls.vcf.gz",

## Load rules ##
include_prefix="rules"
include:
    include_prefix + "/functions.py"
include:
    include_prefix + "/trimming.smk"
include:
    include_prefix + "/alignment.smk"
include:
    include_prefix + "/samtools.smk"
include:
    include_prefix + "/picard.smk"
include:
    include_prefix + "/bsqr.smk"
include:
    include_prefix + "/picard_stats.smk"
include:
    include_prefix + "/call_variants.smk"
include:
    include_prefix + "/joint_call.smk"
include:
    include_prefix + "/qc.smk"
include:
    include_prefix + "/vqsr.smk"
include:
    include_prefix + "/identity_check.smk"
include:
    include_prefix + "/coverage.smk"
include:
    include_prefix + "/mtdna.smk"
