#!/bin/sh
# nl2sql.sh - 26 August 2001 - R.J. Clay
#  This is a test script to load a named nodelist 
NLDIR=/var/spool/ftn/nl.d
##./nl2sql.pl -n nodelist -d domain -x >nl2sql.out 2>nl2sql.stn.errors
./nl2sql.pl -n $NLDIR/STNLIST.236 -d stn 2>nl2sql.stn.errors
#
##./nl2sql.pl -n $NLDIR/nodelist.229 -d fidonet -x 2>nl2sql.ftn.errors
./nl2sql.pl -n $NLDIR/nodelist.236 -d fidonet 2>nl2sql.ftn.errors
