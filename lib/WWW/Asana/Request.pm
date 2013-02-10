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

has to_type => (
	is => 'ro',
	lazy => 1,
	builder => 1,
);

sub _build_to_type {
	my ( $self ) = @_;
	if ( $self->to =~ /\[(\w+)\]/ ) {
		return $1;
	} else {
		return $self->to;	
	}
}

use Class::Load ':all';

has to_multi => (
	is => 'ro',
	lazy => 1,
	builder => 1,
);

sub _build_to_multi {
	my ( $self ) = @_;
	if ( $self->to =~ /\[(\w+)\]/ ) {
		return 1;
	} else {
		return 0;	
	}
}

has uri => (
	is => 'ro',
	required => 1,
);

has data => (
	is => 'ro',
	predicate => 'has_data',
);

has params => (
	is => 'ro',
	predicate => 'has_params',
);

has codes => (
	is => 'ro',
	predicate => 'has_codes',
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
	%data = %{$self->data} if $self->has_data;
	my @params;
	@params = @{$self->params} if $self->has_params;
	if ($self->to_multi) {
		my $type = $self->to_type;
		my $target_class = "WWW::Asana::$type";
		load_class($target_class) unless is_class_loaded($target_class);
		if ($target_class->can("opt_fields")) {
			push @params, [ opt_fields => join(',',$target_class->opt_fields()) ];
		}
	}
	if ($self->has_data) {
		$data{$_} = $self->data->{$_} for (keys %{$self->data});
	}
	my @headers;
	my $uri;
	my $body;
	my $u = URI->new($self->uri);
	$u->query_param(@{$_}) for @params;
	$uri = $u->as_string;
	if ($self->method ne 'GET') {
		push @headers, ('Content-type', 'application/json');
		$body = $self->json->encode({ data => $self->data });
	} elsif (%data) {
		warn 'Request includes %data but is a GET request';
	}
	my $request = HTTP::Request->new(
		$self->method,
		$uri,
		\@headers,
		defined $body ? $body : (),
	);
	$request->authorization_basic($self->api_key,"");

	# use DDP;
	# p($self->method);
	# p($uri);
	# p($body);

	# p(%data);
	# p(@params);
	# p($request->uri->as_string);
	# p($request->content);

	return $request;
}

1;
