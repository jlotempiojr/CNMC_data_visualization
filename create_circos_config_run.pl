#!/usr/bin/perl
use strict;
use warnings;

if ( scalar(@ARGV) != 5)
{
print "./CNV_SV_circos.pl CNV.txt SV.txt output_name output_dir gene.txt";
exit 1;
}

my $CNV_file=$ARGV[0];
my $SV_file=$ARGV[1];
my $output_name=$ARGV[2];
my $WORK_DIR=$ARGV[3];
my $output=$WORK_DIR."/".$output_name.".conf";
open OUT,">","$output" or die "opening file: $output";
my $gene_list=$ARGV[4];

print OUT "
karyotype=$KARYOTYPE
show_ticks=yes
show_tick_lables=yes
bands=yes

<plots>
<plot>
type = scatter
file = $CNV_file
r0   = 0.7r
r1   = 0.85r
min  = -1
max  = 10

glyph      = circle
glyph_size = 12
color      = green

<axes>
<axis>
color     = grey
thickness = 2
spacing   = 0.1r
</axis>
</axes>

<backgrounds>
<background>
color = vlgrey
</background>
</backgrounds>

<rules>

<rule>
importance = 100
condition  = var(value) ==1
color = dblue
</rule>

<rule>
importance = 100
condition  = var(value) >=3
color = red
</rule>

</rules>
</plot>


<plot>
type=text
file=$gene_list
r0=1r
r1=1.5r
show_links=no
show_lable=yes
label_size=32p
label_font=condensed

padding=0p
rpadding=0p
</plot>


</plots>





<links>
z =0
color         = lgrey
radius        = 0.7r
bezier_radius = 0.1r

<link>
show = yes
file = $SV_file
thickness     = 0.05
record_limit = 2500
</link>
</links>


<ideogram>

<spacing>
default = 0.01r
break = 0.5r
</spacing>

radius    = 0.7r
thickness = 30p
fill=yes

stroke_color     = black
stroke_thickness = 2p

show_label       = yes
label_font       = condensed
label_radius     = 1r-75p
label_size       = 32p
label_parallel   = yes


</ideogram>
################################################################
## The remaining content is standard and required. It is imported 
## from default files in the Circos distribution.
##
## These should be present in every Circos configuration file and
## overridden as required. To see the content of these files, 
## look in etc/ in the Circos distribution.
#
<image>
## Included from Circos distribution.
<<include etc/image.conf>>
</image>
#
## RGB/HSV color definitions, color lists, location of fonts, fill patterns.
## Included from Circos distribution.
<colors>
<<include etc/colors.conf>>
<<include etc/brewer.conf>>
</colors>
#
<fonts>
<<include etc/fonts.conf>>
</fonts>
#
## Debugging, I/O an dother system parameters
## Included from Circos distribution.
<<include etc/housekeeping.conf>>
chromosomes_units = 1000000
chromosomes_display_default = yes

";


close OUT;


`$CIRCOS_PATH/bin/circos -conf $WORK_DIR/$output_name.conf -png -outputfile $output_name.png -outputdir $WORK_DIR`;
