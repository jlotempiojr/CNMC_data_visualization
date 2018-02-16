#!/usr/bin/perl
open IN, $ARGV[0];

while (<IN>) {
	next if /^#/;
	next unless /SVTYPE=BND/;
	next if /IMPRECISE/;
	next if /GL/;
	next if /MT/;
	chomp;
	@F = split;
	$NRD = (split(":",$F[9]))[1];
	($TRD,$PE,$SR) = (split(":",$F[10]))[1,2,3];
	
	next unless $NRD == 0;
	next unless $PE*$SR > 0;
	$start = "hs$F[0] $F[1] $F[1]";
	next if defined $h{$start};
	$h{$start} = 1;
	$F[4]=~s/[\[\]N]//g;
	@f = split(":", $F[4]);
	$end = "hs$f[0] $f[1] $f[1]";
	next if defined $h{$end};
	$h{$end} = 1;

	$TRD = 80 if $TRD > 80;
	print "$start $end thickness=$TRD\n";
}
