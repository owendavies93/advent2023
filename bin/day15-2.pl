#!/usr/bin/env perl
use Mojo::Base -strict;

use List::AllUtils qw(all);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day15';
$file = "inputs/day15-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;

my $boxes = {};

my $line = <$fh>;
chomp $line;
for my $s (split /,/, $line) {
    my ($label, $op) = $s =~ /([^=-]+)([=-]\d*)/;
    my $hash = hash($label);
    if ($op eq '-') {
        if (defined $boxes->{$hash}) {
            for (my $i = 0; $i < scalar @{$boxes->{$hash}}; $i++) {
                if ($boxes->{$hash}->[$i]->[0] eq $label) {
                    splice @{$boxes->{$hash}}, $i, 1; 
                }
            }
        }
    } else {
        my ($eq, $fl) = split //, $op;
        if (!defined $boxes->{$hash}) {
            push @{$boxes->{$hash}}, [$label, $fl];
        } else {
            my $dupe = 0;
            for (my $i = 0; $i < scalar @{$boxes->{$hash}}; $i++) {
                if ($boxes->{$hash}->[$i]->[0] eq $label) {
                    $dupe = 1;
                    splice @{$boxes->{$hash}}, $i, 1, [$label, $fl];
                }
            }
            if ($dupe == 0) {
                push @{$boxes->{$hash}}, [$label, $fl];
            }
        }
    }
}

my $total = 0;

for my $hash (sort keys %$boxes) {
    for (my $i = 0; $i < scalar @{$boxes->{$hash}}; $i++) {
        my $a = (1 + $hash) * (1 + $i) * $boxes->{$hash}->[$i]->[1];
        $total += $a;
    }
}

say $total;

sub hash {
    my $x = shift;
    my $v = 0;
    for my $c (split //, $x) {
        my $n = ord $c;
        $v += $n;
        $v *= 17;
        $v %= 256;
    }
    return $v;
}

