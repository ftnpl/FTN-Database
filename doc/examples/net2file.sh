#!/bin/sh
# net2file.sh  
# List a specified net from a specified zone of a nodelist table containing
# information from a Fidonet/FTN St. Louis Format Nodelist
# Copyright (c) 2010 Robert James Clay.  All Rights Reserved.
# This is free software;  you can redistribute it and/or
# modify it under the same terms as Perl itself.
#
APPDIR=/opt/ftnldb
BINDIR=$APPDIR/bin
LOGDIR=$APPDIR/log
NLTABLE=Nodelist
LISTFILE=$LOGDIR/netlist.txt

cd $APPDIR

#$LIBDIR/listftndb [-t nodelisttablename] [-D dbname] [-u dbuser] [-p dbpass] {-z zone] [-n net] [-o outfile] [-v] [-h] 
$LIBDIR/listftndb -t $NLTABLE -D $DBNAME -z 1 -n 102 -o $LISTFILE -v 2>$LOGDIR/net2file.errors

