rule call_cCREs:
  input:
    config["bigWigs"] + "/{cell_type}.bigWig"
  output:
    "active_cCREs/{cell_type}.cCREs.bed"
  shell:
    "scripts/wrapper.call_active_cCREs_sm.sh {input} {output}"    

rule call_bCREs:
  input:
    config["bigWigs"] + "/{cell_type}.bigWig"
  output:
    "active_bCREs/{cell_type}.bCREs.bed"
  shell:
    "scripts/wrapper.call_active_bCREs_sm.sh {input} {output}"
