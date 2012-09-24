package WWW::Asana::Role::HasFollowers;
# ABSTRACT: Role for a class which has followers

use MooX::Role;

has followers => (
	is => 'ro',
	isa => sub {
		die "followers must be an ArrayRef" unless ref $_[0] eq 'ARRAY';
		die "followers must be an ArrayRef of WWW::Asana::User" if grep { ref $_ ne 'WWW::Asana::User' } @{$_[0]};
	},
	predicate => 'has_followers',
);

1;