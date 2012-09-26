package WWW::Asana::Role::CanUpdate;
# ABSTRACT: Role for Asana classes which can be updated

use MooX::Role;

requires qw(
	update_args
);

sub update {
	my $self = shift;
	$self->do($self->update_args(@_));
}

1;