#!/usr/bin/perl
# nldbadm.pl - v1.2
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

my ($tblname, $dbh, $sql_stmt);

my $Logfile = "stdout";
 
#print @INC"\n";

getopts('n:hvx');

if($opt_h) {
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
    if ($opt_n=~/\./) {   # period in proposed table name? 
	&logged("sqlite does not allow periods in table names.");
	$opt_n =~ tr/\./_/;  # change period to underscore
	$tblname = $opt_n;  # 
	&logged("Changed table name to $tblname.");
    } else {	# no period in name 
        $tblname = $opt_n;   #  just assign to variable
    }

} else {
    $tblname="Nodelist";   # default table name  
}


# connect to database
&openftndb();
 
# drop the old nodelist table, if it exists.
if (&TableExists($tblname)) {
    $sql_stmt = "DROP TABLE $tblname";
    #print " $sql_stmt ";
    $dbh->do( "$sql_stmt " );
    &logged("Dropped existing nodelist table $tblname.");
} else {
    &logged("Table $tblname does not already exist");
}


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
$dbh->do( "$sql_stmt " );

# disconnect from database
&closeftndb();

&logged("Table $tblname created.");


exit();



############################################
# TableExists function 
############################################
sub TableExists {
# check if table $tname is already in the database
    my ($i, $rc, $rv, $sth, $sql, @row, $result);
    
    my($tname) = @_;

    if ($opt_v) {&logged("Checking if table '$tblname' already exists")};
    
    # prepare statment
    $sql= "SHOW TABLES";
    $sth = $dbh->prepare($sql)
	or die {&logged("Can't prepare $sql:  $dbh->errstr")};
	
    # execute statement
    $rv = $sth->execute
	or die {&logged("Can't execute '$sql':  $sth->errstr.")};
    
    # getting list of table names in database &
    # checking if $tname already in database
    $result = 0;  # false
    while(@row = $sth->fetchrow_array)  {  
    
	if ($opt_x) {&logged("Table $row[0] exists.")};    

	if ($row[0] eq $tname) {
	    $result = 1;  # true
	    if ($opt_v) {&logged("Table $tname found.")};
#	    last FINISHED;   # break out of loop if found;  doesn't work...
	}	
    }
    FINISHED: 
    
    #  finished with statement handle
    $rc = $sth->finish;
    
    if ($opt_x) {&logged("TableExists return value is '$result'.")};
    
    return($result);  #  return result

}
#############################################
## Create index on the nodelist table
#############################################
#sub createindex {
## Creating the index with the old mysql
## version was done as part of the creation
## of the table itself, using the following
## info:
##  $sql_stmt .= "INDEX ftnnode (zone, net, node, point, domain) ";
## Will now do it as part of a separate subroutine
## which will also allow it to be used as part
## of being able to drop & recreate the index
## if requested.

#}

############################################
# open FTN sqlite database for operations
############################################
sub openftndb {
# Open message database
#   Assumes that $dbname, $dbuser, & $dbpass
# have been set.  $dbuser must already 
# have the priveledges to create a table.

    if ($opt_v) {&logged("Opening FTN database")};
	
    my $dbname = 'ftndbtst';
    my $dbuser = 'sysop';
    my $dbpass = 'ftntstpw';
 
    use DBI;

    ( $dbh = DBI->connect("dbi:SQLite:dbname=$dbname", $dbuser, $dbpass) )
	or die &logged($DBI::errstr);

}

############################################
# Close FTN 
############################################
sub closeftndb {
#
    if ($opt_v) {&logged("Closing FTN database")};

    ( $dbh->disconnect )
	or die &logged($DBI::errstr);
	
}

#############################################
#  logged subroutine.  requires FTN::Log
#############################################
sub logged {
#
    my(@text) = @_;
    my $progid="NLTBL";

    &logging($Logfile, $progid, @text);

}
