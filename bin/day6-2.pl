#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Input qw(get_ints get_lines);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day6';
$file = "inputs/day6-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;

my $total = 0;
my ($times, $dists) = get_lines($fh);
my $t = join '', get_ints($times);
my $d = join '', get_ints($dists);

my $i = 0;
while ($i != $t) {
    my $left = $t - $i;
    my $dist = $left * $i;
    last if $dist > $d;
    $i++;
}

say 1 + $t - (2 * $i);

