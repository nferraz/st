#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

plan tests => 6;

use App::St;

my $st = App::St->new();

# process numbers from 1 to 10
$st->process($_) for (1..10);

is( $st->N(),    10  );
is( $st->min(),  1   );
is( $st->max(),  10  );
is( $st->sum(),  55  );
is( $st->mean(), 5.5 );

is( int($st->stddev()*100)/100, 3.02 );
