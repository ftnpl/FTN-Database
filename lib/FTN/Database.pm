package FTN::Database;

use warnings;
use strict;
use Carp qw( croak );

=head1 NAME

FTN::Database - FTN SQL Database related operations for Fidonet/FTN related processing.

=head1 VERSION

Version 0.10

=cut

our $VERSION = '0.10';


=head1 SYNOPSIS

FTN::Database is a Perl module containing common database related operations for
Fidonet/FTN related SQL Database operations.  The SQL database engine is one for
which a DBD module exists, defaulting to SQLite.

Perhaps a little code snippet.

    use FTN::Database;

    my $db_handle = open_ftndb($db_type, $db_name, $db_user, $db_pass);
    ...
    close_ftndb($db_handle);


=head1 EXPORT

The following functions are available in this module:  open_ftndb, close_ftndb.

=head1 FUNCTIONS

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

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2010 Robert James Clay, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of FTN::Database
