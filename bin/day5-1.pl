#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Input qw(get_ints get_nonempty_groups);

use List::AllUtils qw(:all);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day5';
$file = "inputs/day5-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;
my $total = 0;

my ($seeds, @groups) = get_nonempty_groups($fh);

my @maps = map { input_to_map($_) } @groups;

my @seeds = get_ints(@$seeds);
my @locs = map {
    my $res = $_;
    for my $m (@maps) {
        $res = do_mapping($res, $m);
    }
    $res;
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

