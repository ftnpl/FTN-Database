#!/usr/bin/perl
# nldbadm.pl 
# Createing a nodelist table for use with information
# from a Fidonet/FTN St. Louis Format Nodelist
# in to an SQL (sqlite) based database.
# Copyright (c) 2001-2010 Robert James Clay.  All Rights Reserved.
# This is free software;  you can redistribute it and/or
# modify it under the same terms as Perl itself.

use warnings;
use strict;
use Getopt::Std;
use vars qw/ $opt_n $opt_h $opt_v $opt_x /;

use FTN::Log qw(&logging);

our $VERSION = 1.2;

my ( $tblname, $dbh, $sql_stmt );

my $Logfile = "stdout";

#print @INC"\n";

getopts('n:hvx');

if ($opt_h) {
    print "\nUsage: nldbadm.pl [-n nodelisttablename] [-v] [-h]...\n";
    print "-n                nodelisttablename = defaults to \'nodelist\'. \n";
    print "-v                verbose option \n\n";
    exit;
}

# note that "opt_x" is the debug variable
if ($opt_x) {
    &logged("Debug flag is set");
}

# note that "opt_v" is the verbose variable
if ($opt_v) {
    &logged("Verbose flag is set");
}

#  nodelist table name
if ($opt_n) {
    if ( $opt_n =~ /\./ ) {    # period in proposed table name?
        &logged("sqlite does not allow periods in table names.");
        $opt_n =~ tr/\./_/;    # change period to underscore
        $tblname = $opt_n;     #
        &logged("Changed table name to $tblname.");
    }
    else {                     # no period in name
        $tblname = $opt_n;     #  just assign to variable
    }

}
else {
    $tblname = "Nodelist";     # default table name
}

# connect to database
&openftndb();

# drop the old nodelist table, if it exists.
$sql_stmt = "DROP TABLE IF EXISTS $tblname";
#print " $sql_stmt ";
$dbh->do("$sql_stmt ");
&logged("Dropping existing nodelist table $tblname if it already exists.");

# build Create Table sql statement
$sql_stmt = "CREATE TABLE $tblname( ";

$sql_stmt .= "id	INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, ";
$sql_stmt .= "type      VARCHAR(6) DEFAULT '' NOT NULL, ";
$sql_stmt .= "zone      SMALLINT  DEFAULT '1' NOT NULL, ";
$sql_stmt .= "net       SMALLINT  DEFAULT '1' NOT NULL, ";
$sql_stmt .= "node      SMALLINT  DEFAULT '1' NOT NULL, ";
$sql_stmt .= "point     SMALLINT  DEFAULT '0' NOT NULL, ";
$sql_stmt .= "region    SMALLINT  DEFAULT '0' NOT NULL, ";
$sql_stmt .= "name      VARCHAR(32) DEFAULT '' NOT NULL, ";
$sql_stmt .= "location  VARCHAR(32) DEFAULT '' NOT NULL, ";
$sql_stmt .= "sysop     VARCHAR(32) DEFAULT '' NOT NULL, ";
$sql_stmt .= "phone     VARCHAR(20) DEFAULT '000-000-000-000' NOT NULL, ";
$sql_stmt .= "baud      CHAR(6) DEFAULT '300' NOT NULL, ";
$sql_stmt .= "flags     VARCHAR(64) DEFAULT ' ' NOT NULL, ";
$sql_stmt .= "domain    VARCHAR(8) DEFAULT 'fidonet' NOT NULL, ";
$sql_stmt .= "source    VARCHAR(16) DEFAULT 'local' NOT NULL, ";
$sql_stmt .= "updated   TIMESTAMP(14) DEFAULT '' NOT NULL ";
$sql_stmt .= ") ";

#print " $sql_stmt ";
$dbh->do("$sql_stmt ");

# Index created
&createindex();

# disconnect from database
&closeftndb();

&logged("Table $tblname created.");

exit();

##############################################
## Create index on the nodelist table $tblname
##############################################
sub createindex {
#	Assumes the database is already open
#
    # Recreate ftnnode Index
    $sql_stmt = "CREATE INDEX ftnnode ";
    $sql_stmt .= "ON $tblname (zone,net,node,point,domain) ";
    ##print " $sql_stmt ";
    #	Execute the Create Index SQL statment
    $dbh->do( "$sql_stmt " )
        or die &logged($DBI::errstr);

}

############################################
# open FTN sqlite database for operations
############################################
sub openftndb {

    # Open message database
    #   Assumes that $dbname, $dbuser, & $dbpass
    # have been set.  $dbuser must already
    # have the priveledges to create a table.

    if ($opt_v) { &logged("Opening FTN database") }

    my $dbname = 'ftndbtst';
    my $dbuser = 'sysop';
    my $dbpass = 'ftntstpw';

    use DBI;

    ( $dbh = DBI->connect( "dbi:SQLite:dbname=$dbname", $dbuser, $dbpass ) )
      or die &logged($DBI::errstr);

}

############################################
# Close FTN
############################################
sub closeftndb {

    #
    if ($opt_v) { &logged("Closing FTN database") }

    ( $dbh->disconnect )
      or die &logged($DBI::errstr);

}

#############################################
#  logged subroutine.  requires FTN::Log
#############################################
sub logged {

    #
    my (@text) = @_;
    my $progid = "NLTBL";

    &logging( $Logfile, $progid, @text );

}
