import pandas as pd
from snakemake.utils import validate, min_version
##### set minimum snakemake version #####
min_version("5.10.0")


##### load config and sample sheets #####
#configfile: "config.yaml"

## USER FILES ##
samples = pd.read_csv(config["samples"], index_col="sample", sep="\t")
units = pd.read_csv(config["units"], index_col=["unit"], dtype=str, sep="\t")
sets = pd.read_csv(config["sets"], index_col=["set"], dtype=str, sep="\t")
ped = pd.read_csv(config["ped"], header=None, dtype=str, sep="\t", names=['set','sample','father','mother','sex','affected'], index_col=False)
reheader = pd.read_csv(config["reheader"],index_col="Client", dtype=str, sep="\t")
reheader = reheader[reheader["LIMS"].isin(samples.index.values)]

## ---------- ##

##### local rules #####
include:
    "rules/functions.py"

localrules: all, pre_rename_fastq_pe, post_rename_fastq_pe, vcf_to_tabular

rule all:
    input:
#next line execute recalibration step
#        expand("reads/recalibrated/{sample.sample}.dedup.recal.bam", sample=samples.reset_index().itertuples()),
#        expand("reads/recalibrated/{sample.sample}.dedup.recal.hs.txt",sample=samples.reset_index().itertuples()),
#        expand("reads/recalibrated/{sample.sample}.ccds.dedup.recal.hs.txt",sample=samples.reset_index().itertuples()),
#        "qc/multiqc.html",
#next line check relationship between samples
#        "qc/kinship/multiqc_heatmap.html",
#        "qc/bedtools/heatmap_enriched_regions.png",
#        expand("variant_calling/{sample.sample}.g.vcf.gz",sample=samples.reset_index().itertuples()),
#        "db/imports/check",
#        "variant_calling/all.vcf.gz",
#        "variant_calling/mtDNA.vcf",
#        "variant_calling/all.snp_recalibrated.indel_recalibrated.vcf.gz",
#        expand("annotation/{set.set}/annovar/{set.set}.annovar.hg38_multianno.vcf", set=sets.reset_index().itertuples()),
        expand("annotation/{set.set}/vep/{set.set}.vep.vcf", set=sets.reset_index().itertuples()),
        expand("annotation/{set.set}/vep/{set.set}.vep.snpsift.filt.clean.merged.xlsx", set=sets.reset_index().itertuples()),
#        expand("annotation/{set.set}/vep/{set.set}.vep.snpsift.filt.clean.merged.tsv", set=sets.reset_index().itertuples()),



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
    include_prefix + "/annotation.smk"
include:
    include_prefix + "/identity_check.smk"
include:
    include_prefix + "/coverage.smk"
include:
    include_prefix + "/mtdna.smk"

