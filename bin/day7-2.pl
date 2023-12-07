#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Input qw(get_lines);

use List::AllUtils qw(:all);

my @order = reverse ('A', 'K', 'Q', 'T', 9, 8, 7, 6, 5, 4, 3, 2, 'J');

my @types = (
    sub { my $h = shift; scalar keys %$h == 1 },
    sub { my $h = shift; grep { $_ == 4 } values %$h },
    sub { my $h = shift; (grep { $_ == 3 } values %$h) && 
                         (grep { $_ == 2 } values %$h) },
    sub { my $h = shift; grep { $_ == 3 } values %$h },
    sub { my $h = shift; (scalar grep { $_ == 2 } values %$h) == 2 },
    sub { my $h = shift; grep { $_ == 2 } values %$h }
);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day7';
$file = "inputs/day7-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;

my @lines = get_lines($fh);
my @hands;
for my $l (@lines) {
    my ($hand, $bid) = split / /, $l;
    my $dist = {};
    my @hand = split //, $hand;
    $dist->{$_}++ for @hand;
    push @hands, {
        dist => $dist,
        cards => \@hand,
        bid => $bid,
    };
}

my @sorted = sort { compare_strengths($a, $b) } @hands;
my @indicies = (1..(scalar @sorted));
say sum map { my ($a, $b) = @$_; $a->{bid} * $b } pairs zip @sorted, @indicies;

sub compare_strengths {
    my ($f, $s) = @_;

    for my $x (($f, $s)) {
        if (my $j_count = $x->{dist}->{'J'}) {
            my @sort_by_count = sort { $x->{dist}->{$b} <=> $x->{dist}->{$a} } 
                                grep { $_ ne 'J' } keys %{$x->{dist}};
            my $modal = $sort_by_count[0];
            if (!defined $modal) {
                $modal = 'A';
            }
            $x->{dist}->{$modal} += $j_count;
            delete $x->{dist}->{'J'};
        }
    }

    for my $t (@types) {
        return 1 if $t->($f->{dist}) && !$t->($s->{dist});
        return -1 if $t->($s->{dist}) && !$t->($f->{dist});

        if ($t->($f->{dist}) && $t->($s->{dist})) {
            return compare_magnitude($f, $s);
        }
    }

    return compare_magnitude($f, $s);
}

sub compare_magnitude {
    my ($a, $b) = @_;
    my @a = @{$a->{cards}};
    my @b = @{$b->{cards}};

    for my $i (0..4) {
        return -1 if card_mag($a[$i]) < card_mag($b[$i]);
        return 1 if card_mag($a[$i]) > card_mag($b[$i]);
    }
}

sub card_mag {
    my $c = shift;
    return firstidx { $_ eq $c } @order;
}

