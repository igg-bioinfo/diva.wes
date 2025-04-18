rule cnvkit_target:
    input:    
        cram="reads/recalibrated/{sample}.dedup.recal.cram",
        crai="reads/recalibrated/{sample}.dedup.recal.cram.crai"
    output:
        "cnvkit/{sample}.targetcoverage.cnn"
    conda:
       "../envs/cnvkit.yaml"
    params:
        genome=resolve_single_filepath(*references_abs_path(), config.get("genome_fasta")),
        target = lambda wildcards: get_kit(wildcards,samples,enrichment_kit='kit', specific_kit=None)[2]      
    log:
        "logs/cnvkit/{sample}.cnvkit_coverage_target.log"
    benchmark:
        "benchmarks/cnvkit/{sample}.cnvkit_coverage_target.txt"
    threads: config.get("rules").get("cnvkit_target").get("threads")
    shell:
        "cnvkit.py coverage "
        "-f {params.genome} {input.cram} "        
        "{params.target} "
        "-o {output} "
        "> {log}"

rule cnvkit_antitarget:
    input:    
        cram="reads/recalibrated/{sample}.dedup.recal.cram",
        crai="reads/recalibrated/{sample}.dedup.recal.cram.crai"
    output:
        "cnvkit/{sample}.antitargetcoverage.cnn"
    conda:
       "../envs/cnvkit.yaml"
    params:
        genome=resolve_single_filepath(*references_abs_path(), config.get("genome_fasta")),
        antitarget = lambda wildcards: get_kit(wildcards,samples,enrichment_kit='kit', specific_kit=None)[3]
    log:
        "logs/cnvkit/{sample}.cnvkit_coverage_antitarget.log"
    benchmark:
        "benchmarks/cnvkit/{sample}.cnvkit_coverage_antitarget.txt"
    threads: config.get("rules").get("cnvkit_antitarget").get("threads")
    shell:
        "cnvkit.py coverage "
        "-f {params.genome} {input.cram} "
        "{params.antitarget} "
        "-o {output} "
        "> {log}"

rule cnvkit_fix:
    input:
        target = rules.cnvkit_target.output,
        antitarget = rules.cnvkit_antitarget.output
    output:
        "cnvkit/{sample}.cnr"
    params:
        reference = lambda wildcards: get_kit(wildcards,samples,enrichment_kit='kit', specific_kit=None)[4]
    log:
        "logs/cnvkit/{sample}.cnvkit_fix.log"
    benchmark:
        "benchmarks/cnvkit/{sample}.cnvkit_fix.txt"
    conda:
        "../envs/cnvkit.yaml"
    threads: config.get("rules").get("cnvkit_fix").get("threads")
    shell:
        "cnvkit.py fix "
        "{input.target} "
        "{input.antitarget} "
        "{params.reference} "
        "-o {output} "
        "> {log}"

# single sample
rule cnvkit_segment:
    input:
        rules.cnvkit_fix.output
    output:
        temp("cnvkit/{sample}.cns")
    params:
        segmentation_algorithm="hmm-germline" # default "cbs"
    log:
        "logs/cnvkit/{sample}.cnvkit_segment.log"
    benchmark:
        "benchmarks/cnvkit/{sample}.cnvkit_segment.txt"
    conda:
        "../envs/cnvkit.yaml"
    threads: config.get("rules").get("cnvkit_segment").get("threads")
    shell:
        "cnvkit.py segment "
        "{input} "
        "-m {params.segmentation_algorithm} "
        "-o {output} "
        "> {log}"

# single sample
rule cnvkit_segmetrics:
    input:
        bins=rules.cnvkit_fix.output,
        segments=rules.cnvkit_segment.output
    output:
        temp("cnvkit/{sample}.segmetrics.output")
    params:
        metrics="--ci --pi"
    log:
        "logs/cnvkit/{sample}.cnvkit_segmetrics.log"
    benchmark:
        "benchmarks/cnvkit/{sample}.cnvkit_segmetrics.txt"
    conda:
        "../envs/cnvkit.yaml"
    threads: config.get("rules").get("cnvkit_segmetrics").get("threads")
    shell:
        "cnvkit.py segmetrics "
        "{input.bins} "
        "-s {input.segments} "
        "-o {output} "
        "{params.metrics} "
        "> {log}"

