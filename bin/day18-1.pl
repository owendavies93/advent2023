#!/usr/bin/env perl
use Mojo::Base -strict;

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day18';
$file = "inputs/day18-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;

my $move = {
    R => [1,0],
    D => [0,1],
    U => [0,-1],
    L => [-1,0],
};

my $total = 0;
my $x = 0;
my $y = 0;
my $trench = {};
$trench->{$x,$y} = 1;
while (<$fh>) {
    chomp;
    my ($dir, $len) = $_ =~ /([RDUL])\s+(\d+)/;
    my ($dx, $dy) = @{$move->{$dir}};
    while ($len > 0) {
        $x += $dx;
        $y += $dy;
        $trench->{$x,$y} = 1;
        $len--;
    }
}

my $minx = my $miny = ~0;
my $maxx = my $maxy = 0;
my @all = keys %$trench;
$total += scalar @all;

for my $i (@all) {
    my ($x, $y) = split $;, $i;
    $minx = $x if $x < $minx;
    $maxx = $x if $x > $maxx;
    $miny = $y if $y < $miny;
    $maxy = $y if $y > $maxy;
}

my $filled = {};
my @q;

# TODO: how to pick these?
my $startx = 1;
my $starty = 1;
push @q, [$startx, $starty];
while (@q) {
    my $cur = shift @q;
    my ($x, $y) = @$cur;

    next if $x < $minx || $x > $maxx || $y < $miny || $y > $maxy;
    next if exists $trench->{$x,$y};
    next if exists $filled->{$x,$y};

    $filled->{$x,$y} = 1;

    push @q, [$x+1,$y];
    push @q, [$x,$y+1];
    push @q, [$x-1,$y];
    push @q, [$x,$y-1];
}

$total += scalar keys %$filled;

say $total;
