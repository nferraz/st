use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'App::St',
    AUTHOR              => q{Nelson Ferraz <nferraz@gmail.com>},
    VERSION_FROM        => 'lib/App/St.pm',
    ABSTRACT_FROM       => 'lib/App/St.pm',
    LICENSE             => 'MIT',
    EXE_FILES           => [ 'script/st', ],
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
