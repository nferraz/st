#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use App::St;

my $st = App::St->new( keep_data => 1 );

# process numbers from 1 to 10
$st->process($_) for (1..10);

my %result = $st->result();

my %expected = (
    min    => 1,
    q1     => 3.5,
    median => 5.5,
    q3     => 7.5,
    max    => 10,
    mean   => 5.5,
);

plan tests => scalar keys %expected;

for my $stat (keys %expected) {
    is($result{$stat}, $expected{$stat});
}

