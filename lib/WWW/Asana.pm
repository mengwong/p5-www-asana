package WWW::Asana;

use MooX qw(
	+LWP::UserAgent
);

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

1;
