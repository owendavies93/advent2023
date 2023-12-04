#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Input qw(get_ints);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day4';
$file = "inputs/day4-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;
my $total = 0;
my $num_winning = $file =~ /test/ ? 4 : 9;
my $counts = {};
while (<$fh>) {
    chomp;
    my @nums = get_ints($_);
    my $card = shift @nums;
    my @winning = @nums[0..$num_winning];
    my @rest = @nums[($num_winning + 1)..$#nums];
    my %rest = map { $_ => 1 } @rest;

    $counts->{$card}++;
    $total += $counts->{$card};

    my $sub = 0;
    my $factor = 1;
    for my $w (@winning) {
        if ($rest{$w}) {
            $sub++;
            $counts->{$card + $sub} += $counts->{$card};
            $factor *= 2;
        }
    }
}

say $total;

