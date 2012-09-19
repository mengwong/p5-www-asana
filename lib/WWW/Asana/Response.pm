package WWW::Asana::Response;
# ABSTRACT: Asana Response Class

use MooX qw(
	+WWW::Asana::Error
	+JSON
);

use Class::Load ':all';

has http_response => (
	is => 'ro',
	required => 1,
	handles => [qw(
		is_success
		code
	)],
);

has to => (
	is => 'ro',
	required => 1,
);

has errors => (
	is => 'ro',
	lazy => 1,
	builder => 1,
);

sub has_errors { !shift->is_success }

sub _build_errors {
	my ( $self ) = @_;
	return [] unless $self->has_errors;
	my @errors;
	if (defined $self->json_decoded_body->{errors}) {
		for (@{$self->json_decoded_body->{errors}}) {
			push @errors, WWW::Asana::Error->new(
				message => $_->{message},
				defined $_->{phrase} ? ( phrase => $_->{phrase} ) : (),
			);
		}
	}
	return \@errors;
}

has status_error_message => (
	is => 'ro',
	lazy => 1,
	builder => 1,
);

sub _build_status_error_message {
	my ( $self ) = @_;
	return if $self->is_success;
	return "Invalid request" if $self->code == 400;
	return "No authorization" if $self->code == 401;
	return "Access denied" if $self->code == 403;
	return "Not found" if $self->code == 404;
	return "Rate Limit Enforced" if $self->code == 429;
	return "Server error" if $self->code == 500;
}

has json => (
	is => 'ro',
	lazy => 1,
	builder => 1,
);

sub _build_json {
	my $json = JSON->new;
	$json->allow_nonref;
	return $json;
}

has json_decoded_body => (
	is => 'ro',
	lazy => 1,
	builder => 1,
);

sub _build_json_decoded_body {
	my ( $self ) = @_;
	$self->json->decode(shift->http_response->content)
}

has data => (
	is => 'ro',
	lazy => 1,
	builder => 1,
);

sub _build_data { shift->json_decoded_body->{data} }

sub BUILDARGS {
	my ( $class, @args ) = @_;
	my $http_response = shift @args;
	my $to = shift @args;
	return { http_response => $http_response, to => $to, @args };
}

has result => (
	is => 'ro',
	lazy => 1,
	builder => 1,
);

sub _build_result {
	my ( $self ) = @_;
	my $class = 'WWW::Asana::'.$self->to;
	load_class($class) unless is_class_loaded($class);
	$class->new_from_response($self->data);
}

1;
