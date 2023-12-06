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

my $start = find_bound(0, $t, 1);
my $end = find_bound($t, 0, -1);

say 1 + $end - $start;

sub find_bound {
    my ($s, $e, $inc) = @_;
    my $i = $s;
    while ($s != $e) {
        my $left = $t - $i;
        my $dist = $left * $i;
        return $i if $dist > $d;
        $i += $inc;
    }
}

