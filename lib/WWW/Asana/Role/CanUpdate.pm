package WWW::Asana::Role::CanUpdate;

use MooX::Role;

requires qw(
	update_args
);

sub update {
	my $self = shift;
	$self->do($self->update_args(@_));
}

1;