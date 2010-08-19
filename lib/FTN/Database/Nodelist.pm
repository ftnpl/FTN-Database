package FTN::Database::Nodelist;

use warnings;
use strict;
use Carp qw( croak );

=head1 NAME

FTN::Database::Nodelist - Fidonet/FTN Nodelist SQL Database operations.

=head1 VERSION

Version 0.04

=cut

our $VERSION = '0.04';


=head1 SYNOPSIS

FTN::Database::Nodelist is a Perl module containing common nodelist related subroutines
for Fidonet/FTN Nodelist related processing on a Nodelist table in an SQL Database. The
SQL database engine is one for which a DBD module exists, defaulting to SQLite.

Perhaps a little code snippet.

    use FTN::Database::Nodelist;

    my $db_handle = open_ftndb($db_type, $db_name, $db_user, $db_pass);
    create_nodelist_table($db_handle, $table_name);
    ...   (Load data to nodelist table)
    create_ftnnode_index($db_handle, $table_name);
    close_ftndb($db_handle);


=head1 EXPORT

The following functions are available in this module:  create_nodelist_table(),
drop_nodelist_table(), create_ftnnode_index().

=head1 FUNCTIONS

=head2 create_nodelist_table

Syntax:  create_nodelist_table($db_handle, $table_name);

Create an FTN Nodelist table in an SQL database being used for Fidonet/FTN
processing, where $db_handle is an existing open database handle and $table_name
is the name of the table to be created.

=cut

sub create_nodelist_table {

    my($db_handle, $table_name) = @_;

    my $sql_stmt = "CREATE TABLE $table_name( ";

    $sql_stmt .= "id	INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, ";
    $sql_stmt .= "type      VARCHAR(6) DEFAULT '' NOT NULL, ";
    $sql_stmt .= "zone      SMALLINT  DEFAULT '1' NOT NULL, ";
    $sql_stmt .= "net       SMALLINT  DEFAULT '1' NOT NULL, ";
    $sql_stmt .= "node      SMALLINT  DEFAULT '1' NOT NULL, ";
    $sql_stmt .= "point     SMALLINT  DEFAULT '0' NOT NULL, ";
    $sql_stmt .= "region    SMALLINT  DEFAULT '0' NOT NULL, ";
    $sql_stmt .= "name      VARCHAR(32) DEFAULT '' NOT NULL, ";
    $sql_stmt .= "location  VARCHAR(32) DEFAULT '' NOT NULL, ";
    $sql_stmt .= "sysop     VARCHAR(32) DEFAULT '' NOT NULL, ";
    $sql_stmt .= "phone     VARCHAR(20) DEFAULT '000-000-000-000' NOT NULL, ";
    $sql_stmt .= "baud      CHAR(6) DEFAULT '300' NOT NULL, ";
    $sql_stmt .= "flags     VARCHAR(64) DEFAULT ' ' NOT NULL, ";
    $sql_stmt .= "domain    VARCHAR(8) DEFAULT 'fidonet' NOT NULL, ";
    $sql_stmt .= "source    VARCHAR(16) DEFAULT 'local' NOT NULL, ";
    $sql_stmt .= "updated   TIMESTAMP(14) DEFAULT '' NOT NULL ";
    $sql_stmt .= ") ";

    $db_handle->do("$sql_stmt ") or croak($DBI::errstr);

    return(0);

}

=head2 drop_nodelist_table

Syntax:  drop_nodelist_table($db_handle, $table_name);

Drop an FTN Nodelist table from an SQL database being used for Fidonet/FTN
processing if it exists, where $db_handle is an existing open database handle
and $table_name is the name of the table to be dropped.

=cut

sub drop_nodelist_table {

    my($db_handle, $table_name) = @_;

    my $sql_stmt = "DROP TABLE IF EXISTS $table_name";

    $db_handle->do("$sql_stmt") or croak($DBI::errstr);

    return(0);
    
}

=head2 create_ftnnode_index

Syntax:  create_ftnnode_index($db_handle, $table_name);

Create an index named ftnnode on an FTN Nodelist table in an SQL database being
used for Fidonet/FTN processing, where $db_handle is an existing open database
handle and $table_name is the name of the table that is being indexed.  The
index is created on the following fields:  zone, net, node, point, and domain.

=cut

sub create_ftnnode_index {

    my($db_handle, $table_name) = @_;

    my $sql_stmt = "CREATE INDEX ftnnode ";
    $sql_stmt .= "ON $table_name (zone,net,node,point,domain) ";

    $db_handle->do("$sql_stmt") or croak($DBI::errstr);

    return(0);
    
}

=head2 drop_ftnnode_index

Syntax:  drop_ftnnode_index($db_handle);

Drop an index named ftnnode on an FTN Nodelist table in an SQL database being
used for Fidonet/FTN processing if it exists, where $db_handle is an existing
open database handle.

=cut

sub drop_ftnnode_index {

    my $db_handle = shift;

    my $sql_stmt = "DROP INDEX IF EXISTS ftnnode";

    $db_handle->do("$sql_stmt") or croak($DBI::errstr);

    return(0);
    
}

=head1 AUTHOR

Robert James Clay, C<< <jame at rocasa.us> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-ftn-database at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=FTN-Database>.  I will
be notified, and then you'll automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc FTN::Database::Nodelist


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=FTN-Database>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/FTN-Database>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/FTN-Database>

=item * Search CPAN

L<http://search.cpan.org/dist/FTN-Database>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2010 Robert James Clay, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of FTN::Database::Nodelist
