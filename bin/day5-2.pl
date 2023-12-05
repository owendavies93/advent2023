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
        my $loc   = $i;
        my $hum   = do_inverse_mapping($loc, $h2l_map);
        my $temp  = do_inverse_mapping($hum, $t2h_map);
        my $light = do_inverse_mapping($temp, $l2t_map);
        my $water = do_inverse_mapping($light, $w2l_map);
        my $fert  = do_inverse_mapping($water, $f2w_map);
        my $soil  = do_inverse_mapping($fert, $s2f_map);
        my $seed  = do_inverse_mapping($soil, $s2s_map);

        for my $range (@valid_ranges) {
            if ($seed >= $range->{start} && $seed < $range->{end}) {
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

