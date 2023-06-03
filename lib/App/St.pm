package App::St;

use strict;
use warnings;

#use bignum;
use Scalar::Util qw(looks_like_number);

our $VERSION = '1.1.3';

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

  return bless {
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
    delimiter  => $delimiter,
    format     => $format,
    data       => [],
  }, $class;
}

sub validate {
  my (undef, $num) = @_;
  return looks_like_number($num);
}

sub process {
  my ($self, $num) = @_;

  $self->{N}++;

  $self->{sum} += $num;

  $self->{min} = $num if (!defined $self->{min} or $num < $self->{min});
  $self->{max} = $num if (!defined $self->{max} or $num > $self->{max});

  my $delta = $num - $self->{mean};

  $self->{mean} += $delta / $self->{N};
  $self->{M2}   += $delta * ($num - $self->{mean});

  push( @{ $self->{data} }, $num ) if $self->{keep_data};

  return;
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

sub quartile {
    my ($self,$q,%opt) = @_;
    if ($q !~ /^[01234]$/) {
        die "Invalid quartile '$q'\n";
    }
    return $self->percentile($q / 4 * 100, %opt);
}

sub median {
    my ($self,%opt) = @_;
    return $self->percentile(50, %opt);
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

sub percentile {
    my ($self, $p, %opt) = @_;

    my $data = $self->{data};

    if (!$self->{keep_data} or scalar @{$data} == 0) {
        die "Can't get percentile from empty dataset\n";
    }

    if ($p < 0 or $p > 100) {
        die "Invalid percentile '$p'\n";
    }

    if (!$self->{_is_sorted_}) {
        $data = [ sort {$a <=> $b} @{ $data } ];
        $self->{data} = $data;
        $self->{_is_sorted_} = 1;
    }

    my $N = $self->N();
    my $idx = ($N - 1) * $p / 100;

    my $percentile =
        int($idx) == $idx ? $data->[$idx]
                          : ($data->[$idx] + $data->[$idx+1]) / 2;

    return $opt{formatted} ? _format($percentile)
                           : $percentile;
}

sub result {
    my $self = shift;

    my %result = (
        N          => $self->N(),
        sum        => $self->sum(),
        mean       => $self->mean(),
        stddev     => $self->stddev(),
        stderr     => $self->stderr(),
        min        => $self->min(),
        max        => $self->max(),
        variance   => $self->variance(),
    );

    if ($self->{keep_data}) {
        %result = (%result,
            (
                q1      => $self->quartile(1),
                median  => $self->median(),
                q3      => $self->quartile(3),
            )
        );
    }

    if (exists $self->{percentile}) {
        %result = (
            %result,
            percentile => $self->percentile($self->{percentile}),
        );
    }

    if (exists $self->{quartile}) {
        %result = (
            %result,
            quartile => $self->quartile($self->{quartile}),
        );
    }

    return %result;
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

=head2 new(%options)

=head2 validate($num)

=head2 process($num)

=head2 N

=head2 sum

=head2 mean

=head2 stddev

=head2 stderr

=head2 percentile=<0..100>

=head2 quartile=<0..4>

=head2 min

=head2 q1

=head2 median

=head2 q3

=head2 max

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
