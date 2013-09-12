#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use App::St;

my $st = App::St->new( keep_data => 1 );

for my $num (1..10) {
  $st->process($num);
}

plan tests => 2;

is( $st->q1(), 3.5 );
is( $st->q3(), 7.5 );
