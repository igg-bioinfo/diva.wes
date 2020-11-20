

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



# rule pre_rename_bam_ccds:
#     input:
#         bam="reads/recalibrated/{sample}.dedup.recal.bam",
#         bai="reads/recalibrated/{sample}.dedup.recal.bam.bai"
#     output:
#         ccds_bam="reads/recalibrated/{sample}.ccds.dedup.recal.bam",
#         ccds_bai="reads/recalibrated/{sample}.ccds.dedup.recal.bam.bai"
#     shell:
#         "ln -s {input.bam} {output.ccds_bam} &&"
#         "ln -s {input.bai} {output.ccds_bai} "
#
# rule picard_pre_HsCCDS_Metrics:
#    input:
#        bam="reads/recalibrated/{sample}.ccds.dedup.recal.bam"
#    output:
#        hsProbes=temp("references/{sample}.ccds_hsProbes_header"),
#        hsTarget=temp("references/{sample}.ccds_hsTarget_header")
#    conda:
#        "../envs/samtools.yaml"
#    params:
#         hsProbes = lambda wildcards: resolve_single_filepath(*references_abs_path(), config.get("intervals").get(config.get("samples_intervals").get(wildcards.sample, config["intervals_ccds"])).get("hsProbes")),
#         hsTarget = lambda wildcards: resolve_single_filepath(*references_abs_path(), config.get("intervals").get(config.get("samples_intervals").get(wildcards.sample, config["intervals_ccds"])).get("hsTarget")),
#    shell:
#        "samtools view -H  {input.bam} | cat - {params.hsProbes} > {output.hsProbes}; "
#        "samtools view -H  {input.bam} | cat - {params.hsTarget} > {output.hsTarget}"
#
# rule picard_HsCCDS_Metrics:
#    input:
#        bam="reads/recalibrated/{sample}.ccds.dedup.recal.bam",
#        hsProbes="references/{sample}.ccds_hsProbes_header",
#        hsTarget="references/{sample}.ccds_hsTarget_header"
#    output:
#        "reads/recalibrated/{sample}.ccds.dedup.recal.hs.txt"
#    conda:
#        "../envs/picard.yaml"
#    params:
#         custom=java_params(tmp_dir=config.get("tmp_dir"), multiply_by=5),
#    benchmark:
#        "benchmarks/picard/HsMetrics/{sample}.ccds.txt"
#    shell:
#        "picard {params.custom} CollectHsMetrics "
#        "INPUT={input.bam} OUTPUT={output} "
#        "BAIT_INTERVALS={input.hsProbes} TARGET_INTERVALS={input.hsTarget} "
#        "CLIP_OVERLAPPING_READS=false MINIMUM_MAPPING_QUALITY=-1 MINIMUM_BASE_QUALITY=-1 "


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




