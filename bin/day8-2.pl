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
my $start_id = 0;
my $ns = {};
for my $n (@$nodes) {
    my ($start, $l, $r) = $n =~ /(\w+) = \((\w+), (\w+)\)/;
    $ns->{$start} = { l => $l, r => $r };

    if ((substr $start, -1) eq 'A') {
        push @cur_pos, $start;
        $start_id++;
    }
}

my $i = 0;
my @sub_totals;
for my $p (@cur_pos) {
    my $sub_total = 0;
    while ((substr $p, -1) ne 'Z') {
        my $ins = $ins[$i];
        if ($ins eq 'L') {
            $p = $ns->{$p}->{l};
        } else {
            $p = $ns->{$p}->{r};
        }
        $sub_total++;
        if ($i >= $#ins) {
            $i = 0;
        } else {
            $i++;
        }
    }
    push @sub_totals, $sub_total;
}

say lcm(@sub_totals);
