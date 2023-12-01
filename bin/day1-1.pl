#!/usr/bin/env perl
use Mojo::Base -strict;

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day1';
$file = "inputs/day1-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;

my $total = 0;
while (<$fh>) {
    chomp;
    my @nums = /(\d)/g;
    my $f = $nums[0];
    my $l = $nums[-1];
    my $i = int($f . $l);
    $total += $i;
}

say $total;
