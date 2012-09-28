use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'FTN-Database',
    AUTHOR              => 'Robert James Clay <jame@rocasa.us>',
    VERSION_FROM        => 'lib/FTN/Database.pm',
    ABSTRACT_FROM       => 'lib/FTN/Database.pm',
    LICENSE        	=> 'perl',
    PL_FILES            => {},
    PREREQ_PM => {
        'DBI'                   => 0,
        'DBD::SQLite'           => 0,
    },
    BUILD_REQUIRES => {
        'Test::Database'        => 0,
        'Test::More'            => 0,
        'Test::Pod'             => 1.22,
        'Test::Pod::Coverage'   => 1.08,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'FTN-Database-* t/*.DB' },
);
