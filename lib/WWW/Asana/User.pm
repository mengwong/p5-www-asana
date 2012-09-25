package WWW::Asana::User;
# ABSTRACT: Asana User Class

use MooX;

with 'WWW::Asana::Role::HasClient';
with 'WWW::Asana::Role::HasResponse';
with 'WWW::Asana::Role::NewFromResponse';

with 'WWW::Asana::Role::CanReload';
# CanNotUpdate
# CanNotCreate
# CanNotDelete

sub own_base_args { 'users', shift->id }
sub reload_base_args { 'User', 'GET' }

has id => (
	is => 'ro',
	required => 1,
);

has name => (
	is => 'ro',
	predicate => 1,
);

has email => (
	is => 'ro',
	predicate => 1,
);

has workspaces => (
	is => 'ro',
	isa => sub {
		die "workspaces must be an ArrayRef" unless ref $_[0] eq 'ARRAY';
		die "workspaces must be an ArrayRef of WWW::Asana::Workspace" if grep { ref $_ ne 'WWW::Asana::Workspace' } @{$_[0]};
	},
	predicate => 1,
);

1;
