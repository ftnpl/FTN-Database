#!/usr/bin/perl
# net2file.pl 
# List a specific net from a specific zone of a nodelist table containing
# information from a Fidonet/FTN St. Louis Format Nodelist to a text file
#
# Copyright (c) 2010 Robert James Clay.  All Rights Reserved.
# This is free software;  you can redistribute it and/or
# modify it under the same terms as Perl itself.

use warnings;
use strict;
use Getopt::Std;
use vars qw/ $opt_n $opt_o $opt_t $opt_T $opt_D $opt_u $opt_p $opt_h $opt_v $opt_x $opt_z /;

our $VERSION = 0.1;

my ( $dbtype, $dbname, $dbuser, $dbpass, $tblname, $dbh, $sql_stmt, $ZoneNum, $NetNum, $ListFile );

#print @INC"\n";

getopts('n:o:t:T:D:u:p:hvxz:');

if ($opt_h) {
    print "\nUsage: listnet.pl [-t nodelisttablename] [-T dbtype] [-D dbname] [-u dbuser] [-p dbpass] [-z zone] [-n net] [-o outfile] [-v] [-h]...\n";
    print "-t                nodelisttablename = defaults to \'nodelist\'. \n";
    print "[-T dbtype]       database type;  defaults to 'SQLite'.\n\n";
    print "[-D dbname]       database name & path;  defaults to 'ftndbtst'.\n\n";
    print "[-u dbuser]       database user;  defaults to 'sysop'.\n\n";
    print "[-p dbpass]       database password;  defaults to 'ftntstpw'.\n\n";
    print "[-z zonenum]      ZoneNum number = defaults to 1. \n";
    print "[-n netnum]       Net number = defaults to 1. \n";
    print "[-o outfile]      Output file (plus path) = defaults to outfile.txt in current directory.\n";
    print "-v                Verbose option \n";
    print "-x                Debug option \n\n";
    exit;
}

# note that "opt_x" is the debug variable
if ($opt_x) {
    print "Debug flag is set\n";
}

# note that "opt_v" is the verbose variable
if ($opt_v) {
    print "Verbose flag is set\n";
}

#    Database type
#    This needs to be a database type for which a DBD module exists,
#    the type being the name as used in the DBD module.  The default
#    type is SQLite.
if ($opt_T) {
    $dbtype = $opt_T;
    undef $opt_T;
}
else {
    $dbtype = "SQLite";    # default database type is SQLite
    undef $opt_T;
}
if ($opt_v) { print "Database type being used is $dbtype.\n" };

#    Database name
if ($opt_D) {
    $dbname = $opt_D;    # this needs to be at least the filename & can also include a path
    undef $opt_D;
}
else {
    $dbname = "ftndbtst";    # default database file is in current dir
}
#    Database user
if ($opt_u) {
    $dbuser = $opt_u;    # Set database user
    undef $opt_u;
}
else {
    $dbuser = "sysop";    # default user is sysop
}
#    Database password
if ($opt_p) {
    $dbpass = $opt_p;    # Set database password
    undef $opt_p;
}
else {
    $dbpass = "ftntstpw";    # default database password
}

#  nodelist table name
if ($opt_t) {
    if ( $opt_t =~ /\./ ) {    # period in proposed table name?
        print "sqlite does not allow periods in table names.";
        $opt_t=~ tr/\./_/;    # change period to underscore
        $tblname = $opt_t;     #
        print "Changed table name to $tblname.";
    }
    else {                     # no period in name
        $tblname = $opt_t;     #  just assign to variable
    }

}
else {
    $tblname = "Nodelist";     # default table name
}

#    FTN Zone number
if ($opt_z) {
    $ZoneNum = $opt_z;    # Set zone number 
    undef $opt_z;
}
else {
    $ZoneNum = 1;    # default zone number
}

#    FTN Net number
if ($opt_n) {
    $NetNum = $opt_n;    # Set net number 
    undef $opt_n;
}
else {
    $NetNum = 1;    # default net number
}

#    Output file
if ($opt_o) {
    $ListFile = $opt_o;    # this needs to be at least the filename & can also include a path
    undef $opt_o;
}
else {
    $ListFile = "outfile.txt";    # default output file is in current dir
}


# connect to database
openftndb();

# build Select query sql statement
$sql_stmt = "SELECT * FROM $tblname WHERE zone = $ZoneNum and net = $NetNum ";
$sql_stmt .= "ORDER by node ASC";

# execute query
my $sth = $dbh->prepare($sql_stmt);
$sth->execute();

$sth->bind_columns(\my($id, $type, $zone, $net, $node, $point, $region, $name, $location, $sysop, $phone, $baud, $flags, $domain, $source, $updated));

local(*F);

open(F, ">$ListFile") or die "$Cannot open $ListFile\n"; 

print F "Listing Zone $ZoneNum Net $NetNum from FTN database:\n\n";

while($sth->fetch()) {
   print F "$zone:$net/$node, $name, $location, $sysop, $phone, $baud, $flags";
}

close(F);

# finish query
$sth->finish;
undef $sth;

# disconnect from database
closeftndb();

exit();


############################################
# open FTN sqlite database for operations
############################################
sub openftndb {

    # Open message database
    #   Assumes that $dbname, $dbuser, & $dbpass
    # have been set.  $dbuser must already
    # have the priveledges to create a table.

    if ($opt_v) { print "Opening FTN database\n" }

    use DBI;

    ( $dbh = DBI->connect( "dbi:$dbtype:dbname=$dbname", $dbuser, $dbpass ) )
      or die print "$DBI::errstr\n";

}

############################################
# Close FTN DB
############################################
sub closeftndb {

    #
    if ($opt_v) { print "Closing FTN database\n" }

    ( $dbh->disconnect )
      or die print "$DBI::errstr\n";

}