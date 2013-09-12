#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

my %validation = (
  # valid
  '123'    => 1,
  '00123'  => 1,
  '+123'   => 1,
  '-123'   => 1,
  '123.0'  => 1,
  '1.23E2' => 1,
  '1.23'   => 1,
  '.123'   => 1,

  # invalid
  ''       => 0,
  'x'      => 0,
  '1X2'    => 0,
);

plan tests => scalar keys %validation;

use App::St;

my $st = App::St->new();

for my $num (keys %validation) {
  my $result = $validation{$num};
  ok( $st->validate($num) == $result );
}
