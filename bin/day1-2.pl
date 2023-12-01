#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use List::AllUtils qw(:all);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day1';
$file = "inputs/day1-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;

my @arr = ("one", "two", "three", "four", "five", "six", "seven", "eight", "nine");
my $total = 0;

while (<$fh>) {
    chomp;

    my $line = $_;
    my @nums;
    for (my $i = 0; $i < length $line; $i++) {
        my $ch = substr $line, $i, 1;
        push @nums, $ch if $ch =~ /\d/;
        for my $n (@arr) {
            my $s = substr $line, $i;
            if ($s =~ /^$n/) {
                my $index = 1 + firstidx { $_ eq $n } @arr;
                push @nums, $index;
            }
        }
    }

    my $f = $nums[0];
    my $l = $nums[-1];
    my $i = int($f . $l);
    $total += $i;
}

say $total;
