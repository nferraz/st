#!perl

use strict;
use warnings;

#use bignum;

use Data::Dumper;
use Getopt::Long;
use Pod::Usage;

use App::St;

my %opt;
GetOptions(
  \%opt,

  # functions
  'N|n|count',
  'mean|avg|m',
  'stddev|sd',
  'stderr|sem|se',
  'sum|s',
  'variance|var',

  'min|q0',
  'q1',
  'median|q2',
  'q3',
  'max|q4',
  'percentile=f',
  'quartile=i',

  # predefined output sets
  'summary',
  'complete|everything|all',
  'default',

  # output control
  'delimiter|d=s',
  'format|fmt|f=s',
  'no-header|nh',
  'transpose-output|transverse-output|to',

  # error handling
  'quiet|q',
  'strict',

  'help|h',
) or pod2usage(1);

pod2usage(1) if $opt{help};

my %config = get_config(%opt);
my @stats  = statistical_options(%opt);

if (   $opt{summary}
    or $opt{complete}
    or $opt{q1}
    or $opt{median}
    or $opt{q3}
    or defined $opt{percentile}
    or defined $opt{quartile} )
{
    $config{keep_data} = 1;
}

# special cases: percentile and quartile are not booleans
my %special_parameters = map { $_ => $opt{$_} } grep { exists $opt{$_} } qw/percentile quartile/;

my $st = App::St->new(%config, %special_parameters);

my $n = 0;
while (my $num = <>) {
  chomp $num;

  $n++;
  if (!$st->validate($num)) {
      my $err = "Invalid value '$num' on input line $.\n";
      if ($opt{strict}) {
        die $err;
      } elsif (!$opt{quiet}) {
        warn $err;
      }
      next;
  }

  $st->process($num);
}

exit if $st->N() == 0;

my %result = $st->result();

my @opt = grep { exists $result{$_} } statistical_options(%opt);

if (scalar @opt == 1) {
  print sprintf( $config{format}, $result{$opt[0]} ), "\n";
  exit;
}

if ($config{'transpose-output'}) {
  for my $opt (@opt) {
    print "$opt$config{delimiter}" unless $config{'no-header'};
    print sprintf( $config{format}, $result{$opt} ), "\n";
  }
} else {
  print join($config{delimiter}, @opt), "\n" unless $config{'no-header'};
  print join($config{delimiter}, map { sprintf ($config{format}, $result{$_}) } @opt), "\n";
}

exit;

###

sub get_config {
  my %opt = @_;

  my %config = map { $_ => $opt{$_} } grep { exists $opt{$_} } qw/delimiter format no-header transpose-output quiet strict/;

  my $delimiter  = $opt{'delimiter'} || "\t";
  my $format     = $opt{'format'}    || '%g';

  if ($delimiter =~ /^\\[a-z]$/) {
    $delimiter = $delimiter eq '\t' ? "\t"
               : $delimiter eq '\n' ? "\n"
                                    : die "Invalid delimiter: '$delimiter'\n";
  }

  if ($format =~ m{( \s* \% [\s+-]? [0-9]*\.?[0-9]* [deEfgGi] \s* )}x) {
    $format = $1;
  } else {
    die "Invalid format: '$format'\n";
  }

  return (%config, delimiter => $delimiter, format => $format);

}

sub statistical_options {
  my %opt = @_;

  # predefined sets
  my %predefined = (
    complete => [ qw/N min q1 median q3 max sum mean stddev stderr variance percentile quartile/ ],
    summary  => [ qw/min q1 median q3 max/ ],
    default  => [ qw/N min max sum mean stddev/ ],
  );

  # selected options
  my %selected = map { $_ => 1 } grep { exists $opt{$_} } @{ $predefined{complete} };

  # expand with predefined sets
  for my $set (keys %predefined) {
    if ($opt{$set}) {
      %selected = (%selected, map { $_ => 1 } @{ $predefined{$set} });
    }
  }

  my @selected = %selected ? grep { exists $selected{$_} } @{ $predefined{complete} }
                           : @{ $predefined{default} };

  return @selected;
}

__END__

=head1 NAME

st - simple statistics from the command line interface (CLI)

=head1 DESCRIPTION

C<st> is a command-line tool to calculate simple statistics from a
file or standard input.

=head1 USAGE

  st [options] [input_file]

=head2 OPTIONS

=head3 FUNCTIONS

  --N|n|count           # sample size
  --min                 # minimum
  --max                 # maximum
  --mean|average|avg|m  # mean
  --stdev|sd            # standard deviation
  --stderr|sem|se       # standard error of mean
  --sum|s               # sum of elements of the sample
  --variance|var        # variance

The following options require that the whole dataset is stored in
memory, which can be problematic for huge datasets:

  --q1                  # first quartile
  --median|q2           # second quartile, or median
  --q3                  # third quartile
  --percentile=f        # percentile=<0..100>
  --quartile=i          # quartile=<1..4>

If no functions are selected, C<st> will print the default output:

    N     min  max  sum  mean  stddev

You can also use the following predefined sets of functions:

  --summary   # five-number summary (min q1 median q3 max)
  --complete  # everything

=head3 FORMATTING

    --format|fmt|f=<value>  # default: "%g"

Examples of valid formats:

      %d    signed integer, in decimal
      %e    floating-point number, in scientific notation
      %f    floating-point number, in fixed decimal notation
      %g    floating-point number, in %e or %f notation

  --delimiter|d=<value>   # default: "\t"

  --no-header|nh          # don't display header
  --transpose-output|to   # switch rows and columns

=head3 INPUT VALIDATION

By default, C<st> skips invalid input with a warning.

You can change this behavior with the following options:

  --strict   # throws an error, interrupting process
  --quiet|q  # no warning

=head1 AUTHOR

Nelson Ferraz L<<nferraz@gmail.com>>

=head1 CONTRIBUTE

Send comments, suggestions and bug reports to:

https://github.com/nferraz/st/issues

Or fork the code on github:

https://github.com/nferraz/st

=head2 THANKS

imurray, who suggested a different algorithm for calculating variance.

asgeirn, who suggested a input filter and helped to remove some
warnings.

gabeguz, who modified the script to make it more portable.

=head1 COPYRIGHT

Copyright (c) 2013 Nelson Ferraz.

This program is free software; you can redistribute it and/or modify
it under the MIT License (see LICENSE).
