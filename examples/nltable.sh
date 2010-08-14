#!/bin/sh
# nltable.sh
#  This is an example script that creates the nodelist table. 
# Copyright (c) 2010 Robert James Clay.  All Rights Reserved.
# This is free software;  you can redistribute it and/or
# modify it under the same terms as Perl itself.
#
APPDIR=/opt/ftnpldb
BINDIR=$APPDIR/bin
LOGDIR=$APPDIR/log
NLTABLE=nodelist

cd $APPDIR

#$BINDIR/ftndbadm [-t nodelisttablename] [-T dbtype] [-D dbname] [-u dbuser] [-p dbpass] [-v] [-h] 
$BINDIR/ftndbadm -t $NLTABLE -v 2>$LOGDIR/nltable.errors
#
