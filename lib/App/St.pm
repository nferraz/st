package App::St;

use strict;
use warnings;

#use bignum;

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
    calculated => [],
    data       => [],
  }, $class;
}

sub validate {
  my ($self, $num) = @_;

  return ($num =~ m{^
    [+-]?
    (?: \. ? [0-9]+
      | [0-9]+ \. [0-9]*
      | [0-9]* \. ? [0-9]+ [Ee] [+-]? [0-9]+
    )
  $}x);
}

sub process {
  my ($self, @values) = @_;
  for (my $i = 0; $i < @values; $i++) {
      my $num = $values[$i];
      $self->{calculated}[$i] ||= {};
      my $calculated = $self->{calculated}[$i];

      die "Invalid input '$num'\n" if !$self->validate($num);

      $calculated->{N}++;

      $calculated->{sum} += $num;
      $calculated->{sumsq} += $num * $num;

      $calculated->{min} = $num if (!defined $calculated->{min} or $num < $calculated->{min});
      $calculated->{max} = $num if (!defined $calculated->{max} or $num > $calculated->{max});

      #my $delta = $num - $calculated->{mean};

      #$calculated->{mean} += $delta / $calculated->{N};
      #$calculated->{M2} += $delta * ($num - $calculated->{mean});

      push(@{$calculated->{data}}, $num) if $self->{keep_data};
  }
  return;
}

sub N {
  my $self = shift;
  return map { ($_->{N})} @{$self->{calculated}};
}

sub sum {
  my $self = shift;
  return map { ($_->{sum})} @{$self->{calculated}};
}

sub min {
  my $self = shift;
  return map { ($_->{min})} @{$self->{calculated}};
}

sub max {
  my $self = shift;
  return map { ($_->{max})} @{$self->{calculated}};
}

sub mean {
  my ($self,%opt) = @_;

  return map {
      my $mean = $_->{sum} / $_->{N};

      return $opt{formatted} ? $self->_format($mean)
          : $mean;
  } @{$self->{calculated}};
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

    my @variances = map {
        my $N = $_->{N};
        my $sumsq = $_->{sumsq};
        my $sqsum = $_->{sum} * $_->{sum};
        my $variance = $N > 2 ? ($sumsq - $sqsum / $N) / ($N - 1): undef;
        ($opt{formatted} ? $self->_format($variance)
            : $variance);
    } @{$self->{calculated}};

}

sub stddev {
  my ($self,%opt) = @_;

  my @variances = $self->variance();

  return map {
      my $variance = $_;
      my $stddev = defined $variance ? sqrt($variance) : undef;
      $opt{formatted} ? $self->_format($stddev)
          : $stddev;
  } @variances;
}

sub stderr {
  my ($self,%opt) = shift;

  my @stddev = $self->stddev();
  my @N      = $self->N();

  my @stderr;
  for (my $i = 0; $i < max(@stddev, @N); $i++) {
      my $stderr = defined $stddev[$i] ? $stddev[$i]/sqrt($N[$i]) : undef;
      push @stderr, $opt{formatted} ? $self->_format($stderr)
          : $stderr;
  }
    return @stderr;
}

sub percentile {
    my ($self, $p, %opt) = @_;

    if (!$self->{keep_data}) {
        die "Can't get percentile from empty dataset\n";
    }

    if ($p < 0 or $p > 100) {
        die "Invalid percentile '$p'\n";
    }

    map {
      my $data = $_->{data};

      if (!$_->{_is_sorted_}) {
          $data = [ sort {$a <=> $b} @{$data} ];
          $_->{data} = $data;
          $_->{_is_sorted_} = 1;
          my $N = $_->{N};
          my $idx = ($N - 1) * $p / 100;
          my $percentile =
              int($idx) == $idx ? $data->[$idx]
                  : ($data->[$idx] + $data->[$idx + 1]) / 2;

          ($opt{formatted} ? _format($percentile)
              : $percentile);
      }
    } @{$self->{calculated}};
}

sub result {
    my $self = shift;

    my @result = map {
        my %result = (
            N        => $_->{N},
            sum      => $_->{sum},
            mean     => $_->{N} ? $_->{sum} / $_->{N} : undef,
            stderr   => $_->{stderr},
            min      => $_->{min},
            max      => $_->{max},
            variance => $_->{variance},
        );

        if ($self->{keep_data}) {
            %result = (%result,
                (
                    q1     => $_->quartile(1),
                    median => $_->median(),
                    q3     => $_->quartile(3),
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
        (\%result);
    } @{$self->{calculated}};

    my @stddev = $self->stddev();

    for (my $i = 0; $i < @result; $i++) {
        $result[$i]{stddev} = $stddev[$i];
    }

    @result;
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
