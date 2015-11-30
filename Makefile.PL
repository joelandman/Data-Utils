use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'SI::Utils',
    AUTHOR              => 'Joseph Landman <landman@scalableinformatics.com>',
    VERSION_FROM        => 'lib/SI/Utils.pm',
    ABSTRACT_FROM       => 'lib/SI/Utils.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'SI-Utils-*' },
);
