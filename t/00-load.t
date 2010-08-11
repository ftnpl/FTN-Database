#!perl -T

use Test::More tests => 2;

BEGIN {
	use_ok( 'FTN::NL' );
	use_ok( 'FTN::NL::DB' );
}

diag( "Testing FTN::NL $FTN::NL::VERSION, Perl $], $^X" );
