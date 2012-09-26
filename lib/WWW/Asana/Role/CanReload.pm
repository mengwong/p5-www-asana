package WWW::Asana::Role::CanReload;
# ABSTRACT: Role for Asana classes which can be reloaded

use MooX::Role;

requires qw(
	own_base_args
	reload_base_args
);

sub reload_args {
	my ( $self ) = @_;
	$self->reload_base_args, $self->own_base_args;
}

sub reload {
	my $self = shift;
	$self->do($self->reload_args(@_));
}

1;