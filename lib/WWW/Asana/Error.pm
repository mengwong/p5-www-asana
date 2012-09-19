package WWW::Asana::Error;
# ABSTRACT: Asana Error Class

use MooX;

has message => (
	is => 'ro',
	required => 1,
);

has phrase => (
	is => 'ro',
	predicate => 'has_phrase',
);

1;