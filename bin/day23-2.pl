#!/usr/bin/env perl
use Mojo::Base -strict;

use List::AllUtils qw(:all);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day23';
$file = "inputs/day23-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;

my @grid;
my $width;
my $height = 0;
while (<$fh>) {
    chomp;
    my @line = split //;
    push @grid, @line;
    $width = scalar @line if !defined $width;
    $height++;
}

my $adj_graph = {};

my @dirs = (
    [0,-1],[1,0],[0,1],[-1,0]
);

for (my $y = 0; $y < $height; $y++) {
    for (my $x = 0; $x < $width ; $x++) {
        my $e = $grid[$y * $width + $x];
        next if $e eq '#';

        my $adj = {};
        for (my $i = 0; $i < scalar @dirs; $i++) {
            my ($dx, $dy) = @{$dirs[$i]};
            my $nx = $x + $dx;
            my $ny = $y + $dy;
            next if $nx < 0 || $ny < 0 || $nx >= $width || $ny >= $height;
            
            my $ne = $grid[$ny * $width + $nx];
            next if $ne eq '#';

            $adj->{$nx,$ny} = 1;
        }

        $adj_graph->{$x,$y} = $adj;
    }
}

my $keep = {};
for my $k (keys %$adj_graph) {
    my $adj = $adj_graph->{$k};
    if (scalar keys %$adj > 2) {
        $keep->{$k} = 1;
    }
}
$keep->{1,0} = 1;
$keep->{$width - 2, $height - 1} = 1;

my $final_adjs = {};

for my $k (keys %$keep) {
    my @q = ($k);
    my $seen = { $k => 1 };
    my $dist = 0;

    while (@q) {
        my @nq = ();
        $dist++;
        
        for my $c (@q) {
            my $adj = $adj_graph->{$c};
            for my $a (keys %$adj) {
                if (!$seen->{$a}) {
                    if ($keep->{$a}) {
                        $final_adjs->{$k}->{$a} = $dist;
                        $seen->{$a} = 1;
                    } else {
                        $seen->{$a} = 1;
                        push @nq, $a;
                    }
                }
            }
        }
        @q = @nq;
    }
}

my $first = join $;, (1,0);
my $last = join $;, ($width - 2, $height - 1);
my $s = {};

say dfs($first);

sub dfs {
    my $cur = shift;
    return 0 if $cur eq $last;

    $s->{$cur} = 1;
    my $max_path;
    for my $adj (keys %{$final_adjs->{$cur}}) {
        my $dist = $final_adjs->{$cur}->{$adj};
        next if $s->{$adj};
        my $sub = dfs($adj);
        next unless defined $sub;
        $sub += $dist;
        $max_path = $sub if !defined $max_path || $sub > $max_path;
    }

    delete $s->{$cur};
    return $max_path;
}

