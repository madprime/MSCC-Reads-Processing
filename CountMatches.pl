#!/usr/bin/perl

# usage:
# ./CountMatches.pl subset_variants_matched_sorted > subset_matches

use warnings;
use strict;

my $matchfile = $ARGV[0];

open(MATCH,$matchfile);

my $tagseq = "";
my $unique = 0;
my $mm1 = 0;
my $mm2 = 0;
my @lastmatchdata = ();
while (<MATCH>) {
  my @matchdata = split;
  if (@lastmatchdata and ($lastmatchdata[8] eq $matchdata[8]) and ($lastmatchdata[9] eq $matchdata[9]) and ($lastmatchdata[10] eq $matchdata[10])) {
    if ($matchdata[16] == 0) {
      $unique++;
    } elsif ($matchdata[16] == 1) {
      $mm1++;
    } elsif ($matchdata[16] == 2) {
      $mm2++;
    }
  } else {
    if (@lastmatchdata) {
      my @printdata = @lastmatchdata[8..14];
      print "$tagseq @printdata $unique $mm1 $mm2\n";
    }
    $tagseq = $matchdata[0];
    if ($matchdata[16] == 0) {
      $unique = 1;
      $mm1 = $mm2 = 0;
    } else {
      die;
    }
  }
  @lastmatchdata = @matchdata;
}
my @printdata = @lastmatchdata[8..14];
print "$tagseq @printdata $unique $mm1 $mm2\n";




