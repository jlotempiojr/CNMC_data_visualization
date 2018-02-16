#! /usr/bin/env bash
## Questions/Recommendations/Concerns: Contact gaonkark@chop.email.edu

usage ()
{
cat << EOF
##      run_circos.sh -o secondary output directory
##      -o      <processed data parent directory>
##      -r      <Not needed yet, may need run_info if we want to change the criteria for filtering>
##      -h      <help>


EOF
}
echo "Options specified: $@"

while getopts ":o:h" OPTION; do
  case $OPTION in
        h) usage
        exit ;;
        o) output_dir=$OPTARG ;;
        \?) echo "Invalid option: -$OPTARG. See output file for usage."
       usage
       exit ;;
    :) echo "Option -$OPTARG requires an argument. See output file for usage."
       usage
       exit ;;
  esac
done

echo $output_dir


if [[ -z "$output_dir" ]]
then
        echo "Must provide at least required options. See output file for usage."
        usage
        exit 1;
fi

##source $run_info##

# filter somatic calls
for file in $(ls $output_dir/somatic/*eff.maf);do head -2 $file > $output_dir/somatic/$(basename $file .eff.maf).filtered.txt; awk -F "\t" '{if($9~/Nonsense/ || $9 ~/Missense/ || $9~/Nonstop/ || $9 ~/Frame_Shift/ || $9 ~/Splice_Site/) print "hs"$5"\t"$6"\t"$7"\t"$1"_"$37}' $file> $output_dir/somatic/$(basename $file .eff.maf).circos.txt;done

# filter cnv calls
for file in $(ls $output_dir/CNV/*ratio.txt);do perl freec2circos.pl -f $file -p 2 > $output_dir/CNV/$(basename $file .txt).circos.txt;done


# filter sv calls
for file in $(ls $output_dir/SV/*vcf);do perl sv2tsv.pl $file >$output_dir/SV/$(basename $file .vcf).circos.txt;done

# run circos 
for file in $(ls $output_dir/SV/*.sv.vcf); do name=$(basename $file .sv.vcf); perl create_circos_config_run.pl $output_dir/CNV/$name*circos.txt $output_dir/SV/$name*circos.txt $name $output_dir/Circos $output_dir/somatic/$name*circos.txt;done  


