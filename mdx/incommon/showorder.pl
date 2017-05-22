#!/usr/bin/env perl

use strict;
my $id;
my $reg;

while (<>) {
	if (/entityID=['"]([^'"]*)/) {
		$id = $1;
	}
	if (/registrationAuthority=['"]([^'"]*)/) {
		$reg = $1;
		print "$reg -> $id\n";
	}
}
