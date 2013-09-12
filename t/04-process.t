#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

my @num = (1..10);

plan tests => 1;

use App::St;

my $st = App::St->new();

for my $num (@num) {
  $st->process($num);
}

pass();
