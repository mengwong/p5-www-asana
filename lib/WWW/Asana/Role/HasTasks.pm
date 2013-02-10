package WWW::Asana::Role::HasTasks;
# ABSTRACT: Role for Asana classes which have tasks. Projects and Workspace+Assignees do.

use MooX::Role;

requires qw(workspace);

sub tasks {
	my $self = shift;
	$self->do('[Task]', 'GET', $self->own_base_args, 'tasks', sub { workspace => $self->workspace });
}

1;
