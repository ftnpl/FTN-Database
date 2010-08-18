package FTN::Database::Nodelist;

use warnings;
use strict;

=head1 NAME

FTN::Database::Nodelist - Fidonet/FTN Nodelist SQL Database operations.

=head1 VERSION

Version 0.03

=cut

our $VERSION = '0.03';


=head1 SYNOPSIS

FTN::Database::Nodelist is a Perl module containing common nodelist related subroutines
for Fidonet/FTN Nodelist related processing on a Nodelist table in an SQL Database. The
SQL database engine is one for which a DBD module exists, defaulting to SQLite.

Perhaps a little code snippet.

    use FTN::Database::Nodelist;

    my $foo = FTN::Database::Nodelist->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 FUNCTIONS

=head2 function1

=cut

sub function1 {
}

=head2 function2

=cut

sub function2 {
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
