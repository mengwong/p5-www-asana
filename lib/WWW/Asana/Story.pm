package WWW::Asana::Story;
# ABSTRACT: Asana Story Class

use MooX;

with 'WWW::Asana::Role::HasClient';
with 'WWW::Asana::Role::HasResponse';
with 'WWW::Asana::Role::NewFromResponse';

with 'WWW::Asana::Role::CanReload';

sub own_base_args { 'tags', shift->id }

sub reload_base_args { 'Tag', 'GET' }

sub opt_fields { qw( created_at created_by text target source type) }

has id => (
	is => 'ro',
	predicate => 1,
);

has text => (
	is => 'rw',
	predicate => 1,
);

has type => (
	is => 'ro',
	isa => sub {
		die "type must be 'comment' or 'system'" unless grep { $_[0] eq $_ } qw( comment system );
	},
	predicate => 1,
);

has source => (
	is => 'rw',
	isa => sub {
		die "source must be web, email, mobile, api or unknown"
			unless grep { $_[0] eq $_ } qw( web email mobile api unknown );
	},
	predicate => 1,
);

has target => (
	is => 'rw',
	isa => sub {
		die "target must be a WWW::Asana::Task or WWW::Asana::Project"
			unless ref $_[0] eq 'WWW::Asana::Task' or ref $_[0] eq 'WWW::Asana::Project';
	},
	required => 1,
);

has created_by => (
	is => 'rw',
	isa => sub {
		die "created_by must be a WWW::Asana::User" unless ref $_[0] eq 'WWW::Asana::User';
	},
	predicate => 1,
);

has created_at => (
	is => 'rw',
	isa => sub {
		die "created_at must be a DateTime" unless ref $_[0] eq 'DateTime';
	},
	predicate => 1,
);

1;
