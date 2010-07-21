#!/bin/sh
# nltable.sh - 1.2
#  This is an example script that creates the nodelist table. 
# Copyright (c) 2010 Robert James Clay.  All Rights Reserved.
# This is free software;  you can redistribute it and/or
# modify it under the same terms as Perl itself.
#
APPDIR=/opt/ftn/nl2db
BINDIR=$APPDIR/bin
LOGDIR=$APPDIR/log
NLTABLE=nodelist

cd $APPDIR

#$BINDIR/nldbadm.pl [-n nodelisttablename] [-T dbtype] [-D dbname] [-u dbuser] [-p dbpass] [-v] [-h] 
$BINDIR/nldbadm.pl -n $NLTABLE -v 2>$LOGDIR/nltable.errors
#
