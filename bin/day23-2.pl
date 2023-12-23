#!/usr/bin/env perl
use Mojo::Base -strict;

use Data::Dumper;
use List::AllUtils qw(:all);
use Memoize;
use Storable qw(dclone);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day23';
$file = "inputs/day23-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;

my @grid;
my $width;
my $height = 0;
while (<$fh>) {
    chomp;
    my @line = split //;
    push @grid, @line;
    $width = scalar @line if !defined $width;
    $height++;
}

my $adj_graph = {};

my @dirs = (
    [0,-1],[1,0],[0,1],[-1,0]
);

for (my $y = 0; $y < $height; $y++) {
    for (my $x = 0; $x < $width ; $x++) {
        my $e = $grid[$y * $width + $x];
        next if $e eq '#';

        my $adj = {};
        for (my $i = 0; $i < scalar @dirs; $i++) {
            my ($dx, $dy) = @{$dirs[$i]};
            my $nx = $x + $dx;
            my $ny = $y + $dy;
            next if $nx < 0 || $ny < 0 || $nx >= $width || $ny >= $height;
            
            my $ne = $grid[$ny * $width + $nx];
            next if $ne eq '#';

            $adj->{$nx,$ny} = 1;
        }

        $adj_graph->{$x,$y} = $adj;
    }
}

my $keep = {};
for my $k (keys %$adj_graph) {
    my $adj = $adj_graph->{$k};
    if (scalar keys %$adj > 2) {
        $keep->{$k} = 1;
    }
}
$keep->{1,0} = 1;
$keep->{$width - 2, $height - 1} = 1;

my $final_adjs = {};

for my $k (keys %$keep) {
    my @q = ($k);
    my $seen = { $k => 1 };
    my $dist = 0;

    while (@q) {
        my @nq = ();
        $dist++;
        
        for my $c (@q) {
            my $adj = $adj_graph->{$c};
            for my $a (keys %$adj) {
                if (!$seen->{$a}) {
                    if ($keep->{$a}) {
                        $final_adjs->{$k}->{$a} = $dist;
                        $seen->{$a} = 1;
                    } else {
                        $seen->{$a} = 1;
                        push @nq, $a;
                    }
                }
            }
        }
        @q = @nq;
    }
}

my @q;
my $s = {};
$s->{1,0} = 1;
push @q, [1, 0, $s, 0];

my @end = ($width - 2, $height - 1);
my @lens;
while (@q) {
    my $cur = shift @q;
    my ($x, $y, $seen, $len) = @$cur;

    if ($x == $end[0] && $y == $end[1]) {
        push @lens, $len;
        next;
    }

    for my $adj (keys %{$adj_graph->{$x,$y}}) {
        my ($nx, $ny) = split $;, $adj;
        next if $seen->{$nx,$ny};
        my $ns = dclone($seen);
        $ns->{$nx,$ny} = 1;
        my $l = $adj_graph->{$x,$y}->{$adj};
        push @q, [$nx, $ny, $ns, $len + $l];
    }

}

say max @lens;

