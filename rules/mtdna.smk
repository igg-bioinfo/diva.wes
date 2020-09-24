# Freebayes parameters from
# https://galaxyproject.github.io/training-material/topics/variant-analysis/tutorials/non-dip/tutorial.html#calling-non-diploid-variants-with-freebayes
rule freebayes_mtdna:
    input:    
        bams=expand("reads/recalibrated/{sample.sample}.dedup.recal.bam", sample=samples.reset_index().itertuples())
    output:
        "variant_calling/mtDNA.vcf"
    params:
        genome=resolve_single_filepath(*references_abs_path(), config.get("genome_fasta"))
    benchmark:
        "benchmarks/freebayes/mtDNA.txt"
    conda:
       "../envs/freebayes.yaml"
    threads: conservative_cpu_count()
    shell:
        "freebayes "
        "-f {params.genome} "
        "-r chrM:1-16000 "
        "--ploidy 1 "
        "--pooled-discrete --pooled-continuous "
        "--min-mapping-quality 20 "
        "--min-base-quality 30 "
        "{input.bams} "
        "> {output}"
