#!/usr/bin/env perl
use Mojo::Base -strict;

use List::AllUtils qw(:all);

# Add a ring of . around your input to avoid edge cases
my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day3';
$file = "inputs/day3-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;
my $total = 0;
my $coords = {};
my $symbols = {};
my $y = 0;
while (<$fh>) {
    chomp;
    my $n = 0;
    my $cur = '';
    my $x = 0;
    for (my $i = 0; $i < length $_; $i++) {
        my $ch = substr($_, $i, 1);
        if ($n == 0 && $ch =~ /\d/) {
            # new num
            $n = 1;
            $cur .= $ch;
        } elsif ($ch =~ /\d/) {
            # continue num
            $cur .= $ch;
        } elsif ($ch =~ /\./) {
            # stop num
            if ($n == 1) {
                $n = 0;
                write_num($cur, $x, $y);
                $cur = '';
            }
        } else {
            # stop num, write symbol
            $symbols->{$x, $y} = 1;
            if ($n == 1) {
                $n = 0;
                write_num($cur, $x, $y);
                $cur = '';
            }
        }
        $x++;
    }
    $y++;
}

sub write_num {
    my ($cur, $x, $y) = @_;
    my $startx = $x - length $cur;
    my $endx = $x - 1;
    $coords->{$startx,$endx,$y} = $cur;
}

my $matches = {};
for my $c (keys %$symbols) {
    my ($x, $y) = split $;, $c;
    for my $num (keys %$coords) {
        my ($startx, $endx, $ny) = split $;, $num;
        my $n = $coords->{$num};
        if (is_neighbour($startx, $endx, $ny, $x, $y)) {
            $matches->{$n,$startx,$ny} = 1;
        }
    }
}

sub is_neighbour {
    my ($startx, $endx, $ny, $x, $y) = @_;
    return (abs($ny - $y) < 2) &&
           ($x >= $startx - 1 &&
            $x <= $endx + 1);
}

for my $k (keys %$matches) {
    my ($n,$startx,$ny) = split $;, $k;
    $total += $n;
}

say $total;
