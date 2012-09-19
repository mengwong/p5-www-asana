package WWW::Asana::User;

use MooX;

with 'WWW::Asana::Role::HasClient';

has id => (
	is => 'ro',
	required => 1,
);

has name => (
	is => 'ro',
	required => 1,
);

has email => (
	is => 'ro',
	required => 1,
);

has workspaces => (
	is => 'ro',
	isa => sub {
		die "workspaces must be an ArrayRef" unless ref $_[0] eq 'ARRAY';
		die "workspaces must be an ArrayRef of WWW::Asana::Workspace" if grep { ref $_ ne 'WWW::Asana::Workspace' } @{$_[0]};
	},
	default => sub {[]},
);

1;
