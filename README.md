# CNMC_viz

To generate circos plots:
run_circos.sh -o processed data dir
  
  The working directory should have the following 3 folders:
  1)somatic : *eff.maf file from CAVATICA somatic calling pipeline*
  2)CNV : *ratio.txt file from CAVATICA somatic calling pipeline*
  3)SV : *sv.vcf file from CAVATICA somatic calling pipleine*
  
This script will run sv2tsv.pl and freec2circos.pl internally to create circos tracks from CNV and SV respectively. For     mutation track we filter genes with the following annotation Nonsense/ Missense/Nonstop/ Frame_Shift/ Splice_Site in the Variant classification column of maf files

