#!/usr/bin/perl -w
#
# nl2sqlv1.pl 
# version 1.0 Beta- 5 August 2001 - R.J. Clay
# Initial load of a particular FTN St. Louis Format Nodelist
# into an SQL (Mysql) based database.   Uses standard Perl.
# See README for license information.

use strict;
use Getopt::Std;
use vars qw/ $opt_n $opt_d $opt_h $opt_x /;

#print @INC"\n";

getopts('n:d:hx');

if ($opt_h) or ($#ARGV < 0) {
    print STDERR "usage: nl2sqlv1.pl -n nodelistfile -d [domain]...\n";
    print STDERR "nodelistfile = path and filename of nodelist file...\n";
    print STDERR "[domain] = nodelist domain;  defaults to fidonet.\n";
    exit 1;
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
    $nodelistfile='nodelist.tst';
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
#    $domain = 'stn';
}
if ($opt_x) {
    print "Domain is '$domain' ..\n";
}

#set defaults
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
$dbh->do( "$sql_stmt " )
    or $insert_ok = "0"; 


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
## now trying to escape them :  doesn't work 5/30
#    $nametmp = $dbh->quote($name);  $name = $nametmp;
#    $loctmp = $dbh->quote($loc);  $loc = $loctmp;

if (!defined $flags) {
# if $flags is undefined (i.e., nothing after the baud rate)
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

if ($opt_x) {
# display where in the nodelist we are
    print "$type,";
    printf "%-16s", "$zone:$net/$node";
    print "$sysop\n";
}
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

#    if ($opt_x) {
#        print " $sql_stmt ";
#    }
    $dbh->do( "$sql_stmt " )
        or $insert_ok = "0"; 

}

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
