#!/usr/bin/perl -w
# nltable.pl - 19 August 2001 - R.J. Clay
# Createing a nodelist table for use with information  
# from a Fidonet/FTN St. Louis Format Nodelist
# in an SQL (Mysql) based database.

use strict;
use Getopt::Std;
use vars qw/ $opt_n $opt_h /;

my ($tblname, $dbh, $sql_stmt);
 
#print @INC"\n";

getopts('n:h');

if($opt_h) {
    print "\nUsage: nltable.pl [-n nodelisttablename]...\n";
    print "nodelisttablename = defaults to \'nodelist\'. \n\n";
    exit;
}

if ($opt_n) {
    $tblname=$opt_n;   # ? test for a period in table name (mysql doesn't allow)
} else {
    $tblname="nodelist";
}

# connect to database
#   Assumes that $dbname, $dbuser, & $dbpass
# have been set.  $dbuser must already 
# have the priveledges to create a table.

my $dbname = 'ftndbtst';
my $dbuser = 'sysop';
my $dbpass = 'ftntstpw';
 
use DBI;

( $dbh = DBI->connect("dbi:mysql:dbname=$dbname", $dbuser, $dbpass) )
    or  die $DBI::errstr;

# drop the old nodelist table, if it exists.
$sql_stmt = "DROP TABLE nodelist";

#print " $sql_stmt ";
$dbh->do( "$sql_stmt " );

# build Create Table sql statement
$sql_stmt = "CREATE TABLE nodelist( ";

$sql_stmt .= "id                            INT NOT NULL AUTO_INCREMENT PRIMARY KEY, ";
$sql_stmt .= "type                          VARCHAR(6) DEFAULT '' NOT NULL, ";
$sql_stmt .= "zone                          SMALLINT  DEFAULT '1' NOT NULL, ";
$sql_stmt .= "net                           SMALLINT  DEFAULT '1' NOT NULL, ";
$sql_stmt .= "node                          SMALLINT  DEFAULT '1' NOT NULL, ";
$sql_stmt .= "point                         SMALLINT  DEFAULT '0' NOT NULL, ";
$sql_stmt .= "region                        SMALLINT  DEFAULT '0' NOT NULL, ";
$sql_stmt .= "name                          VARCHAR(32) DEFAULT '' NOT NULL, ";
$sql_stmt .= "location                      VARCHAR(32) DEFAULT '' NOT NULL, ";
$sql_stmt .= "sysop                         VARCHAR(32) DEFAULT '' NOT NULL, ";   
$sql_stmt .= "phone                         VARCHAR(20) DEFAULT '000-000-000-000' NOT NULL, ";
$sql_stmt .= "baud                          CHAR(6) DEFAULT '300' NOT NULL, ";
$sql_stmt .= "flags                         VARCHAR(32) DEFAULT ' ' NOT NULL, ";
$sql_stmt .= "domain                        VARCHAR(8) DEFAULT 'fidonet' NOT NULL, ";
$sql_stmt .= "INDEX ftnnode (zone, net, node, point, domain) ";
$sql_stmt .= ") ";

#print " $sql_stmt ";
$dbh->do( "$sql_stmt " );

# disconnect from database

( $dbh->disconnect )
	or  die $DBI::errstr;

exit();
