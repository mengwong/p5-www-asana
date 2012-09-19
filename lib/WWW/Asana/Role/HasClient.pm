package WWW::Asana::Role::HasClient;
# ABSTRACT: Role for a class which has a WWW::Asana client

use MooX::Role;

has client => (
	is => 'ro',
	isa => sub {
		die "followers must be a WWW::Asana" unless ref $_ eq 'WWW::Asana';
	},
	predicate => 'has_client',
);

1;