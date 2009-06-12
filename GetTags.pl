#!/usr/bin/perl -w

# $ARGV[0] = a sites file of sequence encompassing a CCGG site, CCGG is assumed to be centered
#               chromosome, location of CCGG's CG, sequence including CCGG, repetitive = 1
# $ARGV[1] = length of tag
# $ARGV[2] = 1 if CCGG site is at end of sequencing read, 0 if it is at head of read (or unread)

# Output is seven columns, tab separated:
# (1) tag sequence
# (2) chromosome ID
# (3) position of target site
# (4) strand (each site produces two tags, so these are marked "+" and "-")
# (5) repetitive statuse (1 if in repeat-masked DNA, 0 if not)
# (6) Mme I site distance (NA if none found, otherwise gives bp distance from target site)


use warnings;
use strict;

my $sitesfile = $ARGV[0];
my $length = $ARGV[1];
my $reverseread = $ARGV[2];

my $default_length = 5000;

open(SITE,$sitesfile);

# run on first line, find surround size, check for centered CCGG
my $siteline = <SITE>;
my @sitedata = split(' ',$siteline);
my @lastsitedata = ();
my $sitelength = length($sitedata[2]);
my $surroundlength = int(($sitelength - 4) / 2) - $length;
if ($sitedata[2] =~ /(.{$surroundlength}(.{$length})C)CG(G(.{$length}).*)/) {
  my $reverse_all = $1;
  my $reverse = $2;
  my $forward_all = $3;
  my $forward = $4;
  my $MmeI_forward = "NA";
  my $MmeI_reverse = "NA";
  if ($reverseread) {
    ($forward_all = reverse($forward_all)) =~ tr/ACGTacgt/TGCAtgca/;
    ($forward = reverse($forward)) =~ tr/ACGTacgt/TGCAtgca/;
    if ($forward_all =~ /TCC[AG]AC(.*?)$/) {
      $MmeI_forward = length($1);
    }
    if ($reverse_all =~ /TCC[AG]AC(.*?)$/) {
      $MmeI_reverse = length($1);
    }
  } else {
    ($reverse_all = reverse($reverse_all)) =~ tr/ACGTacgt/TGCAtgca/;
    ($reverse = reverse($reverse)) =~ tr/ACGTacgt/TGCAtgca/;
    if ($forward_all =~ /^(.*?)GT[CT]GGA/) {
      $MmeI_forward = length($1);
    }
    if ($reverse_all =~ /^(.*?)GT[CT]GGA/) {
      $MmeI_reverse = length($1);
    }
  }
  print "$forward\t$sitedata[0]\t$sitedata[1]\t+\t$length\t$sitedata[3]\t$MmeI_forward\n";
  print "$reverse\t$sitedata[0]\t$sitedata[1]\t-\t$length\t$sitedata[3]\t$MmeI_reverse\n";
  @lastsitedata = @sitedata;
} else {
  die "CCGG not centered in:\n@sitedata\n";
}

# run on remaining lines
while (<SITE>) {
  my @sitedata = split;
  $sitedata[2] =~ /(.{$surroundlength}(.{$length})C)CG(G(.{$length}).*)/;
  my $reverse_all = $1;
  my $reverse = $2;
  my $forward_all = $3;
  my $forward = $4;
  my $MmeI_forward = "NA";
  my $MmeI_reverse = "NA";
  if ($reverseread) {
    ($forward_all = reverse($forward_all)) =~ tr/ACGTacgt/TGCAtgca/;
    ($forward = reverse($forward)) =~ tr/ACGTacgt/TGCAtgca/;
    if ($forward_all =~ /TCC[AG]AC(.*?)$/) {
      $MmeI_forward = length($1);
    }
    if ($reverse_all =~ /TCC[AG]AC(.*?)$/) {
      $MmeI_reverse = length($1);
    }
  } else {
    ($reverse_all = reverse($reverse_all)) =~ tr/ACGTacgt/TGCAtgca/;
    ($reverse = reverse($reverse)) =~ tr/ACGTacgt/TGCAtgca/;
    if ($forward_all =~ /^(.*?)GT[CT]GGA/) {
      $MmeI_forward = length($1);
    }
    if ($reverse_all =~ /^(.*?)GT[CT]GGA/) {
      $MmeI_reverse = length($1);
    }
  }
  print "$forward\t$sitedata[0]\t$sitedata[1]\t+\t$length\t$sitedata[3]\t$MmeI_forward\n";
  print "$reverse\t$sitedata[0]\t$sitedata[1]\t-\t$length\t$sitedata[3]\t$MmeI_reverse\n";
}


