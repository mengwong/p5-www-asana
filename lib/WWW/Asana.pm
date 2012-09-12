package WWW::Asana;

use MooX;

=attr api_key

API Key for the account given on the Account Settings of your Asana (see under API)

=cut

has api_key => (
	is => 'ro',
	required => 1,
);

=attr workspace_id

The ID of the workspace this WWW::Asana should work on.

=cut

has workspace_id => (
	is => 'ro',
	required => 1,
);

=attr assignee_email

Email of the assignee

=cut

has assignee_email => (
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

1;
