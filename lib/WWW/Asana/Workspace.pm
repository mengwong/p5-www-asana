package WWW::Asana::Workspace;
# ABSTRACT: Asana Workspace Class

use MooX;

with 'WWW::Asana::Role::HasClient';
with 'WWW::Asana::Role::CanReload';
with 'WWW::Asana::Role::CanUpdate';
with 'WWW::Asana::Role::HasResponse';
with 'WWW::Asana::Role::NewFromResponse';

has id => (
	is => 'ro',
	required => 1,
);

has name => (
	is => 'ro',
	required => 1,
);

sub own_base_args { 'workspaces', shift->id }

sub reload_base_args { 'Workspace', 'GET' }
sub update_base_args { 'Workspace', 'PUT' }

sub tasks {
	my ( $self, $assignee ) = @_;
	die "tasks need a WWW::Asana::User as parameter" unless ref $assignee eq "WWW::Asana::User";
	$self->do('[Task]', 'GET', $self->own_base_args, 'tasks', [ assignee => $assignee->id ]);
}

1;
