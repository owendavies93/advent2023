#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Input qw(get_nonempty_groups);

use List::AllUtils qw(:all);

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

my @ps;
for my $r (@$ratings) {
    chomp $r;
    my $pt = {};
    for my $p (split /,/, $r) {
        my ($part, $rating) = $p =~ /([xmas])=(\d+)/;
        $pt->{$part} = $rating;
    }
    push @ps, $pt;
}

my @accepted;

for my $part (@ps) {
    my $cur = 'in';
    OUTER:
    while ($cur ne 'A' && $cur ne 'R') {
        my @conds = @{$ws->{$cur}->{conds}};
        for my $c (@conds) {
            my $cond_res = 0;
            if ($c->{op} eq '>') {
                $cond_res = $part->{$c->{comp}} > $c->{num};
            } else {
                $cond_res = $part->{$c->{comp}} < $c->{num};
            }
            if ($cond_res == 1) {
                $cur = $c->{res};
                next OUTER;
            }
        }

        $cur = $ws->{$cur}->{end};
    }

    push @accepted, $part if $cur eq 'A';
}

say sum map { sum values %$_ } @accepted;
