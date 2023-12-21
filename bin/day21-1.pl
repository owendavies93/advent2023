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
$cur_locs->{$startx,$starty} = 1;

my @ds = (
    [0,-1],[1,0],[0,1],[-1,0]
);

my $end = $file !~ /test/ ? 64 : 6;

for (1..$end) {
    my $new = {};
    for my $l (keys %$cur_locs) {
        my ($x, $y) = split $;, $l;
        for my $d (@ds) {
            my ($dx, $dy) = @$d;
            my $nx = $x + $dx;
            my $ny = $y + $dy;

            next if $nx < 0 || $ny < 0 || $nx >= $w || $ny >= $h;

            if (!exists $rs->{$nx,$ny}) {
                $new->{$nx,$ny} = 1;
            }
        }
    }
    $cur_locs = $new;
}

say scalar keys %$cur_locs;

