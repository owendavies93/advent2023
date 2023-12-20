#!/usr/bin/env perl
use Mojo::Base -strict;

use List::AllUtils qw(:all);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day20';
$file = "inputs/day20-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;
my $total = 0;
my $ffs = {};
my $conj = {};
my @broadcast;
while (<$fh>) {
    chomp;
    if (/broadcaster/) {
        my ($dests) = /-> (.*)$/;
        @broadcast = split /\s*,\s*/, $dests;
    } elsif (my ($s) = /^%(\w+)/) {
        my ($ds) = /-> (.*)$/;
        my @ds = split /\s*,\s*/, $ds;
        $ffs->{$s} = {
            on => 0,
            dests => [],
        };
        for my $d (@ds) {
            push @{$ffs->{$s}->{dests}}, $d;
        }
    } elsif (($s) = /^&(\w+)/) {
        my ($ds) = /-> (.*)$/;
        my @ds = split /\s*,\s*/, $ds;
        for my $d (@ds) {
            push @{$conj->{$s}->{dests}}, $d;
        }
    }
}

for my $k (keys %$ffs) {
    for my $d (@{$ffs->{$k}->{dests}}) {
        if ($conj->{$d}) {
            $conj->{$d}->{inputs}->{$k} = 1;
        }
    }
}

my $total_l = 0;
my $total_h = 0;
for (1..1000) {
    my ($l, $h) = button_push();
    $total_l += $l;
    $total_h += $h;
}

$total = $total_l * $total_h;

say $total;

sub button_push {
    my $low = 0;
    my $high = 0;
    my @to_process = ({
        lo => 1,
        src => 'button',
        dest => 'broadcaster',
    });

    while (@to_process) {
        my $p = shift @to_process;
        my $d = $p->{dest};
        my $l = $p->{lo};

        if ($l == 1) {
            $low++;
        } else {
            $high++;
        }

        if ($d eq 'broadcaster') {
            for (@broadcast) {
                push @to_process, {
                    lo => $l,
                    src => 'broadcaster',
                    dest => $_,
                };
            }
        } elsif (any { $_ eq $d } (keys %$ffs)) {
            if ($l == 1) {
                my $next_l = 1;
                if ($ffs->{$d}->{on} == 0) {
                    $next_l = 0;
                }

                for (@{$ffs->{$d}->{dests}}) {
                    push @to_process, {
                        lo => $next_l,
                        src => $d,
                        dest => $_,
                    };
                }

                $ffs->{$d}->{on} = 1 - $ffs->{$d}->{on};
            }
        } elsif (any { $_ eq $d } (keys %$conj)) {
            my $s = $p->{src};
            my $is = $conj->{$d}->{inputs};
            $is->{$s} = $l;

            my $next_l = all { $_ == 0 } (values %$is);
            for (@{$conj->{$d}->{dests}}) {
                push @to_process, {
                    lo => $next_l,
                    src => $d,
                    dest => $_,
                }
            }
        }
    }
    return ($low, $high);
}

