#!/usr/bin/env perl
use Mojo::Base -strict;

use Storable qw(dclone);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day22';
$file = "inputs/day22-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;

my $bricks;
while (<$fh>) {
    chomp;
    my ($s, $e) = split /~/;
    my ($x, $y, $z) = split /,/, $s;
    my $b = {
        s => { x => $x, y => $y, z => $z }
    };

    ($x, $y, $z) = split /,/, $e;

    $b->{e} = { x => $x, y => $y, z => $z };

    push @$bricks, $b;
}

my $moved = 1;
while ($moved > 0) {
    ($moved, $bricks) = settle_step($bricks);
}

my $total = 0;
for (my $i = 0; $i < scalar @$bricks; $i++) {
    my $tmp = dclone($bricks);
    splice @$tmp, $i, 1;
    my $cmp = dclone($tmp);

    my $moved = 1;
    while ($moved > 0) {
        ($moved, $tmp) = settle_step($tmp);    
    }

    my $differences = 0;
    for (my $j = 0; $j < scalar @$tmp; $j++) {
        $differences++ if not equals($tmp->[$j], $cmp->[$j]);
    }

    $total += $differences;
}

say $total;

sub equals {
    my ($a, $b) = @_;

    for my $o (qw(s e)) {
        for my $i (qw(x y z)) {
            return 0 if $a->{$o}->{$i} != $b->{$o}->{$i};
        }
    }

    return 1;
}

sub settle_step {
    my $bricks = shift;
    my $move_down_count = 0;

    my $occupied_blocks = {};

    for my $b (@$bricks) {
        my $z = $b->{e}->{z};
        for my $x (($b->{s}->{x})..($b->{e}->{x})) {
            for my $y (($b->{s}->{y})..($b->{e}->{y})) {
                $occupied_blocks->{$x,$y,$z} = 1;
            }
        }
    }

    my @new_bricks;

    for my $b (@$bricks) {
        my $can_move = 1;
        my $start_z = $b->{s}->{z};

        OUTER:
        for my $x (($b->{s}->{x})..($b->{e}->{x})) {
            for my $y (($b->{s}->{y})..($b->{e}->{y})) {
                if ($start_z == 1 || exists $occupied_blocks->{$x,$y,$start_z - 1}) {
                    $can_move = 0;
                    last OUTER;
                }
            }
        }
        if ($can_move == 1) {
            $move_down_count++;
            my $new_b = dclone($b);
            $new_b->{s}->{z}--;
            $new_b->{e}->{z}--;
            push @new_bricks, $new_b;
        } else {
            push @new_bricks, $b;
        }
    }

    return ($move_down_count, \@new_bricks);
}

