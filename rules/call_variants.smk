
rule gatk_HaplotypeCaller_ERC_GVCF:
    input:    
        cram="reads/recalibrated/{sample}.dedup.recal.cram",
        crai="reads/recalibrated/{sample}.dedup.recal.cram.crai"
    output:
        gvcf="variant_calling/{sample}.g.vcf.gz"
    conda:
       "../envs/gatk.yaml"
    params:
        custom=java_params(tmp_dir=config.get("tmp_dir"), multiply_by=5),
        intervals = resolve_single_filepath(*references_abs_path(),config.get("refseq_intervals")),
        genome=resolve_single_filepath(*references_abs_path(), config.get("genome_fasta"))
    log:
        "logs/gatk/HaplotypeCaller/{sample}.genotype_info.log"
    benchmark:
        "benchmarks/gatk/HaplotypeCaller/{sample}.txt"
    threads: config.get("rules").get("gatk_HaplotypeCaller_ERC_GVCF").get("threads")
    shell:
        "gatk HaplotypeCaller --java-options {params.custom} "
        "-R {params.genome} "
        "-I {input.cram} "
        "-O {output.gvcf} "
        "-ERC GVCF "
        "-L {params.intervals} "
        "-ip 200 "
        "-G StandardAnnotation "
        # "--use-new-qual-calculator "
        ">& {log}"
