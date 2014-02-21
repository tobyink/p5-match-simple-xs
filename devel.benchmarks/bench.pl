#!/usr/bin/env perl

use strict;
use warnings;
use Benchmark qw(cmpthese);
use match::simple ();
use match::simple::XS ();
use Types::Standard -all;

sub do_cmp
{
	print shift, $/;
	$::A = shift;
	$::B = shift;
	die unless (!!match::simple::XS::match($::A, $::B))==(!!match::simple::match($::A, $::B));
	cmpthese -1, {
		XS  => q[ match::simple::XS::match($::A, $::B) ],
		PP  => q[ match::simple::match($::A, $::B) ],
	};
	print $/;
	();
}

do_cmp("Undef...");
do_cmp("String eq...", "a", "a");
do_cmp("Regexp...", "a", qr/a/);  # SLOWER!
do_cmp("Coderef...", 1, sub { 1 });
do_cmp("Type constraint...", {}, HashRef);
do_cmp("In array...", 6, [0..9]);
do_cmp("In regexp array...", "e", [qr/a/, qr/b/, qr/c/, qr/d/, qr/e/, qr/f/]);

__END__
Undef...
        Rate   PP   XS
PP  445389/s   -- -73%
XS 1668189/s 275%   --

String eq...
        Rate   PP   XS
PP  317021/s   -- -77%
XS 1349271/s 326%   --

Regexp...
       Rate   XS   PP
XS  86016/s   -- -25%
PP 114687/s  33%   --

Coderef...
       Rate   PP   XS
PP 124842/s   -- -66%
XS 365855/s 193%   --

Type constraint...
      Rate   PP   XS
PP 33184/s   -- -51%
XS 67623/s 104%   --

In array...
       Rate    PP    XS
PP  18270/s    --  -96%
XS 508970/s 2686%    --

In regexp array...
      Rate   PP   XS
PP 13917/s   -- -25%
XS 18618/s  34%   --
