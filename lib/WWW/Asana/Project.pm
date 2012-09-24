package WWW::Asana::Project;
# ABSTRACT: Asana Project Class

use MooX;

with 'WWW::Asana::Role::HasClient';
with 'WWW::Asana::Role::HasFollowers';
with 'WWW::Asana::Role::CanReload';
with 'WWW::Asana::Role::CanUpdate';
with 'WWW::Asana::Role::HasResponse';
with 'WWW::Asana::Role::NewFromResponse';
with 'WWW::Asana::Role::HasStories';

sub own_base_args { 'projects', shift->id }

sub reload_base_args { 'Project', 'GET' }
sub update_base_args { 'Project', 'PUT' }

has id => (
	is => 'ro',
	predicate => 1,
);

has name => (
	is => 'ro',
	predicate => 1,
);

has notes => (
	is => 'ro',
	predicate => 1,
);

has archived => (
	is => 'ro',
	predicate => 1,
);

has created_at => (
	is => 'ro',
	isa => sub {
		die "created_at must be a DateTime" unless ref $_ eq 'DateTime';
	},
	predicate => 1,
);

has modified_at => (
	is => 'ro',
	isa => sub {
		die "modified_at must be a DateTime" unless ref $_ eq 'DateTime';
	},
	predicate => 1,
);

has workspace => (
	is => 'ro',
	isa => sub {
		die "workspace must be a WWW::Asana::Workspace" unless ref $_[0] eq 'WWW::Asana::Workspace';
	},
	predicate => 1,
);

1;
