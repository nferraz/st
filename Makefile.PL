use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'st',
    AUTHOR              => q{Nelson Ferraz <nferraz@gmail.com>},
    LICENSE             => 'MIT',
    EXE_FILES           => [ 'script/st', ],
    PL_FILES            => { },
    PREREQ_PM           => { },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
);
