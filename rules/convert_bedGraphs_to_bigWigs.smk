rule convert_bg2bw:
  input:
    config["peaks"]
  output:
    directory(config["peaks_bigWigs"])
  params:
    cell_types=config["cell_type"]
  shell:
    "scripts/wrapper.convert_bedGraphs_to_bigWigs_sm.sh {input} {params.cell_types} {output}"    
