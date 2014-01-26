use strict;
use warnings;
use Test::More;

use Git::Filter::Credentials;

subtest default => sub {
    my $filter = Git::Filter::Credentials->new;
    isa_ok $filter, 'Git::Filter::Credentials';
    is $filter->{CONFIG_FILENAME}, '.git.filter.credentials', 'default config filename';
};

subtest params => sub {
    my $custom_config = '.my.filter.conf';
    my $filter = Git::Filter::Credentials->new(CONFIG_FILENAME => $custom_config);
    is $filter->{CONFIG_FILENAME}, $custom_config, 'default config filename';
};

done_testing;
