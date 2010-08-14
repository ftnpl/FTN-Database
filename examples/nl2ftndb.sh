#!/bin/sh
# nl2ftndb.sh 
#  This is an example test script that loads two nodelists 
# Copyright (c) 2010 Robert James Clay.  All Rights Reserved.
# This is free software;  you can redistribute it and/or
# modify it under the same terms as Perl itself.
#
APPDIR=/opt/ftnpldb
BINDIR=$APPDIR/bin
LOGDIR=$APPDIR/log
LOGFILE=$LOGDIR/nl2ftndb.log
NLDIR=/opt/ftn/nodelist

cd $APPDIR

##$BINDIR/nl2ftndb -n nldir [-t tablename] [-T dbtype] [-D dbname] [-u dbuser] [-p dbpass] [-f nlfile] [-l logfile] [-d domain] [-v] [-x] [-e] [-z zonenum] 2>$LOGDIR/nl2ftndb.stn.errors
$BINDIR/nl2ftndb -n $NLDIR -f STNLIST -l $LOGFILE -d stn -v -x 2>$LOGDIR/nl2ftndb.stn.errors
#
#$BINDIR/nl2ftndb -n $NLDIR [-t tablename] [-D dbname] [-u dbuser] [-p dbpass] [-f nodelist] [-d fidonet] [-v] [-x] [-e] [-z zonenum] 2>$LOGDIR/nlsql.ftn.errors
$BINDIR/nl2ftndb -n $NLDIR -l $LOGFILE -d fidonet -v 2>$LOGDIR/nl2ftndb.ftn.errors
