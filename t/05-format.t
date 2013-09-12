#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

plan tests => 6;

use App::St;

my $st = App::St->new(
  format => '%.5f'
);

# process numbers from 1 to 10
$st->process($_) for (1..10);

# non-formatted
cmp_ok( $st->N(),   'eq', '10'  );
cmp_ok( $st->min(), 'eq', '1'   );
cmp_ok( $st->max(), 'eq', '10'  );
cmp_ok( $st->sum(), 'eq', '55'  );

# formatted
cmp_ok( $st->mean( formatted => 1 ),  'eq', '5.50000'  );
cmp_ok( $st->stddev( formatted => 1), 'eq', '3.02765' );
