#!/usr/bin/perl -w
#
# nl2sql.pl 
# version 1.0 - 25 August 2001 - R.J. Clay
# Initial load of a particular FTN St. Louis Format Nodelist
# into an SQL (Mysql) based database.   Uses standard Perl.
# See README for license information.

use strict;
use Getopt::Std;
use vars qw/ $opt_n $opt_d $opt_h $opt_x /;

#print @INC"\n";

getopts('n:d:hx');

if ($opt_h) {
    &help ();	#printing usage/help message
    exit 0;
}

my ($nodelistfile, $dbh, $sql_stmt, $domain, $type, $num, $name, $loc, 
    $sysop, $phone, $bps, $flags );
 
# note that "opt_x" is the debug variable
if ($opt_x) {
    print "Debug flag is set ...\n";
}

#  setup nodelist file variable
if ($opt_n) {
    $nodelistfile=$opt_n;
} else {
    print "\nThe Nodelist file and it's path must be set... \n";
    &help();
    exit (1);	#  exit after displaying usage if not set
}
if ($opt_x) {
    print "Nodelist file is '$nodelistfile' ..\n";
}

open (NODELIST, $nodelistfile)
    or die ("Cannot open nodelist file:  $nodelistfile");

#  set up domain variable
if ($opt_d) {
    $domain=$opt_d;
} else {
    $domain='fidonet';    # domain defaults to fidonet
}
if ($opt_x) {
    print "Domain is '$domain' ..\n";
}

#  set defaults
my $zone = 1;
my $net  = 0;
my $node = 0;
my $point = 0;
my $region = 0;


# connect to database
#   Assumes that $dbname, $dbuser, & $dbpass are set as follows
# in the database.  (see createftndbtst.pl)

my $dbname = 'ftndbtst';
my $dbuser = 'sysop';
my $dbpass = 'ftntstpw';
 
use DBI;

( $dbh = DBI->connect("dbi:mysql:dbname=$dbname", $dbuser, $dbpass) )
    or  die $DBI::errstr;

#   remove any and all entries where domain = $domain
$sql_stmt = "DELETE FROM nodelist ";
$sql_stmt .= "WHERE domain = '$domain' ";

if ($opt_x) {
    print "The delete statment is:  $sql_stmt ";
}

#	Execute the Delete SQL statement
$dbh->do( "$sql_stmt " );


while(<NODELIST>) {
    if ( /^;/ || /^\cZ/ ) {
#	print;
	next;
    }

    ($type,$num,$name,$loc,$sysop,$phone,$bps,$flags) = split(',', $_, 8);

# originally took care of these by deleteing them
    $name =~ tr/'//d;   #take care of single quotes in system name fields
    $loc =~ tr/'//d;   #take care of single quotes in location fields
    $sysop =~ tr/'//d;   #take care of single quotes in sysop name fields
## now trying to escape them :  doesn't work 5/30/01
#    $nametmp = $dbh->quote($name);  $name = $nametmp;
#    $loctmp = $dbh->quote($loc);  $loc = $loctmp;


# if $flags is undefined (i.e., nothing after the baud rate)
    if (!defined $flags) {
        $flags = " ";
    }

    if($type eq "Zone") {	# Zone line
	$zone = $num;
	$net  = $num;
	$node = 0;
    }				# 
    elsif($type eq "Region") {	# Region line
	$region  = $num;
 	$net  = $num;
	$node = 0;
    }
    elsif($type eq "Host") {	# Host line
	$net = $num;
	$node = 0;
    }
    else {
	$node = $num;
    }

# display where in the nodelist we are if debug flag is set
    if ($opt_x) {
        print "$type,";
        printf "%-16s", "$zone:$net/$node";
        print "$sysop\n";
    }

#	Build Insert Statement
    $sql_stmt = "INSERT INTO nodelist ";

    $sql_stmt .= "(type,zone,net,node,point,region,name,";
    $sql_stmt .= "location,sysop,phone,baud,flags,domain) ";

    $sql_stmt .= "VALUES (";

    $sql_stmt .= "'$type', ";
    $sql_stmt .= "'$zone', ";
    $sql_stmt .= "'$net', ";
    $sql_stmt .= "'$node', ";
    $sql_stmt .= "'$point', ";
    $sql_stmt .= "'$region', ";
    $sql_stmt .= "'$name', ";   
    $sql_stmt .= "'$loc', ";
    $sql_stmt .= "'$sysop', ";
    $sql_stmt .= "'$phone', ";
    $sql_stmt .= "'$bps', ";
    $sql_stmt .= "'$flags', ";
    $sql_stmt .= "'$domain') ";

#  this will be a debug option, but after start using more
# complex parameter passing
#    if ($opt_x) {
#        print " $sql_stmt ";
#    }

#	Execute the insert SQL statment
    $dbh->do( "$sql_stmt " );

}

# This will be for the recreate index separately option, yet to be developed
#
#   this is from the old syntax for the postgres db
## recreate index
#    $reidx_stmt = "CREATE UNIQUE INDEX nodelist_key ";
#    $reidx_stmt .= "ON nodelist (zone,net,node,point,domain) ";
#
##print " $reidx_stmt ";
#    $dbh->do( "$reidx_stmt " )
#        or $reidx_ok = "0"; 

# disconnect from database
( $dbh->disconnect )
	or  die $DBI::errstr;

close NODELIST;

exit();

############################################
# subroutines
############################################

# Help message
############################################
sub help {
    print "\nUsage: nl2sql.pl -n nodelistfile [-d domain]...\n";
    print "    nodelistfile = path and filename of nodelist file...\n";
    print "    [-d domain] = nodelist domain;  defaults to fidonet.\n\n";
}

