#!/usr/bin/perl -w

use warnings;
use strict;

my $readfile = $ARGV[0];

my $numvariants = $ARGV[1];
# can be 0, 1, 2, or 3.


my @BASES = ("A","C","G","T");

# now, go through the readfile to generate variants
open(INPUT,$readfile) or die "can't open $readfile for reading!";
while(<INPUT>) {
  my @data = split;
  my $read = shift(@data);

  # split read tag into array of chars and accuracy
  my @read_bases = split(//,$read);
  my $read_length = length($read);

  # exact match
  print "$read\t@data\tEXACT\t0\n";

  # all single base variants created
  if ($numvariants > 0) {
    for (my $positionA = 0; $positionA < $read_length; $positionA++) {
      foreach my $baseA (@BASES) {
        unless ($read_bases[$positionA] eq $baseA) {
          for (my $i = 0; $i < $read_length; $i++) {
            if ($i == $positionA) {
              print "$baseA";
            } else {
              print "$read_bases[$i]";
            }
          }
          my $posA_info = $positionA . "_" . $read_bases[$positionA] . "_" . $baseA;
          print "\t@data\t$posA_info\t1\n";
        }
      }
      # all double base variants created
      if ($numvariants > 1) {
        for (my $positionB = $positionA + 1; $positionB < $read_length; $positionB++) {
          foreach my $baseA (@BASES) {
            unless ($read_bases[$positionA] eq $baseA) {
              foreach my $baseB (@BASES) {
                unless ($read_bases[$positionB] eq $baseB) {
                  for (my $i = 0; $i < $read_length; $i++) {
                    if ($i == $positionA) {
                      print "$baseA";
                    } elsif ($i == $positionB) {
                      print "$baseB";
                    } else {
                      print "$read_bases[$i]";
                    }
                  }
                  my $posA_info = $positionA . "_" . $read_bases[$positionA] . "_" . $baseA;                  
                  my $posB_info = $positionB . "_" . $read_bases[$positionB] . "_" . $baseB;
                  print "\t@data\t$posA_info,$posB_info\t2\n";
                }
              }
            }
          }
          # all triple base variants created
          if ($numvariants > 2) {
            for (my $positionC = $positionB + 1; $positionC < $read_length; $positionC++) {
              foreach my $baseA (@BASES) {
                unless ($read_bases[$positionA] eq $baseA) {
                  foreach my $baseB (@BASES) {
                    unless ($read_bases[$positionB] eq $baseB) {
                      foreach my $baseC (@BASES) {
                        unless ($read_bases[$positionC] eq $baseC) {
                          for (my $i = 0; $i < $read_length; $i++) {
                            if ($i == $positionA) {
                              print $baseA;
                            } elsif ($i == $positionB) {
                              print $baseB;
                            } elsif ($i == $positionC) {
                              print $baseC;
                            } else {
                              print $read_bases[$i];
                            }
                          }
                          my $posA_info = $positionA . "_" . $read_bases[$positionA] . "_" . $baseA;
                          my $posB_info = $positionB . "_" . $read_bases[$positionB] . "_" . $baseB;
                          my $posC_info = $positionC . "_" . $read_bases[$positionC] . "_" . $baseC;
                          print "\t@data\t$posA_info,$posB_info,$posC_info\t3\n";
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

