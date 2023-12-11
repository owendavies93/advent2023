#!/usr/bin/env perl
use Mojo::Base -strict;

use List::AllUtils qw(:all);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day11';
$file = "inputs/day11-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;

my $coords = {};
my $height = 0;
my $width = 0;
my @cols_to_expand;
my @rows_to_expand;

while (<$fh>) {
    chomp;
    
    my @line = split //, $_;
    if ($height == 0) {
        @cols_to_expand = (1) x $#line;
        $width = scalar @line;
    }

    if (!any { $_ eq '#' } @line) {
        push @rows_to_expand, $height;
    }

    my $x = 0;
    for my $ch (@line) {
        if ($ch eq '#') {
            $coords->{$x,$height} = 1;            
            $cols_to_expand[$x] = 0;
        }
        $x++;
    }
    $height++;
}

my $expansion_factor = $file !~ /test/ ? 1_000_000 - 1 : 9;

my $height_bumps = {};
for my $k (keys %$coords) {
    my ($x, $y) = split $;, $k;
    my $bump = 0;
    for my $r (@rows_to_expand) {
        $bump++ if $y > $r;
    }
    $height_bumps->{$k} = $bump * $expansion_factor;
}

for my $b (keys %$height_bumps) {
    my ($x, $y) = split $;, $b;
    my $bump = $height_bumps->{$b};
    delete $coords->{$b};
    $coords->{$x,$y+$bump} = 1;
}

my $width_bumps = {};
for my $k (keys %$coords) {
    my ($x, $y) = split $;, $k;
    my $bump = 0;
    for (my $i = 0; $i < scalar @cols_to_expand; $i++) {
        next if $cols_to_expand[$i] == 0;
        $bump++ if $x > $i;
    }
    $width_bumps->{$k} = $bump * $expansion_factor;
}

for my $b (keys %$width_bumps) {
    my ($x, $y) = split $;, $b;
    my $bump = $width_bumps->{$b};
    delete $coords->{$b};
    $coords->{$x+$bump,$y} = 1;
}

my $total = 0;
for my $k (keys %$coords) {
    my ($x1, $y1) = split $;, $k;
    for my $k2 (keys %$coords) {
        my ($x2, $y2) = split $;, $k2;
        next if ($x2 == $x1) && ($y2 == $y1);
        $total += dist($x1, $y1, $x2, $y2);
    }
}
say $total / 2;

sub dist {
    my ($x1, $y1, $x2, $y2) = @_;
    return abs($x1 - $x2) + abs($y1 - $y2);
}

