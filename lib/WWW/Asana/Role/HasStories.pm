package WWW::Asana::Role::HasStories;

use MooX::Role;

sub stories {
	my ( $self ) = @_;
	$self->do('[Story]', 'GET', $self->own_base_args, 'stories', sub { target => $self });
}

1;