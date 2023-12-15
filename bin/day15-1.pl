#!/usr/bin/env perl
use Mojo::Base -strict;

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day15';
$file = "inputs/day15-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;

my $total = 0;
my $line = <$fh>;
chomp $line;
for my $s (split /,/, $line) {
    my $v = 0;
    for my $c (split //, $s) {
        my $n = ord $c;
        $v += $n;
        $v *= 17;
        $v %= 256;
    }
    $total += $v;
}

say $total;
