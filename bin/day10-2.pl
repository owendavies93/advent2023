#!/usr/bin/env perl
use Mojo::Base -strict;

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day10';
$file = "inputs/day10-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;

my $y = 0;
my @grid;
my ($width, $height);
my $ns = {};
my ($startx, $starty);

while (<$fh>) {
    chomp;
    my @chrs = split //;
    $width = scalar @chrs;
    my $x = 0;
    for my $ch (@chrs) {
        push @grid, $ch;
        if ($ch eq 'S') {
            $startx = $x;
            $starty = $y;
        } else {
            $ns->{$x,$y} = {
                ch => $ch,
                ns => get_ns($ch, $x, $y),
            };
        }
        $x++;
    }
    $y++;
}
$height = $y;

# TODO: changes depending on input
if ($file =~ /test/) {
    $ns->{$startx,$starty} = {
        ch => 'F',
        ns => [[$startx, $starty + 1], [$startx + 1, $starty]],
    };
    $grid[$starty * $width + $startx] = 'F';
} elsif ($file eq 'inputs/day10') {
    $ns->{$startx,$starty} = {
        ch => '7',
        ns => [[$startx, $starty + 1], [$startx - 1, $starty]],
    };
    $grid[$starty * $width + $startx] = '7';
}

my $curx = $ns->{$startx,$starty}->{ns}->[0]->[0];
my $cury = $ns->{$startx,$starty}->{ns}->[0]->[1];
my $lastx = $startx;
my $lasty = $starty;
my $length = 1;
my $visited = {};
$visited->{$curx,$cury} = 1;

while ($curx != $startx || $cury != $starty) {
    my $neighs = $ns->{$curx,$cury}->{ns};
    for (@$neighs) {
        if ($_->[0] != $lastx || $_->[1] != $lasty) {
            $lastx = $curx;
            $lasty = $cury;
            $curx = $_->[0];
            $cury = $_->[1];
            $visited->{$curx,$cury} = 1;
            last;
        }
    }
    $length++;
}

my $total = 0;

for $y (0..$height - 1) {
    for my $x (0..$width - 1) {
        if (!$visited->{$x,$y}) {
            $grid[$y * $height + $x] = '.';
        }
    }
    my $start = $y * $width;
    my $end = $y * $width + $width - 1;
    my $row = join "", @grid[$start..$end];
    $row =~ s/F-*J|L-*7/\|/g;

    my $inside = 0;
    for my $ch (split //, $row) {
        if ($ch eq '|') {
            $inside = !$inside;
        } elsif ($ch eq '.' && $inside) {
            $total++;
        }
    }
}

say $total;

sub get_ns {
    my ($ch, $x, $y) = @_;
    if ($ch eq '|') {
        return [[$x, $y - 1], [$x, $y + 1]];
    } elsif ($ch eq '-') {
        return [[$x + 1, $y], [$x - 1, $y]];
    } elsif ($ch eq 'L') {
        return [[$x, $y - 1], [$x + 1, $y]]; 
    } elsif ($ch eq 'J') {
        return [[$x, $y - 1], [$x - 1, $y]];
    } elsif ($ch eq '7') {
        return [[$x, $y + 1], [$x - 1, $y]];
    } elsif ($ch eq 'F') {
        return [[$x, $y + 1], [$x + 1, $y]];
    } else {
        die $ch if $ch ne '.';
    }
}

