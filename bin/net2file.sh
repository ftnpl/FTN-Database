#!/bin/sh
# net2file.sh 1.2 
# List a specific net from a specific zone of a nodelist table containing
# information from a Fidonet/FTN St. Louis Format Nodelist
# Copyright (c) 2010 Robert James Clay.  All Rights Reserved.
# This is free software;  you can redistribute it and/or
# modify it under the same terms as Perl itself.
#
APPDIR=/opt/ftn/nl2db
BINDIR=$APPDIR/bin
LOGDIR=$APPDIR/log
NLTABLE=Nodelist
LISTFILE=$LOGDIR/netlist.txt

cd $APPDIR

#$LIBDIR/net2file.pl [-t nodelisttablename] [-D dbname] [-u dbuser] [-p dbpass] {-z zone] [-n net] [-o outfile] [-v] [-h] 
$LIBDIR/net2file.pl -t $NLTABLE -D $DBNAME -z 1 -n 102 -o $LISTFILE -v 2>$LOGDIR/net2file.errors
