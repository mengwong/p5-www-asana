#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

if (defined $ENV{WWW_ASANA_TEST_API_KEY}) {

	use_ok('WWW::Asana');

	my $asana = WWW::Asana->new($ENV{WWW_ASANA_TEST_API_KEY});

	my $me = $asana->me;
	ok(ref $me eq 'WWW::Asana::User','Testing "me", you are: '.$me->name);

	my $users_result = $asana->users;
	ok(ref $users_result eq 'ARRAY','Result of "users" is ARRAY');
	for (@{$users_result}) {
		isa_ok($_,'WWW::Asana::User','"'.$_->name.'"');
		ok($_->has_email, 'has email');
	}

	sleep 1;

	my $current_me = $me->reload;
	isa_ok($current_me, 'WWW::Asana::User','Result of reload of User from "me" test');

	is($current_me->id, $me->id, "Comparing id of new me and old me");
	is($current_me->name, $me->name, "Comparing name of new me and old me");
	is($current_me->email, $me->email, "Comparing email of new me and old me");

	# needs to get fixed
	#cmp_ok($current_me->response->http_response->current_age, '<', $me->response->http_response->current_age,
	#	"Old me http_response is older then new me http_response");

	my $workspaces_ref = $me->workspaces;

	isa_ok($workspaces_ref,'ARRAY','Result of $me->workspaces');

	for (@{$workspaces_ref}) {
		isa_ok($_,'WWW::Asana::Workspace','"'.$_->name.'"');
		my $tasks_ref = $_->tasks($current_me);
		isa_ok($tasks_ref,'ARRAY','Result of $workspace->tasks with $me on "'.$_->name.'"');
		for (@{$tasks_ref}) {
			isa_ok($_,'WWW::Asana::Task','"'.$_->name.'"');
			my $stories_ref = $_->stories;
			isa_ok($stories_ref,'ARRAY','Result of $task->stories on "'.$_->name.'"');
			for (@{$stories_ref}) {
				isa_ok($_,'WWW::Asana::Story',$_->source.' '.$_->type);
			}
		}
	}

} else {
	plan skip_all => 'Not doing live tests without WWW_ASANA_TEST_API_KEY ENV variable';
}

done_testing;