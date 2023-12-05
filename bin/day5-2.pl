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
my @maps = reverse map { input_to_map($_) } @groups;
my @seeds = get_ints(@$seeds);

my $start_max = 177_942_185; # part 1 answer
my @valid_ranges;
for my $pair (pairs @seeds) {
    my ($start, $length) = @$pair;
    push @valid_ranges, {
        start => $start,
        end   => $start + $length,
    }
}

my $min_loc = $start_max;
my $interval = $file =~ /test/ ? 1 : 1_000_000;
my $new_min = 0;
my $new_max = $start_max;
while ($interval >= 1) { 
    my $new_min_loc = check_range($new_min, $new_max, $interval);
    $new_min = $new_min_loc - $interval;
    $new_max = $new_min_loc + $interval;
    $interval /= 10;
    $min_loc = $new_min_loc if $new_min_loc < $min_loc;
}

say $min_loc;

sub check_range {
    my ($min, $max, $interval) = @_;
    for (my $i = $min; $i < $max; $i += $interval) {
        my $res = $i;
        for my $map (@maps) {
            $res = do_inverse_mapping($res, $map);
        }

        for my $range (@valid_ranges) {
            if ($res >= $range->{start} && $res < $range->{end}) {
                return $i;
            }
        }
    }
}

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

sub do_inverse_mapping {
    my ($from, $mappings) = @_;

    for my $map (@$mappings) {
        if ($from >= $map->{dest} && $from < $map->{dest} + $map->{length}) {
            my $diff = $from - $map->{dest};
            return $map->{source} + $diff;
        }
    }

    return $from;
}

