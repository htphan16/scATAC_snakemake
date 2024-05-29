rule convert_bam2bw:
  input:
    config["pseudobulk_bams"] + "/{cell_type}.bam"
  output:
    config["bigWigs"] + "/{cell_type}.bigWig"
  shell:
    "scripts/wrapper.convert_bams_to_bigWigs_sm.sh {input} {output}"
