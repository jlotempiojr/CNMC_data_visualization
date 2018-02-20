# CNMC visualization

To generate circos plots:
run_circos.sh -o processed data dir -r run_info
  
  The working directory should have the following 3 folders:<br />
  1)somatic : *eff.maf file from CAVATICA somatic calling pipeline* <br />
  2)CNV : *ratio.txt file from CAVATICA somatic calling pipeline* <br />
  3)SV : *sv.vcf file from CAVATICA somatic calling pipleine*<br />
  
  The runinfo file should have the following parameters:<br />
  CIRCOS_PATH = <CIRCOS_PATH> <br />
  KARYOTYPE = <CIRCOS_PATH/data/karyotype/karyotype.human.hg19.txt> <br />
  

This script will run create_circos_config_run.pl,sv2tsv.pl and freec2circos.pl internally to create circos tracks from CNV and SV respectively. For the mutation track we filter genes with the following annotation Nonsense/ Missense/Nonstop/ Frame_Shift/ Splice_Site in the Variant classification column of maf files


To generate oncoprint:
1) Annotate genes with snp and cnv 
2) Filter to genes of interest
  Format for snp_count_file:<br />
  101 H3F3  SNP<br />
  \<sample>  \<gene>  \<mutation><br />
  Format for cnv_count_file:<br />
  101 H3F3  gain<br />
  \<sample>  \<gene>  \<copy number><br />
  <br />
  
  Run  <br />
  Rscript oncoprint_cmnc.R snp_file cnv_file sample_key clinical_meta_data working dir
