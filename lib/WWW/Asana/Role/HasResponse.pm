package WWW::Asana::Role::HasResponse;
# ABSTRACT: 

use MooX::Role;

has response => (
	is => 'rw',
	predicate => 'has_response',
);

1;
