package WWW::Asana::Role::HasResponse;
# ABSTRACT: 

use MooX::Role;

has response => (
	is => 'ro',
	predicate => 'has_response',
);

1;