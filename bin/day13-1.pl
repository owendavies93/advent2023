#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Input qw(get_nonempty_groups);

use List::AllUtils qw(:all);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day13';
$file = "inputs/day13-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;
my $total = 0;

my @grids = get_nonempty_groups($fh);

for my $g (@grids) {
    my @a;
    my $height = 0;
    my $width = 0;
    for my $row (@$g) {
        $width = max($width, length($row));
        push @a, join "", map { $_ eq '#' ? 1 : 0 } (split //, $row);
        $height++;
    }

    my @b_rows = map { oct('0b' . $_) } @a;
    my $start_i = find_reflection(@b_rows);

    if ($start_i == -1) {
        my @b_cols;
        for (my $i = 0; $i < $width; $i++) {
            my $col = '';
            for (my $j = 0; $j < $height; $j++) {
                $col .= substr $a[$j], $i, 1;
            }
            push @b_cols, oct('0b' . $col);
        }
        $start_i = find_reflection(@b_cols);
        $total += $start_i;
    } else {
        $total += 100 * $start_i;
    }
}

say $total;

sub find_reflection {
    my @rows = @_;
    my @starts;
    for (my $i = 0; $i < $#rows; $i++) {
        if ($rows[$i] == $rows[$i+1]) {
            push @starts, $i;
        }
    }
    OUTER:
    for my $start_i (@starts) {
        my $valid = 1;
        my $i = $start_i - 1;
        my $j = $start_i + 2;
        while ($i >= 0 && $j < scalar @rows) {
            if ($rows[$i] != $rows[$j]) {
                $valid = 0;
                next OUTER;
            }
            $i--;
            $j++;
        }
        
        return $start_i + 1 if $valid;
    }

    return -1;
}

