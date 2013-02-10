package WWW::Asana::Role::NewFromResponse;
# ABSTRACT: Role which implements new_from_response for Asana classes

use MooX::Role;
use DateTime::Format::ISO8601;
use Class::Load ':all';

=method new_from_response

This function converts the data which is get from Asana into the required
attributes for generation of the given class. The first parameter must be
a HashRef. This HashRef can be spiced with B<client> and B<response> to give
a client which is able to handle the B<do> function, or to reflect the
response which leaded to this object.

The B<client> attribute is required if you want todo any calls to the Asana
API.

=cut

sub new_from_response {
	my ( $class, $data ) = @_;
	die "First parameter to new_From_response need to be a HashRef" unless ref $data eq 'HASH';
	my %data = %{$data};
	my $newobj;
	
	use Carp qw(cluck);
	if (not $data{client}) { cluck "*** NewFromResponse instantiating $class id $data{id} with no client!" }
	elsif ($data{client}->singleton_instance) {
#		warn "*** NewFromResponse: $class called in singleton_instance mode.\n";
		if ($data{client}->singleton_cache->{$class}->{$data{id}}) {
			warn " ** NewFromResponse: found $class $data{id} in cache! loading it. " . $data{client}->singleton_cache->{$class}->{$data{id}} . "\n";
			$newobj = $data{client}->singleton_cache->{$class}->{$data{id}};
		}
	}

	my %multi_mapping = (
		followers => 'WWW::Asana::User',
		workspaces => 'WWW::Asana::Workspace',
		projects => 'WWW::Asana::Project',
		tags => 'WWW::Asana::Tag',
	);
	my @needs_workspace = qw( projects tags parent );
	my %single_mapping = (
		assignee => 'WWW::Asana::User',
		workspace => 'WWW::Asana::Workspace',
		created_by => 'WWW::Asana::User',
		parent => 'WWW::Asana::Task',
	);
	my %new = %data;
	# single mapping before multi mapping so that workspace is already there
	for my $key (keys %single_mapping) {
		if (exists $data{$key}) {
			if ($data{$key}) {
				my $target_class = $single_mapping{$key};
				load_class($target_class) unless is_class_loaded($target_class);
				$new{$key} = $target_class->new_from_response({
					%{$data{$key}},
					defined $data{client} ? ( client => $data{client} ) : (),
					(grep { $_ eq $key } @needs_workspace) ? ( workspace => $new{workspace} ) : (),
					response => $data{response},
				});
			} else {
				delete $new{$key};
			}
		}
	}
	for my $key (keys %multi_mapping) {
		if (exists $data{$key}) {
			$new{$key} = [];
			my $target_class = $multi_mapping{$key};
			for (@{$data{$key}}) {
				load_class($target_class) unless is_class_loaded($target_class);
				push @{$new{$key}}, $target_class->new_from_response({
					%{$_},
					defined $data{client} ? ( client => $data{client} ) : (),
					(grep { $_ eq $key } @needs_workspace) ? ( workspace => $new{workspace} ) : (),
					response => $data{response},
				});
			}
		}
	}
	for my $key (qw( completed_at modified_at created_at due_on )) {
		if (exists $data{$key}) {
			if ($data{$key}) {
				$new{$key} = DateTime::Format::ISO8601->parse_datetime($data{$key});
			} else {
				delete $new{$key};
			}
		}
	}
	if ($newobj) {
		use warnings NONFATAL => 'all';
		# update the existing object with the latest response data
		while (my ($k,$v) = each %new) {
			next if grep ($k eq $_, qw(client id));
			my $has_k = "has_$k";
			next if (not defined $v and not $newobj->$has_k());
			if (not ref $v) {
				if ($newobj->$k ne $v) {
					warn "--> really updating cached $class @{[$newobj->id]} with $k=$v\n";
					$newobj->$k($v);
				} else {
					warn "-->        updating cached $class @{[$newobj->id]} with $k=$v\n";
				}
			} elsif (ref $v eq "ARRAY" and ref $newobj->$k eq "ARRAY") { # do a deepcopy style compare
				if (qq(@{$v}) ne qq(@{$newobj->$k})) {
					warn "--> really updating cached $class @{[$newobj->id]} with $k=$v\n";
					$newobj->$k($v);
				} else {
					warn "-->        updating cached $class @{[$newobj->id]} with $k=$v\n";
				}
			} else {
				if ($v ne $newobj->$k) {
					warn "--> really updating cached $class @{[$newobj->id]} with $k=$v\n";
					$newobj->$k($v);
				} else {
					warn "-->        updating cached $class @{[$newobj->id]} with $k=$v\n";
				}
			}
		}
		return $newobj;
	}
	else {
		my $toreturn = $class->new(%new);
		if ($data{client} and $data{client}->singleton_instance) {
			warn "  * NewFromResponse: created new $class instance with id $data{id}. Saving to cache as $toreturn.\n";
			$data{client}->singleton_cache->{$class}->{$toreturn->id} = $toreturn;
		}
		return $toreturn;
	}
}

1;
