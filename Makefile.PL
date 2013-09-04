use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'st',
    AUTHOR              => q{Nelson Ferraz <nferraz@gmail.com>},
    ABSTRACT_FROM       => 'bin/st',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    EXE_FILES           => [ 'bin/st', ],
    PL_FILES            => { },
    PREREQ_PM           => { },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
);
