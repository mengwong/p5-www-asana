package WWW::Asana::Role::HasFollowers;

use MooX::Role;

has followers => (
	is => 'ro',
	isa => sub {
		die "followers must be an ArrayRef" unless ref $_[0] eq 'ARRAY';
		die "followers must be an ArrayRef of WWW::Asana::User" if grep { ref $_ ne 'WWW::Asana::User' } @{$_[0]};
	},
	default => sub {[]},
);

1;