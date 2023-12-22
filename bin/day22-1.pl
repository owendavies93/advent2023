#!/usr/bin/env perl
use Mojo::Base -strict;

use Storable qw(dclone);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day22';
$file = "inputs/day22-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;

my $bricks;
my $occupied_blocks = {};
while (<$fh>) {
    chomp;
    my ($s, $e) = split /~/;
    my ($x1, $y1, $z1) = split /,/, $s;
    my $b = {
        s => { x => $x1, y => $y1, z => $z1 }
    };

    my ($x2, $y2, $z2) = split /,/, $e;

    $b->{e} = { x => $x2, y => $y2, z => $z2 };

    push @$bricks, $b;

    for my $x ($x1..$x2) {
        for my $y ($y1..$y2) {
            for my $z ($z1..$z2) {
                $occupied_blocks->{$x,$y,$z} = 1;
            }
        }
    }
}

$bricks = [ sort { $a->{s}->{z} <=> $b->{s}->{z} } @$bricks ];

for (my $i = 0; $i < scalar @$bricks; $i++) {
    my $b = $bricks->[$i];
    ($b) = settle_brick($b, $occupied_blocks);
}

my $total = 0;
for (my $i = 0; $i < scalar @$bricks; $i++) {
    my $tmp = dclone($bricks);
    my $obs = dclone($occupied_blocks);
    my $b = splice @$tmp, $i, 1;

    for my $x (($b->{s}->{x})..($b->{e}->{x})) {
        for my $y (($b->{s}->{y})..($b->{e}->{y})) {
            for my $z (($b->{s}->{z})..($b->{e}->{z})) {
                delete $obs->{$x,$y,$z};
            }
        }
    }

    my $moved = 0; 
    for (my $j = $i; $j < scalar @$tmp; $j++) {
        my $tb = $tmp->[$j];
        my ($tb_, $tm) = settle_brick($tb, $obs);
        if ($tm > 0) {
            $moved++;
            last;
        }
    }

    $total++ if $moved == 0;
}

say $total;

sub settle_brick {
    my ($b, $obs) = @_;
    my $can_move = 1;
    my $moved = 0;
    while ($can_move) {
        my $start_z = $b->{s}->{z};
        my $end_z = $b->{e}->{z};
        last if $start_z == 1;

        OUTER:
        for my $x (($b->{s}->{x})..($b->{e}->{x})) {
            for my $y (($b->{s}->{y})..($b->{e}->{y})) {
                if (exists $obs->{$x,$y,$start_z - 1}) {
                    $can_move = 0;
                    last OUTER;
                }
            }
        }
        if ($can_move == 1) {
            $moved = 1;

            for my $x (($b->{s}->{x})..($b->{e}->{x})) {
                for my $y (($b->{s}->{y})..($b->{e}->{y})) {
                    delete $obs->{$x,$y,$end_z};
                    $obs->{$x,$y,$start_z - 1} = 1;
                }
            }
            $b->{s}->{z}--;
            $b->{e}->{z}--;
        }
    }

    return ($b, $moved);
}

