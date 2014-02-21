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
}

do_cmp("Undef...");
do_cmp("String eq...", "a", "a");
do_cmp("Regexp...", "a", qr/a/);  # SLOWER!
#do_cmp("Coderef...", 1, sub { 1 }); # CRASHES!!
do_cmp("Type constraint...", {}, HashRef);
do_cmp("In array...", 6, [0..9]);
do_cmp("In regexp array...", "e", [qr/a/, qr/b/, qr/c/, qr/d/, qr/e/, qr/f/]);

__END__
Undef...
        Rate   PP   XS
PP  431158/s   -- -73%
XS 1609656/s 273%   --
String eq...
        Rate   PP   XS
PP  314139/s   -- -77%
XS 1353916/s 331%   --
Regexp...
       Rate   XS   PP
XS  86016/s   -- -24%
PP 113552/s  32%   --
Type constraint...
      Rate   PP   XS
PP 34132/s   -- -50%
XS 68922/s 102%   --
In array...
       Rate    PP    XS
PP  18442/s    --  -96%
XS 494700/s 2582%    --
In regexp array...
      Rate   PP   XS
PP 14490/s   -- -26%
XS 19548/s  35%   --
