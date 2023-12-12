#!/usr/bin/env perl
use Mojo::Base -strict;

no warnings 'recursion';

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day12';
$file = "inputs/day12-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;

my $total = 0;
my $states;
while (<$fh>) {
    chomp;
    $states = {};
    my ($ss, $gs) = split /\s+/;
    $ss = join '?', ($ss) x 5;
    $gs = join ",", ($gs) x 5;
    my @ss = split //, $ss;
    my @gs = split /,/, $gs;

    my $c = get_combs(\@ss, 0, \@gs, 0, 0);
    $total += $c;
}

say $total;

sub get_combs {
    my ($ss, $sp, $gs, $gp, $len) = @_;

    my $k = join "-", ($sp, $gp, $len);
    return $states->{$k} if exists $states->{$k};

    if ($sp == scalar @$ss) {
        return (($gp == scalar @$gs && $len == 0) ||
                ($gp == (scalar @$gs - 1) && $gs->[$gp] == $len));
    }

    my $combs = 0;
    my $cur = $ss->[$sp];
    my @next = $cur eq '?' ? ('.', '#') : ($cur);
    for my $c (@next) {
        if ($c eq '#') {
            $combs += get_combs($ss, $sp + 1, $gs, $gp, $len + 1);
        } else {
            if ($len == 0) {
                $combs += get_combs($ss, $sp + 1, $gs, $gp, 0);
            } elsif ($gp < scalar @$gs && $gs->[$gp] == $len) {
                $combs += get_combs($ss, $sp + 1, $gs, $gp + 1, 0);
            }
        }
    }
    
    $states->{$k} = $combs;
    return $combs;
}

