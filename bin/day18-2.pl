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

my $code_to_dir = {
    0 => 'R',
    1 => 'D',
    2 => 'L',
    3 => 'U',
};

my $total = 0;
my $x = 0;
my $y = 0;
my $area = 0;
my $perim = 0;

while (<$fh>) {
    chomp;
    my ($col) = $_ =~ /\(#(\w+)\)/;
    my $len = hex(substr $col, 0, -1);
    my $code = substr $col, -1;
    
    my $dir = $code_to_dir->{$code};
    my ($dx, $dy) = @{$move->{$dir}};
    
    $dx *= $len;
    $dy *= $len;
    $x += $dx;
    $y += $dy;

    $perim += $len;
    $area += ($x * $dy)
}

say (1 + $area + int($perim / 2));
