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

sub opt_fields { qw(name email) }

sub own_base_args { 'users', shift->id }
sub reload_base_args { 'User', 'GET' }

has id => (
	is => 'rw',
	required => 1,
);

has name => (
	is => 'rw',
	predicate => 1,
);

has email => (
	is => 'rw',
	predicate => 1,
);

has workspaces => (
	is => 'rw',
	isa => sub {
		die "workspaces must be an ArrayRef" unless ref $_[0] eq 'ARRAY';
		die "workspaces must be an ArrayRef of WWW::Asana::Workspace" if grep { ref $_ ne 'WWW::Asana::Workspace' } @{$_[0]};
	},
	predicate => 1,
);

has tasks => (is=>'rw', predicate=>1, lazy=>1, builder=>1);

# Iterate through all of that user's Workspaces. This is how
# you get all the tasks for a given user.

sub _build_tasks {
	my $self = shift;
	return [ map { @{ $_->tasks($self) || [] } } @{$self->workspaces} ];
}

1;
