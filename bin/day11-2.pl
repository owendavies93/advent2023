#!/usr/bin/env perl
use Mojo::Base -strict;

use List::AllUtils qw(:all);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day11';
$file = "inputs/day11-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;

my $coords = {};
my $height = 0;
my $width = 0;
my $rows_to_expand = {};
my $expansion_factor = $file !~ /test/ ? 1_000_000 - 1 : 9;

while (<$fh>) {
    chomp;
    
    my @line = split //, $_;
    $width = scalar @line;

    $rows_to_expand->{$height} = 1 if all { $_ eq '.' } @line;

    my $x = 0;
    for my $ch (@line) {
        $coords->{$x,$height} = 1 if $ch eq '#';
        $x++;
    }
    $height++;
}

my $cols_to_expand = {};
for my $col (0..$width - 1) {
    my $empty = 1;

    for my $row (0..$height) {
        if (exists $coords->{$col,$row}) {
            $empty = 0;
            last;
        }
    }

    if ($empty == 1) {
        $cols_to_expand->{$col} = 1;
    }
}

my $total = 0;
my $seen = {};
for my $k1 (keys %$coords) {
    my ($x1, $y1) = split $;, $k1;
    for my $k2 (keys %$coords) {
        next if exists $seen->{$k1,$k2};
        my ($x2, $y2) = split $;, $k2;
        $total += dist($x1, $y1, $x2, $y2);
        $seen->{$k1,$k2} = 1;
        $seen->{$k2,$k1} = 1;
    }
}

say $total;

sub dist {
    my ($x1, $y1, $x2, $y2) = @_;
    my $d = abs($x1 - $x2) + abs($y1 - $y2);

    for my $row (keys %$rows_to_expand) {
        $d += $expansion_factor if min($y1, $y2) < $row && $row < max($y1, $y2);
    }

    for my $col (keys %$cols_to_expand) {
        $d += $expansion_factor if min($x1, $x2) < $col && $col < max($x1, $x2);
    }

    return $d;
}
