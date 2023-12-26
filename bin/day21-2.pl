#!/usr/bin/env perl
use Mojo::Base -strict;

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day21';
$file = "inputs/day21-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;

my $rs = {};
my $h = 0;
my $w;
my $startx;
my $starty;

while (<$fh>) {
    chomp;
    my @l = split //;
    
    for (my $i = 0; $i < scalar @l; $i++) {
        $rs->{$i,$h} = 1 if $l[$i] eq '#';

        if ($l[$i] eq 'S') {
            $startx = $i;
            $starty = $h;
        }
    }

    $w = scalar @l if !defined $w;
    $h++;
}

my $cur_locs = {};
my @parity_sets = ({}, {});
$cur_locs->{$startx,$starty,0,0} = 1;

my @ds = (
    [0,-1],[1,0],[0,1],[-1,0]
);

my $i = 0;
my $new = {};
my $target = 26501365;
my $point = $startx;
my @points;

while (1) {
    if ($i == $point) {
        my $n = scalar keys %{$parity_sets[($i + 1) % 2]};
        push @points, $n;
        $point += $w;
        last if scalar @points == 3;
    }
    my $new = {};
    my $set = $parity_sets[$i % 2];
    for my $l (keys %$cur_locs) {
        my ($x, $y, $ex, $ey) = split $;, $l;
        for my $d (@ds) {
            my ($dx, $dy) = @$d;
            my $nx = ($x + $dx) % $w;
            my $ny = ($y + $dy) % $h;
            my $nex = $ex + $dx;
            my $ney = $ey + $dy;

            next if $rs->{$nx,$ny};

            next if $set->{$nx,$ny,$nex,$ney}++;

            $new->{$nx,$ny,$nex,$ney} = 1;
        }
    }
    $cur_locs = $new;
    $i++;
}

my $goal = int($target / $w);
my ($p0, $p1, $p2) = @points;
my $d1 = $p1 - $p0;
my $d2 = $p2 - $p1;
my $dd1 = $d2 - $d1;

my $res = $p0 + $d1 * $goal + $dd1 * int(($goal * ($goal - 1) / 2));
say $res;

