#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Input qw(get_nonempty_groups);

use List::AllUtils qw(:all);
use Storable qw(dclone);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day19';
$file = "inputs/day19-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;

my ($workflows, $ratings) = get_nonempty_groups($fh);

my $ws = {};
for my $w (@$workflows) {
    chomp $w;
    my ($name, $rules) = $w =~ /^(\w+)\{(.+)\}$/;
    my @conds;
    for my $c (split /,/, $rules) {
        if (my ($end) = $c =~ /^(\w+)$/) {
            $ws->{$name}->{end} = $end;
            last;
        }

        my ($comp, $op, $num, $res) = $c =~ /^([xmas])(.)(\d+):(\w+)$/;
        push @conds, {
            comp => $comp,
            op => $op,
            num => $num,
            res => $res,
        };
    }

    $ws->{$name}->{conds} = \@conds;
}

my $start_ranges = {};
$start_ranges->{$_} = [1,4001] for ('x','m','a','s');

say count_combs('in', $start_ranges);

sub count_combs {
    my ($cur, $ranges) = @_;

    return 0 if $cur eq 'R';
    
    if ($cur eq 'A') {
        return product map { $_->[1] - $_->[0] } values %$ranges;
    }

    my @conds = @{$ws->{$cur}->{conds}};

    my $res = 0;
    for my $c (@conds) {
        my ($l, $h);
        my $other_ranges = dclone($ranges); 
        
        if ($c->{op} eq '>') {
            ($l, $h) = range_between($ranges->{$c->{comp}}, $c->{num} + 1);
            $ranges->{$c->{comp}} = $l;
            $other_ranges->{$c->{comp}} = $h;
        } else {
            ($l, $h) = range_between($ranges->{$c->{comp}}, $c->{num});
            $ranges->{$c->{comp}} = $h;
            $other_ranges->{$c->{comp}} = $l;
        }

        $res += count_combs($c->{res}, $other_ranges);
    }

    $res += count_combs($ws->{$cur}->{end}, $ranges);

    return $res;
}

sub range_between {
    my ($range, $v) = @_;

    my ($l, $h) = @$range;
    return (undef, $range) if $v <= $l;
    return ($range, undef) if $v >= $h;

    return ([$l, $v], [$v, $h]);
}

