package WWW::Asana::Story;
# ABSTRACT: Asana Story Class

use MooX;

with 'WWW::Asana::Role::HasClient';

has id => (
	is => 'ro',
	required => 1,
);

has text => (
	is => 'ro',
	required => 1,
);

has type => (
	is => 'ro',
	isa => sub {
		die "type must be 'comment' or 'system'" unless grep { $_[0] eq $_ } qw( comment system );
	},
	required => 1,
);

has source => (
	is => 'ro',
	isa => sub {
		die "source must be web, email, mobile, api or unknown"
			unless grep { $_[0] eq $_ } qw( web email mobile api unknown );
	},
	required => 1,
);

has target => (
	is => 'ro',
	isa => sub {
		die "target must be a WWW::Asana::Task or WWW::Asana::Project"
			unless ref $_[0] eq 'WWW::Asana::Task' or ref $_[0] eq 'WWW::Asana::Project';
	},
	required => 1,
);

has created_by => (
	is => 'ro',
	isa => sub {
		die "created_by must be a WWW::Asana::User" unless ref $_[0] eq 'WWW::Asana::User';
	},
	required => 1,
);

has created_at => (
	is => 'ro',
	isa => sub {
		die "created_at must be a DateTime" unless ref $_ eq 'DateTime';
	},
	required => 1,
);

1;
