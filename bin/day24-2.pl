#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Input qw(get_ints);

use List::Util qw(sum);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day24';
$file = "inputs/day24-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;

my $total = 0;
my @lines;
my $i = 0;
while (<$fh>) {
    chomp;
    my ($x, $y, $z, $vx, $vy, $vz) = get_ints($_, 1);

    my $t = "t$i";
    my $eq = "$t >= 0, $x + $vx $t == x + vx $t, $y + $vy $t == y + vy $t, $z + $vz $t == z + vz $t";
    push @lines, $eq;

    $i++;
    last if $i > 2;
}

my $code = "Solve[{" . join(", ", @lines) . "}, {x,y,z}, Integers]";

my $ans = `wolframscript -code "$code"`;

my @points = $ans =~ m/ConditionalExpression\[(\d+),/g;
say sum @points;
