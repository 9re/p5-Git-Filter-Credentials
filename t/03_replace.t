use strict;
use warnings;
use Test::More;

use Data::Dumper;
use Git::Filter::Credentials;

subtest replace => sub {
    my $filter = Git::Filter::Credentials->new(CONFIG_FILENAME => 't/03_replace');
    
    is('a',
       $filter->replace('a'),
       'trivial test');
       
    is($filter->replace(q{#define CLIENT_TOKEN <CLIENT_TOKEN>
#define CLIENT_SECRET <CLIENT_SECRET>}),
	q{#define CLIENT_TOKEN "the real client token!!"
#define CLIENT_SECRET "the real client secret!!"},
       'replace test');

    # check $_ propery processed
    $_ = $filter->replace(q{#define CLIENT_TOKEN <CLIENT_TOKEN>});
    is($_, q{#define CLIENT_TOKEN "the real client token!!"}, 'check for one liner');
};

subtest unreplace => sub {
    my $filter = Git::Filter::Credentials->new(CONFIG_FILENAME => 't/03_replace');
    
    is('a',
       $filter->unreplace('a'),
       'trivial test');
       
    is($filter->unreplace(q{#define CLIENT_TOKEN "the real client token!!"
#define CLIENT_SECRET "the real client secret!!"}),
       q{#define CLIENT_TOKEN <CLIENT_TOKEN>
#define CLIENT_SECRET <CLIENT_SECRET>},
       'replace test');

    # check $_ propery processed
    $_ = $filter->unreplace(q{#define CLIENT_TOKEN "the real client token!!"});
    is($_, q{#define CLIENT_TOKEN <CLIENT_TOKEN>}, 'check for one liner');
};

done_testing;