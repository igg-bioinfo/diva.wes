import pandas as pd
from snakemake.utils import validate, min_version
##### set minimum snakemake version #####
min_version("5.10.0")


## USER FILES ##
samples = pd.read_csv(config["samples"], index_col="sample", sep="\t")
units = pd.read_csv(config["units"], index_col=["unit"], dtype=str, sep="\t")
ped = pd.read_csv(config["ped"], header=None, dtype=str, sep="\t", names=['set','sample','father','mother','sex','affected'], index_col=False)

##### local rules #####
include:
    "rules/functions.py"

# When using snakemake profiles to run the pipeline on a computer cluster,
# the following rules will be executed locally instead of being submitted
# by the job scheduler 
localrules: all, pre_rename_fastq_pe, post_rename_fastq_pe

rule all:
    input:
#        expand("reads/recalibrated/{sample.sample}.dedup.recal.cram", sample=samples.reset_index().itertuples()),
#        expand("reads/recalibrated/{sample.sample}.dedup.recal.hs.txt",sample=samples.reset_index().itertuples()),
#        expand("reads/recalibrated/{sample.sample}.ccds.dedup.recal.hs.txt",sample=samples.reset_index().itertuples()),
#        "qc/multiqc.html",
         # Check relationships between each pair of samples
#        "qc/kinship/multiqc_heatmap.html",
#        "qc/bedtools/heatmap_enriched_regions.png",
#        expand("variant_calling/{sample.sample}.g.vcf.gz",sample=samples.reset_index().itertuples()),
#        "db/imports/check",
#        "variant_calling/mtDNA.vcf",
         # VCF file, before recalibration 
#        "variant_calling/all.vcf.gz",
         # Final VCF file, after recalibration 
#        "variant_calling/all.snp_recalibrated.indel_recalibrated.vcf.gz",


include_prefix="rules"
dima_path="dima/"

include:
    dima_path + include_prefix + "/trimming.smk"
include:
    dima_path + include_prefix + "/alignment.smk"
include:
    dima_path + include_prefix + "/samtools.smk"
include:
    dima_path + include_prefix + "/picard.smk"
include:
    dima_path + include_prefix + "/bsqr.smk"
include:
    include_prefix + "/picard_stats.smk"
include:
    include_prefix + "/call_variants.smk"
include:
    include_prefix + "/joint_call.smk"
include:
    include_prefix + "/qc.smk"
include:
    include_prefix + "/vsqr.smk"
include:
    include_prefix + "/identity_check.smk"
include:
    include_prefix + "/coverage.smk"
include:
    include_prefix + "/mtdna.smk"

