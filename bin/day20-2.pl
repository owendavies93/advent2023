#!/usr/bin/env perl
use Mojo::Base -strict;

use List::AllUtils qw(:all);
use Math::Utils qw(lcm);

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

my $source_for_rx = first { $conj->{$_}->{dests}->[0] eq 'rx' } keys %$conj;
my %sources_for_rx = map { $_ => 1 }
                     grep { $conj->{$_}->{dests}->[0] eq $source_for_rx }
                     keys %$conj;

my $source_periods = {};
my $cycles = 1;
while (scalar keys %$source_periods < scalar keys %sources_for_rx) {
    button_push();
    $cycles++;
}

say lcm values %$source_periods;

sub button_push {
    my @to_process = ({
        lo => 1,
        src => 'button',
        dest => 'broadcaster',
    });

    while (@to_process) {
        my $p = shift @to_process;
        my $d = $p->{dest};
        my $l = $p->{lo};

        if ($sources_for_rx{$d} && $l == 1 && !defined $source_periods->{$d}) {
            $source_periods->{$d} = $cycles;
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
}

