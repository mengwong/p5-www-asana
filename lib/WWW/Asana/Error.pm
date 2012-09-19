package WWW::Asana::Error;

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