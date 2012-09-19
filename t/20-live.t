#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

if (defined $ENV{WWW_ASANA_TEST_API_KEY}) {
	use_ok('WWW::Asana');
	my $asana = WWW::Asana->new(
		api_key => $ENV{WWW_ASANA_TEST_API_KEY},
	);
	my $me = $asana->me;
	ok(ref $me eq 'WWW::Asana::User','Testing API access');
} else {
	plan skip_all => 'Not doing live tests without WWW_ASANA_TEST_API_KEY ENV variable';
}

done_testing;