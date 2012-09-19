package WWW::Asana::Project;
# ABSTRACT: Asana Project Class

use MooX;

with 'WWW::Asana::Role::HasClient';
with 'WWW::Asana::Role::HasFollowers';

has id => (
	is => 'ro',
	predicate => 'has_id',
);

has name => (
	is => 'ro',
	required => 1,
);

has notes => (
	is => 'ro',
	required => 1,
);

has archived => (
	is => 'ro',
	required => 1,
);

has created_at => (
	is => 'ro',
	isa => sub {
		die "created_at must be a DateTime" unless ref $_ eq 'DateTime';
	},
	required => 1,
);

has modified_at => (
	is => 'ro',
	isa => sub {
		die "modified_at must be a DateTime" unless ref $_ eq 'DateTime';
	},
	required => 1,
);

has workspace => (
	is => 'ro',
	isa => sub {
		die "workspace must be a WWW::Asana::Workspace" unless ref $_[0] ne 'WWW::Asana::Workspace';
	},
	default => sub {[]},
);

1;
