#!/usr/bin/perl
#
# nl2sql.pl - v1.2
# Initial load of a particular FTN St. Louis Format Nodelist
# into an SQL (sqlite) based database.   
# Copyright (c) 2001-2010 Robert James Clay.  All Rights Reserved.
# This is free software;  you can redistribute it and/or
# modify it under the same terms as Perl itself.

use warnings;
use strict;
use Getopt::Std;
use vars qw/ $opt_n $opt_f $opt_e $opt_l $opt_d $opt_h $opt_t $opt_v $opt_x /;

use FTN::Utility qw(&logging);

getopts('n:f:l:d:t:ehvx');

if ($opt_h) {
    &help ();	#printing usage/help message
    exit 0;
}

my ($nldir, $nlfile, $dbh, $sql_stmt, $domain, $type, $num, $name, $loc, 
    $nametmp, $loctmp, $Logfile, $sysop, $phone, $bps, $flags, $tblname );
 
if ($opt_l) {
    $Logfile=$opt_l;  # this needs to be the filename & path
    undef $opt_l;
} else {
    $Logfile="nodelist.log";	# default log file is in current dir
}

&log("Starting... ");

# note that "opt_v" is the verbose variable
if ($opt_v) {
    &log("Verbose flag is set");
}

# note that "opt_x" is the debug variable
if ($opt_x) {
    &log("Debug flag is set");
}

#  setup nodelist file variables
if ($opt_n) {

    $nldir = $opt_n;   # set nodelist directory variable
    
    if ($opt_f) {
        if ($opt_e) { # if set, then -f option must be exact file name
	    &log("Using exact file name &opt_f.");
	    $nlfile=$opt_f;
	} else { # if not set, then -f option is basename of nodelist file
	    $nlfile=&getnlfilename($opt_f);
	}

    } else { # if not set, 
        #  filename defaults to basename nodelist
        $nlfile=&getnlfilename("nodelist");
    }

} else {
    print "\nThe Nodelist directory variable must be set... \n";
    &help();
    exit (1);	#  exit after displaying usage if not set
}


&log("Nodelist directory: '$nldir'");
&log("Nodelist file: '$nlfile'");

if ($opt_x) {
    print "Nodelist file is '$nldir.$nlfile' ..\n";
}

#  nodelist table name
if ($opt_t) {
    if ($opt_t=~/\./) {   # period in proposed table name? 
	&log("sqlite does not allow periods in table names.");
	$opt_t =~ tr/\./_/;  # change period to underscore
	$tblname = $opt_t;  # 
	&log("Changed table name to $tblname.");
    } else {	# no period in name 
        $tblname = $opt_t;  #  just assign to variable
    }

} else {
    $tblname="Nodelist";   # default table name  
}



open (NODELIST, "$nldir/$nlfile")
    or die &log("Cannot open $nldir/$nlfile");

#  set up domain variable
if ($opt_d) {
    $domain=$opt_d;
} else {
    $domain='fidonet';    # domain defaults to fidonet
}
if ($opt_v) {	# log domain name
    &log("Domain: '$domain'");
}
if ($opt_x) {
    &log("Debug mode is set");
}

#  set defaults
my $zone = 1;
my $net  = 0;
my $node = 0;
my $point = 0;
my $region = 0;


# connect to database
&openftndb();

#
if ($opt_v) {	
    &log("Deleteing old entries for '$domain'");
}

#   remove any and all entries where domain = $domain
$sql_stmt = "DELETE FROM $tblname ";
$sql_stmt .= "WHERE domain = '$domain' ";

if ($opt_x) {
    print "The delete statment is:  $sql_stmt ";
}

#	Execute the Delete SQL statement
$dbh->do( "$sql_stmt " )
	or die &log($DBI::errstr);

if ($opt_v) {	
    &log("Loading database from nodelist $nlfile");
}

