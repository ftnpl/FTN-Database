#!perl -T

use Test::More tests => 2;

BEGIN {
	use_ok( 'FTN::NL' );
	use_ok( 'FTN::NL::Database' );
}

diag( "Testing FTN::NL $FTN::NL::Database::VERSION, Perl $], $^X" );
