#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Input qw(get_lines);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day14';
$file = "inputs/day14-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;
my $total = 0;

my @grid = get_lines($fh);
my $height = scalar @grid;
my $width = length $grid[0];

my @cols;
for (my $i = 0; $i < $width; $i++) {
    my $col = '';
    for (my $j = 0; $j < $height; $j++) {
        $col .= substr $grid[$j], $i, 1;
    }
    push @cols, $col;
}

for my $c (@cols) {
    while ($c =~ s/\.O/O./g) {}
    for (my $i = 0; $i < length $c; $i++) {
        if ((substr $c, $i, 1) eq 'O') {
            $total += (length $c) - $i;
        }
    }
}

say $total;
