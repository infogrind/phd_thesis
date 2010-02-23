#!/usr/bin/perl

# $Id: trimsolution.pl 680 2007-01-16 09:33:54Z kleiner $

use strict;
use warnings;

# Variable that keeps track if we are in an 'ignore' block
my $ignore=1;

while (my $line=<>) {
	chomp $line;

  if ($line =~ /^\s*%%%\s*MK:STARTSHOW\s*$/) {
    print STDERR "MK:STARTSHOW when already in show mode at input line $.\n"
      if ($ignore == 0);
    # Stop ignore mode
    $ignore = 0;
    next;
  }

  if ($line =~ /^\s*%%%\s*MK:ENDSHOW\s*$/) {
    print STDERR "MK:ENDSHOW without MK:STARTSHOW at input line $.\n"
      if ($ignore == 1);
    $ignore = 1;
    next;
  }

  # If the line has a "show" comment, display the line but without the tag.
  if ($line =~ /%(.*)\s*MK:SHOW\s*$/)
  {
    # If the MK:SHOW is the only comment, remove the whole comment. Otherwise
    # only remove the tag. 
    if ($line =~ /%\s*MK:SHOW\s*$/)
    {
      $line =~ s/%.*$//;
    }
    else
    {
      $line =~ s/%(.*)\s*MK:SHOW\s*$/%$1/;
    }

    print "$line\n";
  }
  else
  {
    print "$line\n" unless ($ignore);
  }


}

