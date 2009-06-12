#!/usr/bin/perl

# Sample usage:
# ./GetCutSites.pl all_mouse.fa CCGG 60 mouse_CCGG_sites_60bpflank
#
# $ARGV[0] = fasta formated sequence in which we find sites matching the target
#            The header lines in the fasta file are saved and used to identify origin
#            eg "chr1" and were assumed not to contain any whitespace
# $ARGV[1] = target site sequence (eg "CCGG" was used for the original MSCC)
# $ARGV[2] = positive interger, the number of flanking bases to capture.
#            Because later programs scan this sequence for conflicting Mme I sites,
#            it's good to capture at least 60 on each side.
# $ARGV[3] = output file name (eg. "mouse_CCGG_sites_60bpflank")
#
# Output produced contains four columns, tab separated:
# (1) chromosome ID
# (2) location of target site
# (3) flanking + target site DNA sequence
# (4) identifies if from repeat-masked DNA
#
# (4) is "1" if the target site was found with lowercase sequence, which 
# represented repeat-masked sequence in the DNA we used. "0" if in uppercase,
# and therefore non-repetitive.

my $genome = $ARGV[0];
my $cutsite = $ARGV[1];
my $flanking = $ARGV[2];
my $output = $ARGV[3];

open(INPUT,"$genome") or die "Can't open $genome for reading!";
open(OUTPUT,">$output") or die "Can't open $output for writing!";

my $runningseq = "";
my $rawseq = "";
my $scanned_count = 1;         # first base in genomic sequence is position 1
my $chromosome = "";
my $cutsite_placeholder = $cutsite;
$cutsite_placeholder =~ tr/ACGT/acgt/;
while (<INPUT>) {
  if (/^>(.*)\n/) {
    $chromosome = $1;
    $scanned_count = 1;
    $rawseq = "";
    $runningseq = "";
  } else {
    chomp;
    $rawseq = $rawseq . $_;
    tr/acgt/ACGT/;
    # runningseq is an all-capitalized version of rawseq
    $runningseq = $runningseq . $_;
    # look for target site in runningseq (must be capitals)
    if ($runningseq =~ /$cutsite/) {
      my $tempseq = $runningseq;
      # require flanking amount for pulled sites
      while ($tempseq =~ /$cutsite.{$flanking}/) {
        # replace cutsite with lowercase version so next time it doesn't hit the regex
        $tempseq =~ s/(.*?)$cutsite/$1$cutsite_placeholder/;
        my $precut = $1;
        # skip the rest if this doesn't have enough flanking in front of the site
        if (length($precut) < $flanking) {
          next;
        }
        my $cutsite_seq = substr($runningseq, length($precut) - $flanking, length($cutsite) + 2 * $flanking);
        my $cutsite_seq2 = substr($rawseq, length($precut) - $flanking, length($cutsite) + 2 * $flanking);
        my $cutsite_raw = substr($rawseq, length($precut), length($cutsite));
        my $repetitive = 0;
        # if the raw doesn't match uppercase, it must be repeat masked
        if ($cutsite_raw ne $cutsite) {
          $repetitive = 1;
        }
        $cutsite_seq =~ tr/acgt/ACGT/;
        my $position = $scanned_count + length($precut) + 1;
        unless ($cutsite_seq =~ /N/) {
          print OUTPUT "$chromosome\t$position\t$cutsite_seq\t$repetitive\n";
        }
      }
      $runningseq = $tempseq;
    }
    if (length($runningseq) > 400) {
      $scanned_count += length($runningseq) - 400;
      $runningseq = substr($runningseq, length($runningseq) - 400, 400);
      $rawseq = substr($rawseq, length($rawseq) - 400, 400);
    }
  }
}
