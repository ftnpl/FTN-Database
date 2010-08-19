use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'nl2sql',
    AUTHOR              => 'Robert James Clay <jame@rocasa.us>',
    VERSION        	=> '1.3',
    ABSTRACT       	=> 'Perl scripts for using an SQL database for Fidonet/FTN Nodelist processing',
    LICENSE        	=> 'perl',
    EXE_FILES           => [ qw( bin/net2file.pl bin/nl2db.pl bin/nldbadm.pl ) ],
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
