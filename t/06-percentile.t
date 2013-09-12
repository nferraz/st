#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use App::St;

my $st = App::St->new( keep_data => 1 );

for my $num (1..10) {
  $st->process($num);
}

my %percentiles = (
    0   => 1,
    0.5 => 5.5,
    1   => 10,
);

plan tests => scalar keys %percentiles;

for my $p (keys %percentiles) {
    is($st->percentile($p), $percentiles{$p});
}
