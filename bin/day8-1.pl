#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Input qw(get_nonempty_groups);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day8';
$file = "inputs/day8-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;

my ($inst, $nodes) = get_nonempty_groups($fh);
my @ins = split //, @$inst[0];
my $ns = {};
for my $n (@$nodes) {
    my ($start, $l, $r) = $n =~ /(\w+) = \((\w+), (\w+)\)/;
    $ns->{$start} = { l => $l, r => $r };
}

my $i = 0;
my $total = 0;
my $start = 'AAA';
while ($start ne 'ZZZ') {
    my $n = $ns->{$start};
    $start = $ins[$i] eq 'L' ? $n->{l} : $n->{r};
    $total++;
    $i = $i >= $#ins ? 0 : $i + 1;
}

say $total;
