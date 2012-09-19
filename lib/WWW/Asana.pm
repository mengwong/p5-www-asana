package WWW::Asana;

use MooX qw(
	+LWP::UserAgent
	+WWW::Asana::Response
	+WWW::Asana::Request
	+URI
);

use Class::Load ':all';

our $VERSION ||= '0.000';

=attr api_key

API Key for the account given on the Account Settings of your Asana (see under API)

=cut

has api_key => (
	is => 'ro',
	required => 1,
);

=attr version

Version of the API in use, so far only B<1.0> is supported and this is also the default value here.

=cut

has version => (
	is => 'ro',
	lazy => 1,
	builder => 1,
);

sub _build_version { '1.0' }

=attr base_uri

Base of the URL of the Asana API, the default value here is B<https://app.asana.com/api>.

=cut

has base_uri => (
	is => 'ro',
	lazy => 1,
	builder => 1,
);

sub _build_base_uri { 'https://app.asana.com/api' }

=attr useragent

L<LWP::UserAgent> object used for the HTTP requests.

=cut

has useragent => (
	is => 'ro',
	lazy => 1,
	builder => 1,
);

sub _build_useragent {
	my ( $self ) = @_;
	LWP::UserAgent->new(
		agent => $self->useragent_agent,
		$self->has_useragent_timeout ? (timeout => $self->useragent_timeout) : (),
	);
}

=attr useragent_agent

The user agent string used for the L</useragent> object.

=cut

has useragent_agent => (
	is => 'ro',
	lazy => 1,
	builder => 1,
);

sub _build_useragent_agent { (ref $_[0] ? ref $_[0] : $_[0]).'/'.$VERSION }

=attr useragent_timeout

The timeout value in seconds used for the L</useragent> object, defaults to default value of
L<LWP::UserAgent>.

=cut

has useragent_timeout => (
	is => 'ro',
	predicate => 'has_useragent_timeout',
);

sub BUILDARGS {
	my ( $class, @args ) = @_;
	unshift @args, "api_key" if @args == 1 && ref $args[0] ne 'HASH';
	return { @args };
}

=method request

Takes a L<WWW::Asana::Request> object and gives back a L<WWW::Asana::Response>. If not given a
L<WWW::Asana::Request>, then it will pass the arguments to L</get_request> to get one.

TODO: Adding an auto-retry option on reaching limits

=cut

sub request {
	my ( $self, @args ) = @_;
	my $request;
	if (ref $args[0] eq 'WWW::Asana::Request') {
		$request = $args[0];
	} else {
		$request = $self->get_request(@args);
	}
	my $http_response = $self->useragent->request($request->http_request);
	return WWW::Asana::Response->new($http_response);
}

=method get_url

Takes L</base_uri>, L</version> and the arguments and joins them together with B</>.

=cut

sub get_uri {
	my ( $self, @args ) = @_;
	return join('/',$self->base_uri,$self->version,@args);
}

=method get_request

Generates a L<WWW::Asana::Request> out of the parameter. The first parameter is the method to use for
the generated request, the other parameters are taken as part of the URL on the Asana API. If additional
is given a HashRef at the end of the parameters, then those are used as data for the request.

=cut

sub get_request {
	my ( $self, @args ) = @_;
	my $method = shift @args;
	my @path_parts;
	my %data;
	for (@args) {
		if (ref $_ eq 'HASH') {
			%data = %{$_};
		} else {
			push @path_parts, $_;
		}
	}
	my $uri = $self->get_uri(@path_parts);
	return WWW::Asana::Request->new(
		api_key => $self->api_key,
		uri => $uri,
		%data ? ( data => \%data ) : (),
	);
}

sub parse_into {
	my ( $self, $response, $target ) = @_;
	my $class = 'WWW::Asana::'.$target;
	load_class($class) unless is_class_loaded($class);
	$class->new_from_response($response->data);
}

sub do {
	my ( $self, @args ) = @_;
	my $target = shift @args;
	my $response = $self->request(@args);
	return $self->parse_into($response,$target);
}

=method me

Makes a request to B</users/me> and gives back a L<WWW::Asana::User> of yourself.

=cut

sub me { shift->do('User','GET','users','me') }

1;
