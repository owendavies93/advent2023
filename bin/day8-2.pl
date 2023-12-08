#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Input qw(get_nonempty_groups);

use Math::Utils qw(lcm);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day8';
$file = "inputs/day8-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;
my $total = 0;

my ($inst, $nodes) = get_nonempty_groups($fh);
my @ins = split //, @$inst[0];
my @cur_pos;
my $ns = {};
for my $n (@$nodes) {
    my ($start, $l, $r) = $n =~ /(\w+) = \((\w+), (\w+)\)/;
    $ns->{$start} = { l => $l, r => $r };
    push @cur_pos, $start if (substr $start, -1) eq 'A';
}

my $i = 0;
my @sub_totals;
for my $p (@cur_pos) {
    my $sub_total = 0;
    while ((substr $p, -1) ne 'Z') {
        my $n = $ns->{$p};
        $p = $ins[$i] eq 'L' ? $n->{l} : $n->{r};
        $sub_total++;
        $i = $i >= $#ins ? 0 : $i + 1;
    }
    push @sub_totals, $sub_total;
}

say lcm(@sub_totals);
