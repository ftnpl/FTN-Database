package FTN::Database;

use warnings;
use strict;
use Carp qw( croak );

=head1 NAME

FTN::Database - FTN SQL Database related operations for Fidonet/FTN related processing.

=head1 VERSION

Version 0.16

=cut

our $VERSION = '0.16';

=head1 DESCRIPTION

FTN::Database is Perl modules containing common database related operations
for Fidonet/FTN related SQL Database processing plus associated scripts.  The
SQL database engine is one for which a DBD module exists, defaulting to SQLite.

=head1 EXPORT

The following functions are available in this module:  create_ftndb, open_ftndb,
close_ftndb, and drop_ftndb.

=head1 FUNCTIONS

=head2 create_ftndb

Syntax:  create_ftndb($db_handle, $database_name);

Create an SQL database for use for Fidonet/FTN processing, where
$db_handle is an existing open database handle and $database_name
is the name of the database being created.

=cut

sub create_ftndb {

    my($db_handle, $database_name) = @_;

    my $sql_statement = "CREATE DATABASE $database_name";

    $db_handle->do("$sql_statement") or croak($DBI::errstr);

    return(0);
    
}

=head2 open_ftndb

Syntax:  $db_handle = open_ftndb($db_type, $db_name, $db_user, $db_pass);

Open a database for Fidonet/FTN processing, where:

=over

=item	$db_type

The database type.  This needs to be a database type for which 
a DBD module exists, the type being the name as used in the DBD
module.  The default type to be used is SQLite.

=item	$db_name

The database name.

=item	$db_user

The database user, which should already have the neccesary priviledges.

=item	$db_pass

The database password for the database user.

=item	$db_handle

The database handle being returned to the calling program.

=back

=cut

sub open_ftndb {

    use DBI;

    my($db_type, $db_name, $db_user, $db_pass) = @_;

    ( my $db_handle = DBI->connect( "dbi:$db_type:dbname=$db_name", $db_user, $db_pass ) )
	or croak($DBI::errstr);

    return($db_handle);
    
}

=head2 close_ftndb

Syntax:  close_ftndb($db_handle);

Closing an FTN database, where $db_handle is an existing open database handle.

=cut

sub close_ftndb {

    my $db_handle = shift;

    ( $db_handle->disconnect ) or croak($DBI::errstr);

    return(0);
    
}

=head2 drop_ftndb

Syntax:  drop_ftndb($db_handle, $database_name);

Drop an SQL database being used for Fidonet/FTN processing if
it exists, where $db_handle is an existing open database handle
and $database_name is the name of the database being dropped.

=cut

sub drop_ftndb {

    my($db_handle, $database_name) = @_;

    my $sql_statement = "DROP DATABASE IF EXISTS $database_name";

    $db_handle->do("$sql_statement") or croak($DBI::errstr);

    return(0);
    
}

=head1 EXAMPLES

An example of opening an FTN database, then closing it:

    use FTN::Database;

    my $db_handle = open_ftndb($db_type, $db_name, $db_user, $db_pass);
    ...
    close_ftndb($db_handle);

An example of creating a database for FTN related processing, using a
mysql database:

    use FTN::Database;

    my $database_name = "ftndbtst";
    my $db_handle = open_ftndb("mysql", "mysql", $db_user, $db_pass);
    create_ftndb($db_handle, $database_name);
    ...
    close_ftndb($db_handle);

An example of dropping a database being used for FTN related processing,
using a mysql database:

    use FTN::Database;

    my $database_name = "ftndbtst";
    my $db_handle = open_ftndb("mysql", "mysql", $db_user, $db_pass);
    ...
    drop_ftndb($db_handle, $database_name);
    close_ftndb($db_handle);


=head1 AUTHOR

Robert James Clay, C<< <jame at rocasa.us> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-ftn-database at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=FTN-Database>. I will be
notified, and then you'll automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc FTN::Database


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

Note that the version number in scripts matches up to the oldest version
of the modules that they will run with.  The version in FTN::Database is
always the primary version, while the version of the submodules matches
up to the version at which they were last changed.

=back

=head1 SEE ALSO

 L<DBI>, L<FTN::Database::Nodelist>, L<ftndbadm>, L<listftndb>, L<ftndbadm>,
 and L<nl2ftndb>

=head1 COPYRIGHT & LICENSE

Copyright 2010 Robert James Clay, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of FTN::Database
