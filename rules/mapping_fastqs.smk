#rule make_genref:
#  input:
#  output:
#  shell:

rule map_fastqs:
  input:
    fastqs=config["fastqs"] + "/{sample}"
#    ref=
  output:
    config["sample_bams"] + "/{sample}.bam"
  shell:
    "mkdir -p" + config["sample_bams"] + ";scripts/wrapper.mapping_fastqs_cr_sm.sh {input.fastqs} {output}"
