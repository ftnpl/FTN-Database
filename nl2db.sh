#!/bin/sh
# nl2db.sh - 1.2
#  This is an example test script that loads two nodelists 
# Copyright (c) 2001-2010 Robert James Clay.  All Rights Reserved.
# This is free software;  you can redistribute it and/or
# modify it under the same terms as Perl itself.
#
APPDIR=/opt/ftn/nl2db
BINDIR=$APPDIR/bin
LOGDIR=$APPDIR/log
LOGFILE=$LOGDIR/nl2db.log
NLDIR=/opt/ftn/nodelist

cd $APPDIR

##$BINDIR/nl2db.pl -n nldir [-D dbname] [-u dbuser] [-p dbpass] [-f nlfile] [-l logfile] [-d domain] [-v] [-x] [-e] [-z] 2>$LOGDIR/nl2db.stn.errors
$BINDIR/nl2db.pl -n $NLDIR -f STNLIST -l $LOGFILE -d stn -v -x 2>$LOGDIR/nl2db.stn.errors
#
#$BINDIR/nl2db.pl -n $NLDIR [-D dbname] [-u dbuser] [-p dbpass] [-f nodelist] [-d fidonet] [-v] [-x] [-e] [-z] 2>$LOGDIR/nlsql.ftn.errors
$BINDIR/nl2db.pl -n $NLDIR -l $LOGFILE -d fidonet -v 2>$LOGDIR/nl2db.ftn.errors
