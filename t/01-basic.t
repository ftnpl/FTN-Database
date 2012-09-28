#!/usr/bin/perl -T
#
# Test basic operations of FTN::Database

use Test::More tests => 2;
use FTN::Database;

use strict;
use warnings;

my $db_handle;

BEGIN {

    my %db_options = (
        Type => 'SQLite',
        Name => 't/TEST.DB',
    );

    $db_handle = FTN::Database::open_ftn_database(\%db_options);
    ok( defined $db_handle, 'Create DB' );

    ok( FTN::Database::close_ftn_database($db_handle), 'Close DB' );
}

done_testing();

diag( "Basic FTN Database processing testing using FTN::Database $FTN::Database::VERSION." );

