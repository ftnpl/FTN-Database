#!/usr/bin/perl -w
# createftndbtst.pl - 5 August 2001 - R.J. Clay
# Create a test database:  ftndbtst   
# in an SQL (Mysql) based database.

use strict;

my ($dbh, $sql_stmt);
 
# connect to database
#   Assumes that $dbname, $dbuser, & $dbpass
# have been set.  $dbuser must already have the priveleges to create
# a database, & $dbpass must be a valid password for that user.

my $dbname = 'mysql';
my $dbuser = 'root';
#   set this to the mysql root password
my $dbpass = 'dbrootpw';
 
use DBI;

( $dbh = DBI->connect("dbi:mysql:dbname=$dbname", $dbuser, $dbpass) )
    or  die $DBI::errstr;

# drop the old test database, if it exists.
$sql_stmt = "DROP DATABASE ftndbtst";

#print " $sql_stmt ";
$dbh->do( "$sql_stmt " );
#    or $drop_ok = "0"; 

#   Create ftndbtst Database
# build Create Database sql statement
$sql_stmt = "CREATE DATABASE ftndbtst";

#print " $sql_stmt ";
$dbh->do( "$sql_stmt " );
#    or $create_ok = "0"; 

# build first Grant sql statement
$sql_stmt = "GRANT ALL PRIVILEGES ON ftndbtst.* TO sysop\@localhost ";
$sql_stmt .= " IDENTIFIED BY 'ftntstpw'";

#print " $sql_stmt ";
$dbh->do( "$sql_stmt " );
#    or $grant_ok = "0"; 

# build second Grant sql statement
$sql_stmt = "GRANT ALL PRIVILEGES ON ftndbtst.* TO sysop\@'%'";
$sql_stmt .= "IDENTIFIED BY 'ftntstpw'";

#print " $sql_stmt ";
$dbh->do( "$sql_stmt " );
#    or $grant_ok = "0"; 

# disconnect from database

( $dbh->disconnect )
	or  die $DBI::errstr;

exit();
