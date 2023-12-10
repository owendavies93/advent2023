#!/usr/bin/env perl
use Mojo::Base -strict;

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day10';
$file = "inputs/day10-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;

my $y = 0;
my $ns = {};
my ($startx, $starty);
while (<$fh>) {
    chomp;
    my @chrs = split //;
    my $x = 0;
    for my $ch (@chrs) {
        if ($ch eq 'S') {
            $startx = $x;
            $starty = $y;
            # TODO: changes depending on input
            if ($file =~ /test/) {
                $ns->{$x,$y} = [[$x, $y + 1], [$x + 1, $y]],
            } elsif ($file eq 'inputs/day10') {
                $ns->{$x,$y} = [[$x, $y + 1], [$x - 1, $y]],
            }
        } else {
            $ns->{$x,$y} = get_ns($ch, $x, $y);
        }
        $x++;
    }
    $y++;
}

my $curx = $ns->{$startx,$starty}->[0]->[0];
my $cury = $ns->{$startx,$starty}->[0]->[1];
my $lastx = $startx;
my $lasty = $starty;
my $length = 1;

while ($curx != $startx || $cury != $starty) {
    my $neighs = $ns->{$curx,$cury};
    for (@$neighs) {
        if ($_->[0] != $lastx || $_->[1] != $lasty) {
            $lastx = $curx;
            $lasty = $cury;
            $curx = $_->[0];
            $cury = $_->[1];
            last;
        }
    }
    $length++;
}

say $length / 2;

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
    }
}

