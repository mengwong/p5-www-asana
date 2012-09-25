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
sub update_base_args { 'Workspace', 'PUT' }

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
	], sub { workspace => $self });
}

=method create_tag

Adds the given first parameter as new tag for the workspace, it gives back a
L<WWW::Asana::Tag> of the resulting tag.

=cut

sub create_tag {
	my ( $self, $name ) = @_;
	if (ref $name eq 'WWW::Asana::Tag') {
		die "Given WWW::Asana::Tag has id, and so is already created" if $name->has_id;
		$name = $name->name;
	}
	$self->do('Tag', 'POST', $self->own_base_args, 'tags', { name => $name });
}

1;
