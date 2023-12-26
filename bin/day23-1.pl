#!/usr/bin/env perl
use Mojo::Base -strict;

no warnings 'recursion';

use List::AllUtils qw(:all);

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

my $s = {};
$s->{1,0} = 1;

my @end = ($width - 2, $height - 1);

say dfs([1,0]);

sub dfs {
    my $cur = shift;
    my ($x, $y) = @$cur;
    return 0 if $x == $end[0] && $y == $end[1];

    $s->{$x,$y} = 1;

    my $max_path = -1;

    for my $adj (adjs($x, $y, $s)) {
        my ($nx, $ny) = @$adj;
        next if $s->{$nx,$ny};
        my $sub = dfs($adj) + 1;
        $max_path = $sub if $sub > $max_path;
    }

    $s->{$x,$y} = 0;
    return $max_path;
}

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

