use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'FTN::NL::Database',
    AUTHOR              => 'Robert James Clay <jame@rocasa.us>',
    VERSION_FROM        => 'lib/FTN/NL.pm',
    ABSTRACT_FROM       => 'lib/FTN/NL.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'FTN-NL-Database-*' },
);
