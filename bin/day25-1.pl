#!/usr/bin/env perl
use Mojo::Base -strict;

no warnings 'recursion';

use List::AllUtils qw(:all);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day25';
$file = "inputs/day25-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;
my $total = 0;
my $edges = {};
while (<$fh>) {
    chomp;
    my ($to, $from) = split /: /;
    my @froms = split / /, $from;

    for my $f (@froms) {
        $edges->{$f}->{$to} = 1;
        $edges->{$to}->{$f} = 1;
    }
}

my @edges_to_remove;
if ($file !~ /test/) {
    @edges_to_remove = (qw(rks.kzh dgt.tnz ddc.gqm));
} else {
    @edges_to_remove = (qw(hfx.pzl bvb.cmg nvd.jqt));
}

for my $p (@edges_to_remove) {
    my ($to, $from) = split /\./, $p;
    delete $edges->{$to}->{$from};
    delete $edges->{$from}->{$to};
}

my $cc = connected_components($edges);
say product map { scalar @$_ } @$cc;

sub connected_components {
    my $g = shift;
    my $seen = {};
    my @cc;

    for my $v (keys %$g) {
        if (!defined $seen->{$v}) {
            push @cc, cc_([], $v, $seen);
        }
    }
    return \@cc;
}

sub cc_ {
    my ($comp, $v, $seen) = @_;

    $seen->{$v} = 1;

    push @$comp, $v;

    for my $n (keys %{$edges->{$v}}) {
        if (!defined $seen->{$n}) {
            $comp = cc_($comp, $n, $seen);
        }
    }

    return $comp;
}

