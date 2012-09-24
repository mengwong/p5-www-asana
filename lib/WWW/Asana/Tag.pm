package WWW::Asana::Tag;
# ABSTRACT: Asana Tag Class

use MooX;

with 'WWW::Asana::Role::HasClient';
with 'WWW::Asana::Role::HasFollowers';
with 'WWW::Asana::Role::CanReload';
with 'WWW::Asana::Role::CanUpdate';
with 'WWW::Asana::Role::HasResponse';
with 'WWW::Asana::Role::NewFromResponse';

sub own_base_args { 'tags', shift->id }

sub reload_base_args { 'Tag', 'GET' }
sub update_base_args { 'Tag', 'PUT' }

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

has created_at => (
	is => 'ro',
	isa => sub {
		die "created_at must be a DateTime" unless ref $_ eq 'DateTime';
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
