#!/usr/bin/perl
use warnings;

my $MISMATCH = 2;

$start = $ARGV[0];
$end = $ARGV[1];
$INCREMENT = $ARGV[2];

my $file1 = "/home/pm23/CCGG_mouse/find_unique_tags/CCGG_tags_18_withdist_shuffled";
my $file2 = "/home/pm23/CCGG_mouse/find_unique_tags/CCGG_tags_18_withdist_alphasort";

my $out = "CCGG_tags_18_upto2MM_${start}_${end}";

my ($tagfilename, $variantfilename, $sortedvariantfilename, $matchfilename);

$tagfilename = "reads_" . $start . "_" . $end;
$variantfilename = $tagfilename . "_variants";
$sortedvariantfilename = $variantfilename . "_sorted";
$matchfilename = $tagfilename . "_matches";

if ($end < $start + $INCREMENT) {
  my $tail = $end - $start;
  `time tail -$tail $file1 > /scratch/$tagfilename`;
} else {
  `time head -$end $file1 | tail -$INCREMENT > /scratch/$tagfilename`;
}

print "/home/pm23/CCGG_mouse/find_unique_tags/GenerateVariants_3MM.pl /scratch/$tagfilename $MISMATCH > /scratch/$variantfilename\n";
`time /home/pm23/CCGG_mouse/find_unique_tags/GenerateVariants_3MM.pl /scratch/$tagfilename $MISMATCH > /scratch/$variantfilename`;
print "sort /scratch/$variantfilename > /scratch/$sortedvariantfilename\n";
`time sort /scratch/$variantfilename > /scratch/$sortedvariantfilename`;
print "rm /scratch/$variantfilename\n";
`rm /scratch/$variantfilename`;
print "join $file2 /scratch/$sortedvariantfilename > /scratch/$matchfilename\n";
`time join $file2 /scratch/$sortedvariantfilename > /scratch/$matchfilename`;
print "rm /scratch/$sortedvariantfilename\n";
`rm /scratch/$sortedvariantfilename`;
print "sort --key=9,9 --key=10n,10 --key=11,11 --key=17n,17 /scratch/$matchfilename > /scratch/${out}_sorted\n";
`time sort --key=9,9 --key=10n,10 --key=11,11 --key=17n,17 /scratch/$matchfilename > /scratch/${out}_sorted`;
print "/home/pm23/CCGG_mouse/find_unique_tags/CountMatches.pl /scratch/${out}_sorted > /scratch/${out}_counts\n";
`time /home/pm23/CCGG_mouse/find_unique_tags/CountMatches.pl /scratch/${out}_sorted > /scratch/${out}_counts`;
`cp /scratch/${out}_counts /home/pm23/CCGG_mouse/find_unique_tags/${out}_counts`;

`rm /scratch/$tagfilename`;
`rm /scratch/$matchfilename`;
`rm /scratch/${out}_sorted`;
`rm /scratch/${out}_counts`;
