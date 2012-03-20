use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'FTN-Database',
    AUTHOR              => 'Robert James Clay <jame@rocasa.us>',
    VERSION_FROM        => 'lib/FTNDB.pm',
    ABSTRACT_FROM       => 'lib/FTNDB.pm',
    LICENSE        	=> 'perl',
    EXE_FILES           => [ qw( bin/ftndbadm bin/ftndb-admin bin/ftndb-nodelist ) ],
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More'            => 0,
        'Test::Pod'             => 1.22,
        'Test::Pod::Coverage'   => 1.08,
        'App::Cmd'              => 0,
        'Config::Tiny'          => 0,
        'DBI'                   => 0,
        'DBD::SQLite'           => 0,
        'Getopt::Std'           => 0,
        'File::Spec'            => 0,
        'FTN::Log'              => 0.02,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'FTN-Database-*' },
);
