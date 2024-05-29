rule split_sample_bams:
  input:
    config["sample_bams"] + "/{sample}.bam"
  output:
    directory("bams/bySamples.cellTypes/{sample}")
  params:
    barcodes=config["barcode"],
    cell_types=config["cell_type"]
  shell:
    "mkdir -p bams/bySamples.cellTypes;scripts/wrapper.split_sample_bams_by_cellType_sm.sh {input} {output} {params.barcodes} {params.cell_types}"

rule merge_pseudobulk_bams:
  input:
    expand("bams/bySamples.cellTypes/{sample}", sample=SAMPLES)
  output:
    config["pseudobulk_bams"] + "/{cell_type}.bam"
  shell:
    "mkdir -p " + config["pseudobulk_bams"] + ";scripts/wrapper.merge_pseudobulk_bams_sm.sh {output}"
