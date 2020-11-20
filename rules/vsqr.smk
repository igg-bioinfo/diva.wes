
# https://docs.python.org/dev/whatsnew/3.5.html#pep-448-additional-unpacking-generalizations
def _get_recal_params(wildcards):
    known_variants = resolve_multi_filepath(*references_abs_path(), config["known_variants"])
    if wildcards.type == "snp":
        return (
            "-mode SNP "
            "--max-gaussians 4 "
            "-an QD -an MQ -an MQRankSum -an ReadPosRankSum -an FS -an SOR "
            "-resource:hapmap,known=false,training=true,truth=true,prior=15.0 {hapmap} "
            "-resource:omni,known=false,training=true,truth=true,prior=12.0 {omni} "
            "-resource:1000G,known=false,training=true,truth=false,prior=10.0 {g1k} "
            "-resource:dbsnp,known=true,training=false,truth=false,prior=2.0 {dbsnp}"
        ).format(**known_variants)
    else:
        return (
            "-mode INDEL " 
            "-an QD -an FS -an SOR -an MQRankSum -an ReadPosRankSum "
            "--max-gaussians 4 "
            "-resource:mills,known=false,training=true,truth=true,prior=12.0 {mills} "
            "-resource:dbsnp,known=true,training=false,truth=false,prior=2.0 {dbsnp}"
        ).format(**known_variants)


rule gatk_VariantRecalibrator:
    input:
        resolve_multi_filepath(*references_abs_path(), config["known_variants"]).values(),
        vcf="variant_calling/{prefix}.vcf.gz"
    output:
        recal=temp("variant_calling/{prefix}.{type,(snp|indel)}.recal"),
        tranches=temp("variant_calling/{prefix}.{type,(snp|indel)}.tranches"),
        plotting=temp("variant_calling/{prefix}.{type,(snp|indel)}.plotting.R")
    params:
        recal=_get_recal_params,
        custom=java_params(tmp_dir=config.get("tmp_dir"),multiply_by=2),
        genome=resolve_single_filepath(*references_abs_path(), config.get("genome_fasta"))
    log:
        "logs/gatk/VariantRecalibrator/{prefix}.{type}_recalibrate_info.log"
    conda:
        "../envs/gatk.yaml"
    benchmark:
        "benchmarks/gatk/VariantRecalibrator/{prefix}.{type}_recalibrate_info.txt"
    threads: conservative_cpu_count(reserve_cores=2, max_cores=config.get("rules").get("gatk_VariantRecalibrator").get("threads"))
    shell:
        "gatk VariantRecalibrator --java-options {params.custom} "
        "-R {params.genome} "
        "-V {input.vcf} "
        "{params.recal} "
        "-tranche 100.0 -tranche 99.9 -tranche 99.0 -tranche 90.0 "
        "--output {output.recal} "
        "--tranches-file {output.tranches} "
        "--rscript-file {output.plotting} "
        ">& {log}"
      

rule gatk_ApplyVQSR:
    input:
        vcf="variant_calling/{prefix}.vcf.gz",
        recal="variant_calling/{prefix}.{type}.recal",
        tranches="variant_calling/{prefix}.{type}.tranches"
    output:
        "variant_calling/{prefix}.{type,(snp|indel)}_recalibrated.vcf.gz"
    conda:
        "../envs/gatk.yaml"
    params:
        mode=lambda wildcards: wildcards.type.upper(),
        custom=java_params(tmp_dir=config.get("tmp_dir"), multiply_by=2),
        genome=resolve_single_filepath(*references_abs_path(), config.get("genome_fasta"))
    log:
        "logs/gatk/ApplyVQSR/{prefix}.{type}_recalibrate.log"
    benchmark:
        "benchmarks/gatk/ApplyVQSR/{prefix}.{type}_recalibrate.txt"
    threads: conservative_cpu_count(reserve_cores=2, max_cores=config.get("rules").get("gatk_ApplyVQSR").get("threads"))
    shell:
        "gatk  ApplyVQSR --java-options {params.custom} "
        "-R {params.genome} "
        "-V {input.vcf} -mode {params.mode} "
        "--recal-file {input.recal} -ts-filter-level 99.0 "
        "--tranches-file {input.tranches} -O {output} "
        ">& {log}"


rule snpSift_caseControl_all:
    input:
        "variant_calling/all.snp_recalibrated.indel_recalibrated.vcf.gz"        
    output:
        vcf='variant_calling/all.snp_recalibrated.indel_recalibrated.caseControls.vcf.gz',
        index='variant_calling/all.snp_recalibrated.indel_recalibrated.caseControls.vcf.gz.tbi'
    params:
        ped=config.get("ped")
    benchmark:
        "benchmarks/gatk/SelectVariants/all.snp_recalibrated.indel_recalibrated.caseControls.txt"
    conda:
       "../envs/snpsift.yaml"
    threads: config.get("rules").get("snpSift_caseControl_all").get("threads")
    shell:
        "SnpSift caseControl "
        "-tfam {params.ped} "
        "-name _ALL "
        "{input} "
        "| bgzip -c "
        "> {output.vcf} && "
        "tabix -p vcf {output.vcf}"
