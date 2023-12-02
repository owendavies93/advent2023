#!/usr/bin/env perl
use Mojo::Base -strict;

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day2';
$file = "inputs/day2-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;

my $maxs = {
    "red" => 12,
    "green" => 13,
    "blue" => 14,
};

my $total = 0;
while (<$fh>) {
    chomp;
    my ($id) = /(\d+):/;
    my @balls = split /[;,] /;
    my $possible = 1;
    for my $b (@balls) {
        my ($num, $colour) = $b =~ /(\d+) (\w+)/;
        if ($num > $maxs->{$colour}) {
            $possible = 0;
        }
    }

    next if $possible < 1;
    $total += $id;
}

say $total;
