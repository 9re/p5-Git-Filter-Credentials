use strict;
use warnings;
use Test::More;

use Git::Filter::Credentials;

subtest with_no_config => sub {
    my $filter = Git::Filter::Credentials->new;
    #$filter->parse_config_file;
    my $num_keys = scalar(keys %{$filter->{config}});
    is $num_keys, 0, 'empty check';
};

subtest config => sub {
    my $filter = Git::Filter::Credentials->new(CONFIG_FILENAME => 't/02_config');
    #$filter->parse_config_file;
    my $conf = $filter->{config};
    is $conf->{config_file}, 'this';
    is $conf->{test}, 'settings';
    is $conf->{with}, '====\\====';
};

done_testing;