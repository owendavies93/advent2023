#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Input qw(get_lines);
use Advent::Utils::Transform qw(rotate_clockwise);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day14';
$file = "inputs/day14-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;
my $total = 0;

my @lines = get_lines($fh);
my $height = scalar @lines;
my $width = length $lines[0];

my @grid;
for my $l (@lines) {
    push @grid, (split //, $l);
}
my $grid = \@grid;

my $seen_states = {};
my $cycles = 0;
my $target = 1_000_000_000;
while ($cycles < $target) {
    ($total, $grid) = cycle($grid);
    my $state = check_state($grid);
    if (defined $seen_states->{$state}) {
        my $cycle_length = $cycles - $seen_states->{$state};
        my $mult = int(($target - $cycles) / $cycle_length);
        $cycles += $mult * $cycle_length;
    } else {
        $seen_states->{$state} = $cycles;
    }
    $cycles++;
}

say $total;

sub check_state {
    my $g = shift;
    my $state = '';
    for (my $i = 0; $i < scalar @$g; $i++) {
        $state .= $i if $g->[$i] eq 'O';
    }
    return $state;
}

sub cycle {
    my $g = shift;
    for (1..4) {
        $g = tilt($g);
        $g = rotate_clockwise($g, $width, $height);
    }

    my $total_load = 0;
    for my $y (0..$height - 1) {
        for my $x (0..$width - 1) {
            if ($g->[$y * $width + $x] eq 'O') {
                $total_load += ($height - $y);
            }
        }
    }

    return ($total_load, $g);
}

sub tilt {
    my $g = shift;

    my @cols;
    for (my $i = 0; $i < $width; $i++) {
        my $col = '';
        for (my $j = 0; $j < $height; $j++) {
            $col .= $g->[$j * $width + $i];
        }
        push @cols, $col;
    }

    my $total_load = 0;
    for my $c (@cols) {
        while ($c =~ s/\.O/O./g) {}
    }

    my @new_grid;
    for (my $i = 0; $i < $width; $i++) {
        for (my $j = 0; $j < $height; $j++) {
            my $c = $cols[$j];
            push @new_grid, (substr $c, $i, 1);
        }
    }

    return \@new_grid;
}

