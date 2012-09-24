package WWW::Asana::Role::HasClient;
# ABSTRACT: Role for a class which has a WWW::Asana client

use MooX::Role;

has client => (
	is => 'ro',
	isa => sub {
		die "client must be a WWW::Asana" unless ref $_[0] eq 'WWW::Asana';
	},
	predicate => 'has_client',
	handles => [qw(
		do
	)],
);

1;