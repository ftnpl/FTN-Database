use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'nl2sql',
    AUTHOR              => 'Robert James Clay <jame@rocasa.us>',
    VERSION        	=> '1.3',
    ABSTRACT       	=> 'Perl scripts for using an SQL database for Fidonet/FTN Nodelist processing',
    PL_FILES            => {},
    PREREQ_PM => {
        'Getopt::Std'   	=> 0,
        'DBI'   		=> 0,
        'DBD::SQLite'   	=> 0,
        'FTN::Log'   		=> 0.02,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'nl2sql-*' },
);
