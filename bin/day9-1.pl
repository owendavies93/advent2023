#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Input qw(get_ints);

use List::AllUtils qw(:all);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day9';
$file = "inputs/day9-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;
my $total = 0;
while (<$fh>) {
    chomp;
	my @nums = get_ints($_, 1);
	my @rest;
	while (scalar @nums > 0) {
		for (my $i = 0; $i < $#nums; $i++) {
			$nums[$i] = $nums[$i + 1] - $nums[$i];
		}
		my $n = pop @nums;
		push @rest, $n;
	}
	$total += sum @rest;
}

say $total;

