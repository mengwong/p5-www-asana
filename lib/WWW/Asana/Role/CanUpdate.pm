package WWW::Asana::Role::CanUpdate;

use MooX::Role;

requires qw(
	own_base_args
	reload_base_args
);

sub update_args {
	my ( $self ) = @_;
	$self->update_base_args, $self->own_base_args;
}

sub update {
	die "TODO";
	my $self = shift;
	$self->do($self->update_args(@_));
}

1;