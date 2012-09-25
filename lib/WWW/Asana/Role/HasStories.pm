package WWW::Asana::Role::HasStories;
# ABSTRACT: Role for Asana classes which have stories

use MooX::Role;

=method stories

Get an arrayref of L<WWW::Asana::Story> objects from the object

=cut

sub stories {
	my ( $self ) = @_;
	$self->do('[Story]', 'GET', $self->own_base_args, 'stories', sub { target => $self });
}

=method create_story

Adds the given first parameter as comment to the object, it gives back a
L<WWW::Asana::Story> of the resulting story.

=cut

sub create_story {
	my ( $self, @args ) = @_;
	unshift @args, 'text';
	$self->do('Story', 'POST', $self->own_base_args, 'stories', { @args }, sub { target => $self });
}

=method comment

Shortcut for L</create_story>

=cut

sub comment { shift->create_story(@_) }

1;