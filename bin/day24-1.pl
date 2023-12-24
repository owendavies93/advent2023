#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Input qw(get_ints);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day24';
$file = "inputs/day24-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;

my $total = 0;
my @lines;
my $start = $file =~ /test/ ? 7 : 200000000000000;
my $end = $file =~ /test/ ? 27 : 400000000000000;

while (<$fh>) {
    chomp;
    my ($x, $y, $z, $vx, $vy, $vz) = get_ints($_, 1);
    push @lines, {
        x => $x, y => $y, vx => $vx, vy => $vy
    };
}

for (my $i = 0; $i < scalar @lines; $i++) {
    for (my $j = $i + 1; $j < scalar @lines; $j++) {
        next if $i == $j;

        my $x1 = $lines[$i]->{x};
        my $y1 = $lines[$i]->{y};
        my $x2 = $lines[$i]->{x} + $lines[$i]->{vx};
        my $y2 = $lines[$i]->{y} + $lines[$i]->{vy};

        my $x3 = $lines[$j]->{x};
        my $y3 = $lines[$j]->{y};
        my $x4 = $lines[$j]->{x} + $lines[$j]->{vx};
        my $y4 = $lines[$j]->{y} + $lines[$j]->{vy};

        my $d = ($x1 - $x2) * ($y3 - $y4) - ($y1 - $y2) * ($x3 - $x4);

        next if $d == 0;

        my $px = (($x1 * $y2 - $y1 * $x2) * ($x3 - $x4) - ($x1 - $x2) * ($x3 * $y4 - $y3 * $x4)) / $d;
        my $py = (($x1 * $y2 - $y1 * $x2) * ($y3 - $y4) - ($y1 - $y2) * ($x3 * $y4 - $y3 * $x4)) / $d;

        next unless $px >= $start && $px <= $end && $py >= $start && $py <= $end;

        my $in_future_a = ($px > $x1) == ($x2 > $x1);
        my $in_future_b = ($px > $x3) == ($x4 > $x3);

        if ($in_future_a && $in_future_b) {
            $total++;
        }
    }
}

say $total;
