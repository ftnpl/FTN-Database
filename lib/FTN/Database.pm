package FTN::Database;

use warnings;
use strict;
use Carp qw( croak );

=head1 NAME

FTN::Database - FTN SQL Database related operations for Fidonet/FTN related processing.

=head1 VERSION

Version 0.34

=cut

our $VERSION = '0.34';

=head1 DESCRIPTION

FTN::Database are Perl modules containing common database related operations
and definitions for Fidonet/FTN related SQL Database processing. The SQL database
engine is one for which a DBD module exists, defaulting to SQLite.

=head1 EXPORT

The following functions are available in this module: create_ftn_database, open_ftn_database,
close_ftn_database, drop_ftn_database, drop_ftn_table, create_ftn_index, and drop_ftn_index.

=head1 FUNCTIONS

=head2 create_ftn_database

Syntax:  create_ftn_database($db_handle, $database_name);

Create an SQL database for use for Fidonet/FTN processing, where
$db_handle is an existing open database handle and $database_name
is the name of the database being created.

=cut

sub create_ftn_database {

    my($db_handle, $database_name) = @_;

    my $sql_statement = "CREATE DATABASE $database_name";

    $db_handle->do("$sql_statement") or croak($DBI::errstr);

    return(0);

}

=head2 open_ftn_database

Syntax:  $db_handle = open_ftn_database(\%db_options);

Open a database for Fidonet/FTN processing, where $db_handle is the
database handle being returned to the calling program and the referenced
hash contains the following items:

=over

=item   Type

The database type.  This needs to be a database type for which
a DBD module exists, the type being the name as used in the DBD
module.  The default type to be used is SQLite.

=item   Name

The name of the database to be opened.  If the Type is SQLite, this
is a filename and path to the database file.

=item   User

The database user, which should already have the neccesary priviledges.

=item   Password

The database password for the database user.

=back

=cut

sub open_ftn_database {

    use DBI;

    # Get the hash reference to the information required for the connect
    my $option = shift;

    ( my $db_handle = DBI->connect(
        "dbi:${$option}{'Type'}:dbname=${$option}{'Name'}",
        ${$option}{'User'},
        ${$option}{'Password'} ) )
    or croak($DBI::errstr);

    return($db_handle);

}

=head2 close_ftn_database

Syntax:  close_ftn_database($db_handle);

Closing an FTN database, where $db_handle is an existing open database handle.

=cut

sub close_ftn_database {

    my $db_handle = shift;

    ( $db_handle->disconnect ) or croak($DBI::errstr);

    return(0);

}

=head2 drop_ftn_database

Syntax:  drop_ftn_database($db_handle, $database_name);

Drop an SQL database being used for Fidonet/FTN processing if
it exists, where $db_handle is an existing open database handle
and $database_name is the name of the database being dropped.

=cut

sub drop_ftn_database {

    my($db_handle, $database_name) = @_;

    my $sql_statement = "DROP DATABASE IF EXISTS $database_name";

    $db_handle->do("$sql_statement") or croak($DBI::errstr);

    return(0);

}

=head2 create_ftn_table

Syntax:  create_ftn_table($db_handle, $table_name, $define_fields, $db_type);

Create a table in an SQL database to be used for Fidonet/FTN processing, where
$db_handle is an existing open database handle, $table_name is the name of the
table to be created, $define_fields is the sql to define the fields to be used
for table except for an id field, and $db_type is the type of database.

=cut

sub create_ftn_table {

    my($db_handle, $table_name, $define_fields, $db_type) = @_;

    my $sql_statement = "CREATE TABLE $table_name( ";
    # If DB type is PostgreSQL, use SERIAL; else use INTEGER & AUTOINCREMENT
    if ($db_type eq 'Pg') {
        $sql_statement .= "id   SERIAL PRIMARY KEY NOT NULL, ";
    } else {
        $sql_statement .= "id   INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, ";
    }
    $sql_statement .= $define_fields;
    $sql_statement .= ") ";

    $db_handle->do("$sql_statement ") or croak($DBI::errstr);

    return(0);

}

