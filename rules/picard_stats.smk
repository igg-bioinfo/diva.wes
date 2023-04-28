

###dopo BSQR

rule picard_pre_HsMetrics:
   input:
       bam="reads/recalibrated/{sample}.dedup.recal.bam"
   output:
       hsProbes=temp("references/{sample}_hsProbes_header"),
       hsTarget=temp("references/{sample}_hsTarget_header")
   conda:
       "../envs/samtools.yaml"
   params:
       hsProbes = lambda wildcards: get_kit(wildcards,samples,enrichment_kit='kit', specific_kit=None)[0],
       hsTarget = lambda wildcards: get_kit(wildcards,samples,enrichment_kit='kit', specific_kit=None)[1]
   threads: config.get("rules").get("picard_pre_HsMetrics").get("threads")
   shell:
       "samtools view -H  {input.bam} | cat - {params.hsProbes} > {output.hsProbes}; "
       "samtools view -H  {input.bam} | cat - {params.hsTarget} > {output.hsTarget}"

rule picard_HsMetrics:
   input:
       bam="reads/recalibrated/{sample}.dedup.recal.bam",
       hsProbes="references/{sample}_hsProbes_header",
       hsTarget="references/{sample}_hsTarget_header"
   output:
       "reads/recalibrated/{sample}.dedup.recal.hs.txt"
   conda:
       "../envs/picard.yaml"
   params:
        custom=java_params(tmp_dir=config.get("tmp_dir"), multiply_by=5),
   benchmark:
       "benchmarks/picard/HsMetrics/{sample}.txt"
   threads: config.get("rules").get("picard_HsMetrics").get("threads")
   shell:
       "picard {params.custom} CollectHsMetrics "
       "INPUT={input.bam} OUTPUT={output} "
       "BAIT_INTERVALS={input.hsProbes} TARGET_INTERVALS={input.hsTarget} "
       "CLIP_OVERLAPPING_READS=false MINIMUM_MAPPING_QUALITY=-1 MINIMUM_BASE_QUALITY=-1 "


rule picard_InsertSizeMetrics:
   input:
      bam="reads/recalibrated/{sample}.dedup.recal.bam"
   output:
       metrics="reads/recalibrated/{sample}.dedup.recal.is.txt",
       histogram="reads/recalibrated/{sample}.dedup.recal.is.pdf"
   conda:
       "../envs/picard.yaml"
   params:
        custom=java_params(tmp_dir=config.get("tmp_dir"), multiply_by=5),
   benchmark:
       "benchmarks/picard/IsMetrics/{sample}.txt"
   threads: config.get("rules").get("picard_InsertSizeMetrics").get("threads")
   shell:
       "picard {params.custom} CollectInsertSizeMetrics "
       "INPUT={input.bam} "
       "OUTPUT={output.metrics} "
       "HISTOGRAM_FILE={output.histogram} "

rule gatk_DepthOfCoverage:
    input:
        cram="reads/recalibrated/{sample}.dedup.recal.cram",
        crai="reads/recalibrated/{sample}.dedup.recal.cram.crai"
    output:
        "reads/recalibrated/{sample}.sample_gene_summary"
    params:
        genome=resolve_single_filepath(*references_abs_path(), config.get("genome_fasta")),
        cov_refseq=resolve_single_filepath(*references_abs_path(),config.get("depthofcov_refseq")),
        cov_intervals=resolve_single_filepath(*references_abs_path(),config.get("depthofcov_intervals")),
        prefix="reads/recalibrated/{sample}"
    conda:
        "../envs/gatk.yaml"
    benchmark:
        "benchmarks/gatk/DepthOfCoverage/{sample}.txt"
    log:
        "logs/gatk/DepthOfCoverage/{sample}.txt"
    threads: 4
    shell:
        "gatk DepthOfCoverage "
        "--omit-depth-output-at-each-base --omit-locus-table "
        "-R {params.genome} "
        "-O {params.prefix} "
        "-I {input.cram} "
        "-gene-list {params.cov_refseq} "
        "--summary-coverage-threshold 10 --summary-coverage-threshold 20 --summary-coverage-threshold 30 "
        "-L {params.cov_intervals} "
        ">& {log} "

rule picard_gc_bias:
    input:
        "reads/recalibrated/{sample}.dedup.recal.bam"
    output:
        chart="qc/picard/{sample}_gc_bias_metrics.pdf",
        summary="qc/picard/{sample}_summary_metrics.txt",
        out="qc/picard/{sample}_gc_bias_metrics.txt"
    params:
        custom=java_params(tmp_dir=config.get("tmp_dir"), multiply_by=5),
        genome=resolve_single_filepath(*references_abs_path(), config.get("genome_fasta")),
        param=config.get("rules").get("picard_gc_bias").get("params"),
        tmp_dir=config.get("tmp_dir")
    log:
        "logs/picard/CollectGcBiasMetrics/{sample}.gcbias.log"
    conda:
       "../envs/picard.yaml"
    threads: conservative_cpu_count(reserve_cores=2, max_cores=config.get("rules").get("picard_gc_bias").get("threads"))
    shell:
        "picard "
        "CollectGcBiasMetrics "
        "{params.custom} "
        "I={input} "
        "R={params.genome} "
        "CHART={output.chart} "
        "S={output.summary} "
        "O={output.out} "