while(<NODELIST>) {
    if ( /^;/ || /^\cZ/ ) {
#	print;
	next;
    }

    ($type,$num,$name,$loc,$sysop,$phone,$bps,$flags) = split(',', $_, 8);

# originally took care of these by deleteing them
    $name =~ tr/\'//d;   #  take care of single quotes in system name fields
    
    $loc =~ tr/\'//d;   #  take care of single quotes in location fields
    
    $sysop =~ tr/\'//d;   # take care of single quotes in sysop name fields
    

# now trying to escape them,  does not work   6/19/02

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
    $sql_stmt = "INSERT INTO $tblname ";

    $sql_stmt .= "(type,zone,net,node,point,region,name,";
    $sql_stmt .= "location,sysop,phone,baud,flags,domain,source) ";
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
    $sql_stmt .= "'$domain', ";
    $sql_stmt .= "'$nlfile') ";

#  this will be a debug option, but after start using more
# complex parameter passing
#    if ($opt_x) {
#        print " $sql_stmt ";
#    }

#	Execute the insert SQL statment
    $dbh->do( "$sql_stmt " )
	or die &log($DBI::errstr);

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

if ($opt_v) {	# 
    &log("Closing database");
}
# disconnect from database
&closeftndb();

close NODELIST;

&log("Ending... ");

exit();

############################################
# subroutines
############################################

# Help message
############################################
sub help {
    print "\nUsage: nl2sql.pl -n nldir [-f nlfile] [-l logfile] [-d domain] [-e] [-v] [-x]...\n";
    print "    nldir = nodelist directory...\n";
    print "    nlfile= nodelist filename, defaults to 'nodelist'.\n";
    print "    [-d domain] = nodelist domain;  defaults to 'fidonet'.\n\n";
    print "    [-l logfile] = log filename (defaults to nodelist.log in current dir)\n";
    print "   -e	If present, then nlfile is exact filename\n";
    print "   -v	Verbose Mode\n";
    print "   -x	Debug Mode\n";
}

################################################
# get nodelist filename, given path & base name
################################################
sub getnlfilename {
# Find the most recent version (by day number) when given a base name & dir
# of the nodelist;  once this is implemented, this will be the default. 
# Note that if there is more than one file with the same base name, it will
# use the first one found.

    my ($i, @files);

    my($basename) = @_;

    if ($opt_v) {&log("Searching for $basename files.")};

    opendir(DIR, $nldir);
	@files = grep(/$basename\.[0-9][0-9][0-9]$/i, readdir(DIR));
    closedir(DIR);

    if ($#files == -1) {
	&log("Nodelist files $basename not found");
	print ("\nNodelist files $basename not found.\n");
	&help;	
	exit();
    } else {
        if ($opt_v) {
	    for ($i=0; $i<@files; $i++) {
		&log("Nodelist file $i found: $files[$i]");
	    }
        }
    }

    if ($#files > 1) {
	&log("More than one '$basename' found, using first.");
    }
    
    return ($files[0]);   # return filename

}

############################################
# open FTN sqlite database for operations
############################################
sub openftndb {
# Open message database
#   Assumes that $dbname, $dbuser, & $dbpass
# have been set.  $dbuser must already 
# have the priveledges to create a table.
# See also ftndbtst.pl.

    if ($opt_v) {&log("Opening FTN database")};
	
    my $dbname = 'ftndbtst';
    my $dbuser = 'sysop';
    my $dbpass = 'ftntstpw';
 
    use DBI;

    ( $dbh = DBI->connect("dbi:SQLite:dbname=$dbname", $dbuser, $dbpass) )
	or die &log($DBI::errstr);

}

############################################
# Close FTN 
############################################
sub closeftndb {
#
    if ($opt_v) {&log("Closing FTN database")};

    ( $dbh->disconnect )
	or die &log($DBI::errstr);
	
}

#############################################
#  log subrouting.  requires FTN::Utility
#############################################
sub log {
#
    my(@text) = @_;
    my $progid="nl2sql";

    &logging($Logfile, $progid, @text);

}
