package WWW::Asana::User;
# ABSTRACT: Asana User Class

use MooX qw(
	+WWW::Asana::Workspace
);

with 'WWW::Asana::Role::HasClient';
with 'WWW::Asana::Role::CanReload';
with 'WWW::Asana::Role::CanUpdate';
with 'WWW::Asana::Role::HasResponse';

sub own_base_args { 'users', shift->id }

sub reload_base_args { 'User', 'GET' }

has id => (
	is => 'ro',
	required => 1,
);

has name => (
	is => 'ro',
	required => 1,
);

has email => (
	is => 'ro',
	predicate => 'has_email',
);

has workspaces => (
	is => 'ro',
	isa => sub {
		die "workspaces must be an ArrayRef" unless ref $_[0] eq 'ARRAY';
		die "workspaces must be an ArrayRef of WWW::Asana::Workspace" if grep { ref $_ ne 'WWW::Asana::Workspace' } @{$_[0]};
	},
	predicate => 'has_workspaces',
);

sub new_from_response {
	my ( $class, $data ) = @_;
	my @workspaces;
	if (defined $data->{workspaces}) {
		for (@{$data->{workspaces}}) {
			push @workspaces, WWW::Asana::Workspace->new_from_response(
				%{$_},
				defined $data->{client} ? ( client => $data->{client} ) : (),
				response => $data->{response},
			);
		}
		delete $data->{workspaces};
	}
	return $class->new(
		%{$data},
		@workspaces ? (workspaces => \@workspaces) : (),
	);
}

1;
