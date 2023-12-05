#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Input qw(get_ints get_nonempty_groups);

use List::AllUtils qw(:all);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day5';
$file = "inputs/day5-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;
my $total = 0;

my ($seeds, $s2s, $s2f, $f2w, $w2l, $l2t, $t2h, $h2l) = get_nonempty_groups($fh);

my $s2s_map = input_to_map($s2s);
my $s2f_map = input_to_map($s2f);
my $f2w_map = input_to_map($f2w);
my $w2l_map = input_to_map($w2l);
my $l2t_map = input_to_map($l2t);
my $t2h_map = input_to_map($t2h);
my $h2l_map = input_to_map($h2l);

my @seeds = get_ints(@$seeds);
my @locs = map {
    my $seed = $_;
    my $soil  = do_mapping($seed, $s2s_map);
    my $fert  = do_mapping($soil, $s2f_map);
    my $water = do_mapping($fert, $f2w_map);
    my $light = do_mapping($water, $w2l_map);
    my $temp  = do_mapping($light, $l2t_map);
    my $hum   = do_mapping($temp, $t2h_map);
    do_mapping($hum, $h2l_map);
} @seeds;

say min @locs;

sub input_to_map {
    my $input = shift;

    my @mappings;
    for (my $i = 1; $i < scalar @$input; $i++) {
        my ($dest, $source, $length) = get_ints($input->[$i]);
        push @mappings, {
            dest => $dest,
            source => $source,
            length => $length,
        };
    }

    return \@mappings;
}

sub do_mapping {
    my ($from, $mappings) = @_;

    for my $map (@$mappings) {
        if ($from >= $map->{source} && $from < $map->{source} + $map->{length}) {
            my $diff = $from - $map->{source};
            return $map->{dest} + $diff;
        }
    }

    return $from;
}

