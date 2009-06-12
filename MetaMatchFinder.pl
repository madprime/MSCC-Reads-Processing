#!/usr/bin/perl

my $INCREMENT = 2000;

my $LINES = 3240786;

use strict;
use warnings;

for (my $i = 0; $i < $LINES; $i+=$INCREMENT) {
  my $start = $i;
  my $end = $i + $INCREMENT;

  if ($end > $LINES) {
    $end = $LINES;
  }

  print "submitting $start to $end run...\n";
  `bsub -q shared_2h /home/pm23/CCGG_mouse/find_unique_tags/MatchFinder.pl $start $end $INCREMENT`

}
