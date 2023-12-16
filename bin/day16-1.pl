#!/usr/bin/env perl
use Mojo::Base -strict;

use List::AllUtils qw(:all);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day16';
$file = "inputs/day16-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;

my $total = 0;
my @grid;
my $height;
my $width = 0;

while (<$fh>) {
    chomp;
    my @line = split //;
    $width = max($width, scalar @line);
    push @grid, @line;
    $height++;
}

my @q;
my $start = [0, 0, 1, 0];
push @q, $start;
my $seen = {};
my $energised = {};

while (scalar @q > 0) {
    my ($x, $y, $dx, $dy) = @{shift @q};

    next if $seen->{$x,$y,$dx,$dy};
    next if $x < 0 || $y < 0 || $x >= $width || $y >= $height;

    $seen->{$x,$y,$dx,$dy} = 1;
    $energised->{$x,$y} = 1;
    my @next = step($x, $y, $dx, $dy);
    push @q, @next;
}

say scalar keys %$energised;

sub step {
    my ($x, $y, $dx, $dy) = @_;

    my $i = $y * $width + $x;
    my $n = $grid[$i];

    if ($n eq '.') {
        return ([$x + $dx, $y + $dy, $dx, $dy]);
    } elsif ($n eq '/') {
        my $tmp = $dx;
        $dx = -$dy;
        $dy = -$tmp;
        return ([$x + $dx, $y + $dy, $dx, $dy]);
    } elsif ($n eq '\\') {
        my $tmp = $dx;
        $dx = $dy;
        $dy = $tmp;
        return ([$x + $dx, $y + $dy, $dx, $dy]);
    } elsif ($n eq '-') {
        if ($dx != 0) {
            return ([$x + $dx, $y, $dx, 0]);
        } else {
            return ([$x + 1, $y, 1, 0], [$x - 1, $y, -1, 0]);
        }
    } elsif ($n eq '|' ) {
        if ($dy != 0) {
            return ([$x, $y + $dy, 0, $dy]);
        } else {
            return ([$x, $y + 1, 0, 1], [$x, $y - 1, 0, -1]);
        }
    }
}

