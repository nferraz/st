#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use App::St;

my $st = App::St->new( keep_data => 1 );

for my $num (1..10) {
  $st->process($num);
}

my %quartiles = (
    0 => 1,
    1 => 3.5,
    2 => 5.5,
    3 => 7.5,
    4 => 10,
);

plan tests => scalar keys %quartiles;

for my $q (keys %quartiles) {
    is($st->quartile($q), $quartiles{$q});
}
