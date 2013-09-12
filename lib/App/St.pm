package App::St;

use strict;
use warnings;

use bignum;

sub new {
  my ($class, %opt) = @_;

  my $delimiter  = $opt{'delimiter'} || "\t";
  my $format     = $opt{'format'}    || '%.2f';

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


  bless {
    %opt,
    N          => 0,
    sum        => 0,
    sum_square => 0,
    mean       => 0,
    stddev     => 0,
    stderr     => 0,
    min        => undef,
    q1         => 0,
    median     => 0,
    q3         => 0,
    max        => undef,
    M2         => 0,
    delimiter  =>$delimiter,
    format     => $format,
  }, $class;
}

sub validate {
  my ($self, $num) = @_;

  return ($num =~ m{^
    [+-]?
    (?: \. ? [0-9]+
      | [0-9]+ \. [0-9]*
      | \. ? [0-9]+ E [+-]? [0-9]+
      | [0-9]* \. [0-9]+ E [+-]? [0-9]+
    )
  $}x);
}

sub process {
  my ($self, $num) = @_;

  die "Invalid input '$num'\n" if !$self->validate($num);

  $self->{N}++;

  $self->{sum} += $num;

  $self->{min} = $num if (!defined $self->{min} or $num < $self->{min});
  $self->{max} = $num if (!defined $self->{max} or $num > $self->{max});

  my $delta = $num - $self->{mean};

  $self->{mean} += $delta / $self->{N};
  $self->{M2}   += $delta * ($num - $self->{mean});
}

sub N {
  return $_[0]->{N};
}

sub sum {
  return $_[0]->{sum};
}

sub min {
  return $_[0]->{min};
}

sub max {
  return $_[0]->{max};
}

sub mean {
  my ($self,%opt) = @_;

  my $mean = $self->{mean};

  return $opt{formatted} ? $self->_format($mean)
                         : $mean;
}

sub q1 {
  die "Not implemented\n";
}

sub median {
  die "Not implemented\n";
}

sub q3 {
  die "Not implemented\n";
}

sub variance {
  my ($self,%opt) = @_;

  my $N  = $self->{N};
  my $M2 = $self->{M2};

  my $variance = $N > 1 ? $M2 / ($N - 1) : undef;

  return $opt{formatted} ? $self->_format($variance)
                         : $variance;
}

sub stddev {
  my ($self,%opt) = @_;

  my $variance = $self->variance();

  my $stddev = defined $variance ? sqrt($variance) : undef;

  return $opt{formatted} ? $self->_format($stddev)
                         : $stddev;
}

sub stderr {
  my ($self,%opt) = shift;

  my $stddev = $self->stddev();
  my $N      = $self->N();

  my $stderr  = defined $stddev ? $stddev/sqrt($N) : undef;

  return $opt{formatted} ? $self->_format($stderr)
                         : $stderr;
}

sub _format {
  my ($self,$value,%opt) = @_;

  my $format = $self->{format};

  return sprintf( $format, $value );
}

1;

__END__

=head1 NAME

  App::St - Simple Statistics

=head1 DESCRIPTION

App::St provides the core functionality of the L<st> application.

=head1 SYNOPSIS

  use App::St;

  my $st = App::St->new();

  while (<>) {
    chomp;
    next unless $st->validate($_);
    $st->process($_);
  }

  print $st->mean();
  print $st->stddev();
  print $st->sterr();

=head1 METHODS

=head2 new(%opt)

=head2 validate($num)

=head2 process($num)

=head1 AUTHOR

Nelson Ferraz L<<nferraz@gmail.com>>

=head1 CONTRIBUTING

Send comments, suggestions and bug reports to:

https://github.com/nferraz/st/issues

Or fork the code on github:

https://github.com/nferraz/st

=head1 COPYRIGHT

Copyright (c) 2013 Nelson Ferraz.

This program is free software; you can redistribute it and/or modify
it under the MIT License (see LICENSE).
