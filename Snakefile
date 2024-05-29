configfile: "config.yaml"

samples_file = "metadata/" + str(config["sample"])
cell_types_file = "metadata/" + str(config["cell_type"])

with open(cell_types_file, 'r') as f:
  lines = f.readlines()

CELL_TYPES = [line.strip() for line in lines]

with open(samples_file, 'r') as f:
  lines = f.readlines()

SAMPLES = [line.strip() for line in lines]
 
rule all:
  input:
    expand("active_cCREs/{cell_type}.cCREs.bed", cell_type=CELL_TYPES),
    expand(config["peaks"] + "/{cell_type}_peaks", cell_type=CELL_TYPES)

if config["format"] == "bigWig":
  include: "rules/call_active_cCREs.smk"
  include: "rules/call_active_peaks_published.smk"
elif config["format"] == "bam" and config["bam_type"] == "pseudobulk":
  include: "rules/convert_bams_to_bigWigs.smk"
  include: "rules/call_peaks.smk"
#  include: "rules/convert_bedGraphs_to_bigWigs.smk"
  include: "rules/call_active_cCREs.smk"
  include: "rules/call_active_peaks_published.smk"
elif config["format"] == "bam" and config["bam_type"] == "sample":
  if config["annotation"] == True:
    include: "rules/split_sample_bams_to_cell_type_bams.smk"
    include: "rules/convert_bams_to_bigWigs.smk"
    include: "rules/call_peaks.smk"
#    include: "rules/convert_bedGraphs_to_bigWigs.smk"
    include: "rules/call_active_cCREs.smk"
    include: "rules/call_active_peaks_published.smk"
elif config["format"] == "fastq":
  include: "rules/mapping_fastqs.smk"
  include: "rules/split_sample_bams_to_cell_type_bams.smk"
  include: "rules/convert_bams_to_bigWigs.smk"
  include: "rules/call_peaks.smk"
#  include: "rules/convert_bedGraphs_to_bigWigs.smk"
  include: "rules/call_active_cCREs.smk"
  include: "rules/call_active_peaks_published.smk"
