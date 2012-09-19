package WWW::Asana::User;
# ABSTRACT: Asana User Class

use MooX qw(
	+WWW::Asana::Workspace
);

with 'WWW::Asana::Role::HasClient';

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
	required => 1,
);

has workspaces => (
	is => 'ro',
	isa => sub {
		die "workspaces must be an ArrayRef" unless ref $_[0] eq 'ARRAY';
		die "workspaces must be an ArrayRef of WWW::Asana::Workspace" if grep { ref $_ ne 'WWW::Asana::Workspace' } @{$_[0]};
	},
	default => sub {[]},
);

sub new_from_response {
	my ( $class, $data ) = @_;
	my @workspaces;
	for (@{$data->{workspaces}}) {
		push @workspaces, WWW::Asana::Workspace->new_from_response($_);
	}
	delete $data->{workspaces};
	return $class->new(
		%{$data},
		workspaces => \@workspaces,
	);
}

1;
