4#!/bin/sh
# nltable.sh - 1.2
#  This is an example script that creates the nodelist table. 
# Copyright (c) 2010 Robert James Clay.  All Rights Reserved.
# This is free software;  you can redistribute it and/or
# modify it under the same terms as Perl itself.
#
BINDIR=/opt/ftn/sql/nl2sql
NLTABLE=nodelist
LOGDIR=/var/log/bbsdbpl
#$BINDIR/nldbadm.pl -n $NLTABLE -v  2>$LOGDIR/nltable.errors
$BINDIR/nldbadm.pl -n $NLTABLE -v  2>$LOGDIR/nltable.errors
#
