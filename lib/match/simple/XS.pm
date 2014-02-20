package match::simple::XS;

use 5.008000;
use strict;
use warnings;

our $AUTHORITY = 'cpan:TOBYINK';
our $VERSION   = '0.001';

require XSLoader;
XSLoader::load('match::simple::XS', $VERSION);

sub _regexp { scalar($_[0] =~ $_[1]) }

if ($] >= 5.010)
{
	eval q[
		no warnings;
		use overload ();
		sub _smartmatch {
			return 0 unless overload::Method($_[1], "~~");
			!!( $_[0] ~~ $_[1] )
		}
	];
}
else
{
	eval q[
		sub _smartmatch { 0 }
	];
}

1;
__END__

=head1 NAME

match::simple::XS - XS backend for match::simple

=head1 SYNOPSIS

  use match::simple;

=head1 DESCRIPTION

Nothing to see here; move along.

=head1 SEE ALSO

L<match::simple>.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2014 by Toby Inkster.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 DISCLAIMER OF WARRANTIES

THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.

