package WWW::Asana::Role::CanCreate;
# ABSTRACT: Role for Asana classes which can be created

use MooX::Role;

requires qw(
	create_args
);

sub create {
	my $self = shift;
	die "The object already has an id, and so cant be created" if $self->has_id;
	$self->do($self->create_args(@_));
}

1;