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
	my %data;
	my $to = $self->to;
	if ($to eq 'Task' or $to eq '[Task]') {
		$data{expand} = join(',',qw(
			followers
		));
	} elsif ($to eq 'User' or $to eq '[User]') {
		$data{fields} = join(',',qw(
			name
			email
		));
		$data{expand} = join(',',qw(
			workspaces
		));
	}
	if ($self->has_data) {
		$data{$_} = $self->data->{$_} for (keys %{$self->data});
	}
	use DDP; p(%data);
	my @headers;
	my $uri;
	my $body;
	if ($self->method eq 'GET') {
		my $u = URI->new($self->uri);
		$u->query_param(\%data);
		$uri = $u->as_string;
	} else {
		push @headers, ('Content-type', 'application/json');
		$body = $self->json->encode($self->data);
	 	$uri = $self->uri;
	}
	my $request = HTTP::Request->new(
		$self->method,
		$uri,
		\@headers,
		defined $body ? $body : (),
	);
	$request->authorization_basic($self->api_key,"");
	use DDP; p($request->uri->as_string); p($request->content);
	return $request;
}

1;
