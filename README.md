# CNMC_viz

To generate circos plots:
run_circos.sh -o processed data dir -r run_info
  
  The working directory should have the following 3 folders:
  1)somatic : *eff.maf file from CAVATICA somatic calling pipeline*
  2)CNV : *ratio.txt file from CAVATICA somatic calling pipeline*
  3)SV : *sv.vcf file from CAVATICA somatic calling pipleine*
  
  The runinfo file should have the following parameters:
  CIRCOS_PATH: <CIRCOS_PATH>
  KARYOTYPE: <CIRCOS_PATH/data/karyotype/karyotype.human.hg19.txt>
  
This script will run create_circos_config_run.pl,sv2tsv.pl and freec2circos.pl internally to create circos tracks from CNV and SV respectively. For the mutation track we filter genes with the following annotation Nonsense/ Missense/Nonstop/ Frame_Shift/ Splice_Site in the Variant classification column of maf files

