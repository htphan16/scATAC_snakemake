rule call_peaks:
  input:
    config["pseudobulk_bams"] + "/{cell_type}.bam"
  output:
    directory(config["peaks"] + "/{cell_type}_peaks")
  shell:
    "mkdir -p " + config["peaks"] + ";" + "scripts/wrapper.call_peaks_sm.sh {input} {output}"    
