package WWW::Asana::Task;
# ABSTRACT: Asana Task Class

use MooX;

with 'WWW::Asana::Role::HasClient';
with 'WWW::Asana::Role::HasFollowers';
with 'WWW::Asana::Role::CanReload';
with 'WWW::Asana::Role::CanUpdate';
with 'WWW::Asana::Role::HasResponse';
with 'WWW::Asana::Role::NewFromResponse';
with 'WWW::Asana::Role::HasStories';

sub own_base_args { 'tasks', shift->id }

sub reload_base_args { 'Task', 'GET' }
sub update_base_args { 'Task', 'PUT' }

has id => (
	is => 'ro',
	predicate => 1,
);

has assignee => (
	is => 'ro',
	isa => sub {
		die "assignee must be a WWW::Asana::User" unless ref $_[0] eq 'WWW::Asana::User';
	},
	predicate => 1,
);

has assignee_status => (
	is => 'ro',
	isa => sub {
		die "assignee_status must be inbox, later, today or upcoming"
			unless grep { $_[0] eq $_ } qw( inbox later today upcoming );
	},
);

has created_at => (
	is => 'ro',
	isa => sub {
		die "created_at must be a DateTime" unless ref $_[0] eq 'DateTime';
	},
	predicate => 1,
);

has completed => (
	is => 'ro',
	predicate => 1,
);

has completed_at => (
	is => 'ro',
	isa => sub {
		die "completed_at must be a DateTime" unless ref $_[0] eq 'DateTime';
	},
	predicate => 1,
);

has due_on => (
	is => 'ro',
	isa => sub {
		die "due_on must be a DateTime" unless ref $_[0] eq 'DateTime';
	},
);

has name => (
	is => 'ro',
	predicate => 1,
);

has notes => (
	is => 'ro',
	predicate => 1,
);

has projects => (
	is => 'ro',
	predicate => 1,
);

has workspace => (
	is => 'ro',
	isa => sub {
		die "workspace must be a WWW::Asana::Workspace" unless ref $_[0] eq 'WWW::Asana::Workspace';
	},
	predicate => 1,
);

has projects => (
	is => 'ro',
	isa => sub {
		die "projects must be an ArrayRef" unless ref $_[0] eq 'ARRAY';
		die "projects must be an ArrayRef of WWW::Asana::Project" if grep { ref $_ ne 'WWW::Asana::Project' } @{$_[0]};
	},
	predicate => 1,
);

1;
