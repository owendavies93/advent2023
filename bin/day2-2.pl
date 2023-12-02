#!/usr/bin/env perl
use Mojo::Base -strict;

use List::AllUtils qw(:all);

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
    my ($id) = $_ =~ /Game (\d+)/;
    my @games = split /; /;

    my $lims = {};
    for my $g (@games) {
        my @balls = split /, /, $g;
        for my $b (@balls) {
            my ($num, $colour) = $b =~ /(\d+) (\w+)/;
            if (!defined $lims->{$colour} || $lims->{$colour} < $num) {
                $lims->{$colour} = $num;
            }
        }
    }

    $total += product values %$lims;
}

say $total;
