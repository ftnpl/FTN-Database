#!/bin/sh
# loadzone.sh - 1.2
#  This is an example script that loads a specific zone from
# a specific nodelist file.
# Copyright (c) 2010 Robert James Clay.  All Rights Reserved.
# This is free software;  you can redistribute it and/or
# modify it under the same terms as Perl itself.
#
APPDIR=/opt/ftn/nl2db
BINDIR=$APPDIR/bin
LOGDIR=$APPDIR/log
LOGFILE=$LOGDIR/nl2db.log
NLDIR=/opt/ftn/nodelist
NLFILE=nodelist.197

cd $APPDIR

#$BINDIR/nl2db.pl -t $NLDIR [-T dbtype] [-D dbname] [-u dbuser] [-p dbpass] [-f nodelist] [-d fidonet] [-v] [-x] [-e] [-z zonenum] 2>$LOGDIR/nlsql.ftn.errors
$BINDIR/nl2db.pl -t $NLDIR -f $NLFILE -l $LOGFILE -d fidonet -z 1 -e -v 2>$LOGDIR/nl2db.ftn.errors
