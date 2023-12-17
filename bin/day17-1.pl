#!/usr/bin/env perl
use Mojo::Base -strict;

use List::AllUtils qw(:all);
use List::PriorityQueue;

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day17';
$file = "inputs/day17-$file" if $file =~ /test/;
open(my $fh, '<', $file) || die $!;

my @grid;
my $height = 0;
my $width = 0;
while (<$fh>) {
    chomp;
    my @line = split //;
    $width = max($width, scalar @line);
    push @grid, @line;
    $height++;
}

my $move = {
    N => [0, -1],
    E => [1, 0 ],
    S => [0, 1 ],
    W => [-1, 0],
};

my $turns = {
    N => ['W', 'E'],
    E => ['N', 'S'],
    S => ['W', 'E'],
    W => ['N', 'S'],
};

my $start = [0, 0, ''];
my $end = scalar @grid - 1;

my $q = List::PriorityQueue->new();
my $min = ~0;
my @pos_min;

$q->insert($start, 0);

while (1) {
    my $c = $q->pop();
    last unless defined $c;
    my ($i, $dist, $last) = @$c;
    
    if (defined $pos_min[$i]{$last} &&
        $pos_min[$i]{$last} <= $dist) {
        next;
    }
    $pos_min[$i]{$last} = $dist;

    if ($i == $end) {
        next if $dist >= $min;
        $min = $dist;
    }

    my @next = $i == 0 ? ('E', 'S') : @{$turns->{$last}};

    foreach my $next (@next) {
        my ($dx, $dy) = @{$move->{$next}};
        foreach my $len ((1..3)) {
            my $x = $i % $width;
            my $y = int($i / $width);
            my $nx = $x + $dx * $len;
            my $ny = $y + $dy * $len;
            my $ni = $ny * $height + $nx;

            if ($nx < 0 || $nx >= $width || $ny < 0 || $ny >= $height) {
                next;
            }

            my $new_dist = $dist + sum map {
                $grid[($y + $dy * $_) * $height + ($x + $dx * $_)]
            } (1..$len);
            
            $q->insert([$ni, $new_dist, $next], $new_dist);
        }
    }
}

say $min;
