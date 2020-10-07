rule gatk_SelectVariants:
    input:
        vcf="variant_calling/all.snp_recalibrated.indel_recalibrated.vcf.gz",
        #lambda wildcards: get_sample_by_set(wildcards, sets)
    output:
        vcf="variant_calling/SelectVariants/{set}.selected.vcf"
    params:
        custom=java_params(tmp_dir=config.get("tmp_dir"), multiply_by=5),
        genome=resolve_single_filepath(*references_abs_path(), config.get("genome_fasta")),
        arguments=_multi_flag(config.get("rules").get("gatk_SelectVariants").get("arguments")),
#        samples_files=_get_samples_set(config.get("rules").get("gatk_SelectVariants").get("samples_files"))
        samples=lambda wildcards: get_sample_by_set(wildcards, sets)
    log:
        "logs/gatk/SelectVariants/{set}.SelectVariants.log"
    benchmark:
        "benchmarks/gatk/SelectVariants/{set}.SelectVariants.txt"
    conda:
       "../envs/gatk.yaml"

    shell:
        "gatk SelectVariants "
        "--java-options {params.custom} "
        "-R {params.genome} "
        "-V {input.vcf} "
        "{params.samples} "
        "-O {output.vcf} "
        "{params.arguments} "
#        "{params.samples_files} "

rule annovar:
    input:
        vcf="variant_calling/SelectVariants/{set}.selected.vcf"
    output:
        vcf='annotation/{set}/annovar/{set}.annovar.hg38_multianno.vcf'
    params:
        program=config.get("rules").get("annovar").get("program"),        
        db=config.get("rules").get("annovar").get("db"),
        build=config.get("rules").get("annovar").get("build"),        
        prefix='annotation/{set}/annovar/annovar', 
        arguments=config.get("rules").get("annovar").get("arguments")
    benchmark:
        "benchmarks/annovar/{set}.annovar.txt"
    threads: conservative_cpu_count(reserve_cores=2, max_cores=6)
    shell:
        "{params.program} "
        "{input.vcf} "
        "{params.db} "
        "-buildver {params.build} "
        "-out {params.prefix} "
        "{params.arguments}"

rule vep:
    input:
        vcf="variant_calling/SelectVariants/{set}.selected.vcf"
    output:
        vcf='annotation/{set}/vep/{set}.vep.vcf',
        stats='annotation/{set}/vep/{set}.stats.html'
    params:
        arguments=_multi_flag(config.get("rules").get("vep").get("arguments")),
        g2p=lambda wildcards: g2p_command(wildcards, ped, config.get("rules").get("vep").get("g2p")),
        species=config.get("rules").get("vep").get("species"),
        assembly=config.get("rules").get("vep").get("assembly"),
        cache_dir=config.get("rules").get("vep").get("cache_dir"),
        log='annotation/{set}/vep/warnings_vcf.log'
    benchmark:
        "benchmarks/vep/{set}.vep.txt"
    conda:
       "../envs/vep.yaml"
    threads: conservative_cpu_count(reserve_cores=2, max_cores=6)
    shell:
        "vep --cache --format vcf --vcf --offline --pick "
        "-i {input.vcf} "
        "-o {output.vcf} "
        "{params.arguments} "
        "{params.g2p} "
        "--fork {threads} "
        "--warning_file {params.log} "
        "--stats_file {output.stats} "
        "--species {params.species} "
        "--assembly {params.assembly} "
        "--dir_cache {params.cache_dir}"

rule snpSift_caseControl:
    input:
        rules.vep.output.vcf
    output:
        'annotation/{set}/vep/{set}.vep.snpsift.vcf'
    params:
        ped=config.get("ped")
    benchmark:
        "benchmarks/vep/{set}.snpSift_caseControl.txt"
    conda:
       "../envs/snpsift.yaml"
    threads: conservative_cpu_count(reserve_cores=2, max_cores=6)
    shell:
        "SnpSift caseControl "
        "-tfam {params.ped} "
        "{input} "
        "> {output}"

rule filter_vep:
    input:
        rules.snpSift_caseControl.output
    output:
        'annotation/{set}/vep/{set}.vep.snpsift.filt.vcf'
    params:
        arguments=_multi_flag(config.get("rules").get("filter_vep").get("arguments"))
    benchmark:
        "benchmarks/vep/{set}.filter_vep.txt"
    conda:
       "../envs/vep.yaml"
    threads: conservative_cpu_count(reserve_cores=2, max_cores=6)
    shell:
        "filter_vep --format vcf "
        "-i {input} "
        "-o {output} "
        "{params.arguments}"

# Remove fields from VCF
rule bcftools_remove:
    input:
       rules.filter_vep.output
    output:
       'annotation/{set}/vep/{set}.vep.snpsift.filt.clean.vcf'
    conda:
        "../envs/bcftools.yaml"
    params:
        fields_to_remove=config.get("rules").get("bcftools_remove").get("fields_to_remove")
    shell:
        "bcftools annotate "
        "-x {params.fields_to_remove} "
        "-o {output} "
        "{input}"

rule vcf_to_tabular:
    input:
       rules.bcftools_remove.output
    output:
       'annotation/{set}/vep/{set}.vep.snpsift.filt.clean.tsv'
    params:
       script='../rules/scripts/vcf_to_tabular_futurized.py',
       params=config.get("rules").get("vcf_to_tabular").get("params")
    conda:
        "../envs/future.yaml"
    shell:
        "python {params.script} {params.params} {input} {output}"

# Merge filtered VCF and VEP annotations
rule vep_to_tsv:
    input:
        vep=rules.filter_vep.output,
        tsv=rules.vcf_to_tabular.output
    output:
        'annotation/{set}/vep/{set}.vep.snpsift.filt.clean.merged.tsv'
    params:
        fields=config.get("rules").get("vep_to_tsv").get("fields")
    benchmark:
        "benchmarks/vep/{set}.vep_to_tsv.txt"
    conda:
       "../envs/vatools.yaml"
    threads: conservative_cpu_count()
    shell:
        "vep-annotation-reporter "
        "-t {input.tsv} "
        "-o {output} "
        "{input.vep} "
        "{params.fields}"


rule tsv_to_excel:
    input:
       rules.vep_to_tsv.output
    output:
       'annotation/{set}/vep/{set}.vep.snpsift.filt.clean.merged.xlsx'
    params:
       script='../rules/scripts/tabular_to_excel.py'
    conda:
        "../envs/excel.yaml"
    shell:
       "python {params.script} "
       "-i {input} "
       "-o {output}"

