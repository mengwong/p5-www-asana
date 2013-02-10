package WWW::Asana::Workspace;
# ABSTRACT: Asana Workspace Class

use MooX;

with 'WWW::Asana::Role::HasClient';
with 'WWW::Asana::Role::HasResponse';
with 'WWW::Asana::Role::NewFromResponse';

with 'WWW::Asana::Role::CanReload';
with 'WWW::Asana::Role::CanUpdate';
# CanNotCreate
# CanNotDelete

sub own_base_args { 'workspaces', shift->id }
sub reload_base_args { 'Workspace', 'GET' }
sub update_args {
	my ( $self ) = @_;
	'Workspace', 'PUT', $self->own_base_args, {
		name => $self->name
	}
}

sub opt_fields { qw( name ) }

use WWW::Asana::Task;

=attr id
=cut

has id => (
	is => 'ro',
	required => 1,
);

=attr name
=cut

has name => (
	is => 'ro',
	required => 1,
);

=method tasks

This method shows the tasks of the given assignee. This must be a
L<WWW::Asana::User> object, or you just give "me", to show that you this
information for the API Key user.

It is required to give an assignee, Asana is not supporting giving all tasks
of the workspace.

=cut

sub tasks {
	my ( $self, $assignee ) = @_;
	die 'tasks need a WWW::Asana::User or "me" as parameter' unless ref $assignee eq "WWW::Asana::User" or $assignee eq "me";
	$self->do('[Task]', 'GET', $self->own_base_args, 'tasks', [
		assignee => ref $assignee eq "WWW::Asana::User" ? $assignee->id : $assignee,
	], sub { my ( %data ) = @_; defined $data{workspace} ? () : ( workspace => $self ) });
}

=method projects

This method shows the projects of the workspace.

=cut

sub projects {
	my ( $self ) = @_;
	$self->do('[Project]', 'GET', $self->own_base_args, 'projects', sub { workspace => $self });
}

=method tags

This method shows the tags of the workspace.

=cut

sub tags {
	my ( $self ) = @_;
	$self->do('[Tag]', 'GET', $self->own_base_args, 'tags', sub { workspace => $self });
}

=method create_tag({name => "tag name", notes=>"tag notes", ...} | "just the tag name")

Adds the given first parameter as new tag for the workspace. It gives back a
L<WWW::Asana::Tag> of the resulting tag.

=cut

sub create_tag {
	my ( $self, $arg ) = @_;
	$arg = { name => $arg } if not ref $arg;
	unless (ref $arg eq "HASH") { die "create_tag() expects a hash of name=>..., notes=>..."; }
	$arg->{workspace} = $self;
	$arg->{client} = $self->client if $self->has_client;
	return WWW::Asana::Tag->new(%$arg)->create;
}

=method create_task

Adds a new task to the workspace.

=cut

sub create_task {
	my ( $self, $attr ) = @_;
	die __PACKAGE__."->new_task needs a HashRef as parameter" unless ref $attr eq 'HASH';
	my %data = %{$attr};
	$data{workspace} = $self;
	$data{client} = $self->client if $self->has_client;
	return WWW::Asana::Task->new(%data)->create;
}

1;
