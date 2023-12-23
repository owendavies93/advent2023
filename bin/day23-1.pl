#!/usr/bin/env perl
use Mojo::Base -strict;

use List::AllUtils qw(:all);
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

my @dirs = (
    [0,-1],[1,0],[0,1],[-1,0]
);

my @slopes = ('^', '>', 'v', '<');

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

    for my $adj (adjs($x, $y, $seen)) {
        my ($nx, $ny) = @$adj;
        my $ns = dclone($seen);
        $ns->{$nx,$ny} = 1;
        push @q, [$nx, $ny, $ns, $len + 1];
    }
}

say max @lens;

sub adjs {
    my ($x, $y, $seen) = @_;

    my $e = $grid[$y * $width + $x];

    my @adj;
    for (my $i = 0; $i < scalar @dirs; $i++) {
        my ($dx, $dy) = @{$dirs[$i]};
        my $nx = $x + $dx;
        my $ny = $y + $dy;
        next if $seen->{$nx,$ny};
        
        my $ne = $grid[$ny * $width + $nx];
        next if $ne eq '#';

        if ($e ne '.') {
            my $si = firstidx { $_ eq $e } @slopes;
            my $allowed_dir = $dirs[$si];
            my ($ax, $ay) = @$allowed_dir;
            next unless $dx == $ax && $dy == $ay;
        }

        push @adj, [$nx, $ny];
    }

    return @adj;
}

