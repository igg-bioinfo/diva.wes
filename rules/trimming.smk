
def get_fastq(wildcards,units):
    # print(wildcards.unit)
    if units.loc[wildcards.unit,["fq2"]].isna().all():
        print("SE")
        # print(units.loc[wildcards.unit,["fq1"]].dropna()[0])
        return units.loc[wildcards.unit,["fq1"]].dropna()[0]
    else:
        print("PE")
        # print(units.loc[wildcards.unit,["fq1"]].dropna()[0],units.loc[wildcards.unit,["fq2"]].dropna()[0])
        return units.loc[wildcards.unit,["fq1"]].dropna()[0],units.loc[wildcards.unit,["fq2"]].dropna()[0]


rule pre_rename_fastq_pe:
    input:
        lambda wildcards: get_fastq(wildcards,units)
    output:
        r1=temp("reads/untrimmed/{unit}-R1.fq.gz"),
        r2=temp("reads/untrimmed/{unit}-R2.fq.gz")
    shell:
        "ln -s {input[0]} {output.r1} &&"
        "ln -s {input[1]} {output.r2} "

rule pre_rename_fastq_se:
    input:
       lambda wildcards: get_fastq(wildcards,units)
    output:
        r1="reads/untrimmed/se/{unit}-R1.fq.gz"
    shell:
        "ln -s {input} {output.r1} "


rule fastp_pe:
    input:
       r1=temp("pre_rename_fastq_pe.output.r1"),
       r2=temp("pre_rename_fastq_pe.output.r2")
    output:
        r1=temp("reads/trimmed/{unit}-R1-trimmed.fq.gz"),
        r2=temp("reads/trimmed/{unit}-R2-trimmed.fq.gz"),
        json="reads/trimmed/{unit}.fastp.json",
        html="reads/trimmed/{unit}.fastp.html"
    log:
        "logs/fastp_pe/{unit}.log"
    benchmark:
        "benchmarks/fastp_pe/{unit}.txt"
    conda:
        "../envs/fastp.yaml"
    threads: config.get("rules").get("fastp_pe").get("threads")
    shell:
        "fastp "
        "--in1 {input.r1} "
        "--in2 {input.r2} "
        "--thread {threads} "
        "--detect_adapter_for_pe "
        "--json {output.json} "
        "--html {output.html} "
        "--out1 {output.r1} "
        "--out2 {output.r2} "
        ">& {log}"

rule fastp_se:
    input:
       r1=temp("pre_rename_fastq_se.output.r1")
    output:
       r1=temp("reads/trimmed/{unit}-R1-trimmed.fq.gz"),
       json="reads/trimmed/{unit}.fastp.json",
       html="reads/trimmed/{unit}.fastp.html"
    log:
        "logs/fastp_se/{unit}.log"
    benchmark:
        "benchmarks/fastp_se/{unit}.txt"
    conda:
        "../envs/fastp.yaml"
    threads: config.get("rules").get("fastp_se").get("threads")
    shell:
        "fastp "
        "--in1 {input.r1} "
        "--thread {threads} "
        "--json {output.json} "
        "--html {output.html} "
        "--out1 {output.r1} "
        ">& {log}"

def get_trimmed_reads(wildcards,units):
    print(wildcards.unit)
    if units.loc[wildcards.unit,["fq2"]].isna().all():
        # SE
        return rules.fastp_se.output
    # PE
    else:
        return rules.fastp_pe.output.r1,rules.fastp_pe.output.r2