# single sample
rule cnvkit_call:
    input:
        rules.cnvkit_segmetrics.output
    output:
        temp("cnvkit/{sample}.call")
    params:
        filter="--filter ci",
        method="threshold",
        thresholds="-t=-2,-0.415,0.32,0.8,1.1"
    log:
        "logs/cnvkit/{sample}.cnvkit_call.log"
    benchmark:
        "benchmarks/cnvkit/{sample}.cnvkit_call.txt"
    conda:
        "../envs/cnvkit.yaml"
    threads: config.get("rules").get("cnvkit_call").get("threads")
    shell:
        "cnvkit.py call "
        "{input} "
        "{params.filter} "
        "-m {params.method} "
        "{params.thresholds} "
        "-o {output} "
        "> {log}"

# single sample
rule cnvkit_export:
    input:
        rules.cnvkit_call.output
    output:
        gz="cnvkit/{sample}.cnv.vcf.gz",
        tbi="cnvkit/{sample}.cnv.vcf.gz.tbi"
    log:
        "logs/cnvkit/{sample}.export.log"
    conda:
        "../envs/cnvkit.yaml"
    threads: config.get("rules").get("cnvkit_export").get("threads")
    shell:
        "cnvkit.py export vcf "
        "{input} "
        "2> {log} | bgzip > {output.gz} && tabix -p vcf {output.gz}"

# single sample
rule cnvkit_export_seg:
    input:
        rules.cnvkit_segment.output
    output:
        "cnvkit/{sample}.seg"
    log:
        "logs/cnvkit/{sample}.export_seg.log"
    benchmark:
        "benchmarks/cnvkit/{sample}.cnvkit_export_seg.txt"
    conda:
        "../envs/cnvkit.yaml"
    threads: config.get("rules").get("cnvkit_export_seg").get("threads")
    shell:
        "cnvkit.py export seg "
        "{input} "
        "-o {output} "
        "> {log}"

# single sample
rule cnvkit_plot_scatter:
    input:
        segment=rules.cnvkit_segment.output,
        bin=rules.cnvkit_fix.output
    output:
        "cnvkit/{sample}.cnv.scatter.png"
    params:
        sample_name="{sample}",
        segment_color="red",
        limits="--y-min -5 --y-max 5"
        # regions="-c chrN:start-end"
    log:
        "logs/cnvkit/{sample}.scatter.log"
    conda:
        "../envs/cnvkit.yaml"
    shell:
        "cnvkit.py scatter "
        "-s {input.segment} "
        "-s {input.bin} "
        "--segment-color {params.segment_color} "
        "-i {params.sample_name} "
        "{params.limits} "
        "-o {output} "
        "> {log}"

# single sample
#rule cnvkit_plot_diagram:
#    input:
#        rules.cnvkit_segment.output
#    output:
#        "cnvkit/{sample}.cnv.diagram.pdf"
#    params:
#        probes="5", # minimum number of covered probes to label a gene (default 3)
#        threshold="0.7" # Copy number change threshold to label genes (default 0.5)
#    log:
#        "logs/cnvkit/{sample}.diagram.log"
#    conda:
#        "../envs/cnvkit.yaml"
#    shell:
#        "cnvkit.py diagram "
#        "-s {input} "
#        "-m {params.probes} "
#        "-t {params.threshold} "
#        "-o {output} "
#        "> {log}"

# multiple-sample
#rule cnvkit_plot_heatmap:
#    input:
#        expand(rules.cnvkit_segment.output,sample=samples.reset_index().itertuples())
#    output:
#        "cnvkit/{sample}.cnv.heatmap.png"
#    params:
#        params="-d"
#        # regions="-c chrN:start-end"
#    log:
#        "logs/cnvkit/{sample}.heatmap.log"
#    conda:
#        "../envs/cnvkit.yaml"
#    shell:
#        "cnvkit.py heatmap "
#        "{input} "
#        "{params.params} "
#        "-o {output} "
#        "> {log}"

