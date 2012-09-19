package WWW::Asana::Request;
# ABSTRACT: Asana Request Class

use MooX qw(
	+HTTP::Request
	+JSON
	+URI
	+URI::QueryParam
);

has api_key => (
	is => 'ro',
	required => 1,
);

has to => (
	is => 'ro',
	required => 1,
);

has uri => (
	is => 'ro',
	required => 1,
);

has data => (
	is => 'ro',
	predicate => 'has_data',
);

has method => (
	is => 'ro',
	default => sub { 'GET' }
);

has _http_request => (
	is => 'ro',
	lazy => 1,
	builder => 1,
);
sub http_request { shift->_http_request }

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

sub _build__http_request {
	my ( $self ) = @_;
	my @headers;
	my $uri;
	my $body;
	if ($self->has_data and $self->method eq 'GET') {
		my $u = URI->new($self->uri);
		$u->query_param(%{$self->data});
		$uri = $u->as_string;
	} else {
		$uri = $self->uri;
		if ($self->has_data) {
			push @headers, ('Content-type', 'application/json') if $self->has_data and $self->method ne 'GET';
			$body = self->json->encode($self->data);
		}
	}
	my $request = HTTP::Request->new(
		$self->method,
		$uri,
		\@headers,
		defined $body ? $body : (),
	);
	$request->authorization_basic($self->api_key,"");
	return $request;
}

1;
