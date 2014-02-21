#!/usr/bin/env perl

BEGIN {
	$ENV{MATCH_SIMPLE_IMPLEMENTATION} = 'PP';
};

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
	die unless (!!match::simple::XS::match($::A, $::B))==do { no warnings; $::A ~~ $::B };
	cmpthese -1, {
		XS  => q[ match::simple::XS::match($::A, $::B) ],
		PP  => q[ match::simple::match($::A, $::B) ],
		SM  => q[ no warnings; $::A ~~ $::B ],
	};
	print $/;
	();
}

do_cmp("Undef...");
do_cmp("String eq...", "a", "a");
do_cmp("Regexp...", "a", qr/a/);  # SLOWER!
do_cmp("Coderef...", 1, sub { 1 });
do_cmp("Type constraint...", {}, HashRef);
do_cmp("In array...", 6, [0..9]);  # BEATS ~~
do_cmp("In regexp array...", "e", [qr/a/, qr/b/, qr/c/, qr/d/, qr/e/, qr/f/]);

__END__
Undef...
        Rate    PP    XS    SM
PP  436906/s    --  -72%  -92%
XS 1571965/s  260%    --  -71%
SM 5375263/s 1130%  242%    --

String eq...
        Rate   PP   XS   SM
PP  317021/s   -- -77% -85%
XS 1402911/s 343%   -- -33%
SM 2104367/s 564%  50%   --

Regexp...
       Rate   XS   PP   SM
XS  87061/s   -- -23% -82%
PP 112438/s  29%   -- -77%
SM 494700/s 468% 340%   --

Coderef...
       Rate   PP   XS   SM
PP 128478/s   -- -67% -76%
XS 389212/s 203%   -- -26%
SM 526092/s 309%  35%   --

Type constraint...
       Rate   PP   XS   SM
PP  35223/s   -- -51% -69%
XS  72404/s 106%   -- -36%
SM 113551/s 222%  57%   --

In array...
       Rate    PP    SM    XS
PP  18270/s    --  -96%  -96%
SM 449757/s 2362%    --  -12%
XS 513912/s 2713%   14%    --

In regexp array...
       Rate   PP   XS   SM
PP  13713/s   -- -26% -87%
XS  18442/s  34%   -- -83%
SM 109227/s 696% 492%   --
