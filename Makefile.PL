use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

use Getopt::Long;
use File::Copy;

my %opt;
GetOptions(
  \%opt,
  'rename|script-name=s',
  'standalone=s'
);

my $DEFAULT_SCRIPT_NAME = "st";

my $script_name = $DEFAULT_SCRIPT_NAME;
my $standalone;

# rename script if necessary
if ($opt{rename} and $opt{rename} =~ /^([\w\-]+)$/) {
  my $new_script_name = $1;

  open my $in,  '<', "script/$DEFAULT_SCRIPT_NAME" or die "Can't read 'script/$DEFAULT_SCRIPT_NAME': $!";
  open my $out, '>', "script/$new_script_name"     or die "Can't write to 'script/$new_script_name': $!";

  my $found_pod;
  while (my $line = <$in>) {
    if ($line eq "__END__\n" or $found_pod) { # only after __END__
      if ($line !~ m{http.+/$DEFAULT_SCRIPT_NAME}) { # only if not in url
        $line =~ s/\b$DEFAULT_SCRIPT_NAME\b/$new_script_name/g;
      }
      $found_pod = 1;
    }
    print $out $line;
  }

  close $out;
  close $in;

  $script_name = $new_script_name;
} elsif ($opt{standalone} and $opt{standalone} =~ /^([\w\-]+)$/) {
  $standalone = $1;
  open my $out, '>', "script/$standalone" or die "Can't write to 'script/$standalone': $!";
  local @ARGV = ('script/' . $DEFAULT_SCRIPT_NAME, 'lib/App/St.pm');
  while (<>) {
    if (/^(?:use\sApp::St;|__END__)$/) {
      $_ = "#$_";
    } elsif (/^package\sApp::St;$/) {
      $_ = "\n=cut\n\n$_";
    } elsif (/^1;$/) {
      last;
    }
    print $out $_;
  }
}

WriteMakefile(
    NAME                => 'App::St',
    AUTHOR              => q{Nelson Ferraz <nferraz@gmail.com>},
    VERSION_FROM        => 'lib/App/St.pm',
    ABSTRACT_FROM       => 'lib/App/St.pm',
    LICENSE             => 'MIT',
    EXE_FILES           => [ "script/$script_name", $standalone ? "script/$standalone" : () ],
    PL_FILES            => { },
    MIN_PERL_VERSION    => 5.006,
    CONFIGURE_REQUIRES  => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
    },
    PREREQ_PM => { },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'App-*' },
);