=head2 drop_ftn_table

Syntax:  drop_ftn_table($db_handle, $table_name);

Drop an FTN table from an SQL database being used for Fidonet/FTN
processing if it exists, where $db_handle is an existing open database handle
and $table_name is the name of the table to be dropped.

=cut

sub drop_ftn_table {

    my($db_handle, $table_name) = @_;

    my $sql_statement = "DROP TABLE IF EXISTS $table_name";

    $db_handle->do("$sql_statement") or croak($DBI::errstr);

    return(0);

}

=head2 create_ftn_index

Syntax:  create_ftn_index($db_handle, $table_name, $index_name, $indexed_fields);

Create an index named $index_name on table $table_name in an SQL database being
used for Fidonet/FTN processing;  where $db_handle is an existing open database
handle, the $table_name is the name of the table that is being indexed, and
$index_name is the name of the index itself.  The index is created on the
fields listed in $indexed_fields, with the field names separated by commas.

=cut

sub create_ftn_index {

    my($db_handle, $table_name, $index_name, $indexed_fields) = @_;

    my $sql_statement = "CREATE INDEX $index_name ";
    $sql_statement .= "ON $table_name ($indexed_fields) ";

    $db_handle->do("$sql_statement") or croak($DBI::errstr);

    return(0);

}

=head2 drop_ftn_index

Syntax:  drop_ftn_index($db_handle,$index_name);

Drop an index from an FTN table in an SQL database being used for Fidonet/FTN
processing if it exists, where $db_handle is an existing open database handle,
and $index_name is the name of the index to be dropped.

=cut

sub drop_ftn_index {

    my($db_handle, $index_name) = @_;

    my $sql_statement = "DROP INDEX IF EXISTS $index_name";

    $db_handle->do("$sql_statement") or croak($DBI::errstr);

    return(0);

}

=head1 EXAMPLES

An example of opening an FTN database, then closing it:

    use FTN::Database;

    my $db_handle = open_ftn_database(\%db_option);
    ...
    close_ftn_database($db_handle);

An example of creating a database for FTN related processing, using a
mysql database:

    use FTN::Database;

    my $database_name = "ftndbtst";
    my $db_option = {
    Type = "mysql",
    Name = "mysql",
    User = $db_user,
    Password = $db_password,
    };
    my $db_handle = open_ftn_database(\%db_option);
    create_ftn_database($db_handle, $database_name);
    ...
    close_ftn_database($db_handle);

An example of dropping a database being used for FTN related processing,
using a mysql database:

    use FTN::Database;

    my $database_name = "ftndbtst";
    my $db_option = {
    Type = "mysql",
    Name = "mysql",
    User = $db_user,
    Password = $db_password,
    };
    my $db_handle = open_ftn_database(\%db_option);
    ...
    drop_ftn_database($db_handle, $database_name);
    close_ftn_database($db_handle);


=head1 AUTHOR

Robert James Clay, C<< <jame at rocasa.us> >>

=head1 BUGS

Please report any bugs or feature requests via the web interface at
L<http://sourceforge.net/p/ftnpl/ftn-database/tickets/>. I will be
notified, and then you'll automatically be notified of progress on
your bug as I make changes.

Note that you can also report any bugs or feature requests to
C<bug-ftn-database at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=FTN-Database>;
however, the FTN-Database Issue tracker at the SourceForge
project  is preferred.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc FTN::Database


You can also look for information at:

=over 4

=item * FTN::Database issue tracker

L<http://sourceforge.net/p/ftnpl/ftn-database/tickets/>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=FTN-Database>

=item * Search CPAN

L<http://search.cpan.org/dist/FTN-Database>

=back

=head1 SEE ALSO

 L<DBI>, L<FTN::Database::Nodelist>, L<FTN::Database::ToDo>

=head1 COPYRIGHT & LICENSE

Copyright 2010-2012 Robert James Clay, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of FTN::Database
