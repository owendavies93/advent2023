#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Input qw(get_ints get_lines);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day6';
$file = "inputs/day6-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;

my ($times, $dists) = get_lines($fh);
my @times = get_ints($times);
my @dists = get_ints($dists);

my $total = 1;
for (my $i = 0; $i < scalar @times; $i++) {
    my $t = $times[$i];
    my $d = $dists[$i];

    my $wins = 0;
    for (my $j = 0; $j <= $t; $j++) {
        my $left = $t - $j;
        my $dist = $left * $j;
        $wins++ if $dist > $d;
    }
    
    $total *= $wins;
}

say $total;
