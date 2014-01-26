package Git::Filter::Credentials;
use 5.008005;
use strict;
use warnings;
use File::Spec;
use String::Replace::Safe;

use constant CONFIG_FILENAME => '.git.filter.credentials';

our $VERSION = '0.00';

sub new {
    my $class = shift;
    my %args = @_;
    my $provided = \%args;
    # the default values
    my $self = {
	CONFIG_FILENAME => CONFIG_FILENAME
    };
    # override defaults if provided
    foreach my $key(keys %$self) {
	my $arg = $provided->{$key};
	$self->{$key} = $arg if $arg;
    }
    
    bless $self, $class;
    
    $self->parse_config_file;

    return $self;
}

sub git_root {
    my $git_root = `git rev-parse --show-toplevel`;
    chomp $git_root;
    return $git_root;
}

sub _take_argument {
    my ($self, $text) = @_;
    my $one_liner = 0;
    if (scalar(@_) == 1) {
	# take $_ as an argument
	$text = $_;
	$one_liner = 1;
    }
    return ($self, $text, $one_liner);
}

sub _has_replacement {
    my ($self) = @_;
    return scalar keys %{$self->{config}};
}

sub replace {
    my ($self, $text, $one_liner) = _take_argument(@_);
    return $text unless $self->_has_replacement;

    my $replacement = String::Replace::Safe::replace($text, $self->{config});
    if ($one_liner) {
	$_ = $replacement;
    }
    return $replacement;
}

sub unreplace {
    my ($self, $text, $one_liner) = _take_argument(@_);
    return $text unless $self->_has_replacement;

    my $replacement = String::Replace::Safe::unreplace($text, $self->{config});
    if ($one_liner) {
	$_ = $replacement;
    }
    return $replacement;
}

sub parse_config_file {
    my ($self) = @_;
    my $file = File::Spec->catfile(
	$self->git_root(),
	$self->{CONFIG_FILENAME});
    my $conf = {};

    if (-e $file) {
	open my $fh, '<', $file or die "$file $!";

	while (<$fh>) {
	    chomp;
	    my $index = index($_, '=');
	    if ($index > -1)
	    {
		my $key = substr($_, 0, $index);
		my $value = substr($_, $index + 1);
		$conf->{$key} = $value;
	    }
	}

	close $fh;
    }

    $self->{config} = $conf;
}


1;
__END__

=encoding utf-8

=head1 NAME

Git::Filter::Credentials - Git Credential Filter written by perl5

=head1 INSTALL

=begin html

<pre>
$ minil install
</pre>

=end html

=head1 DESCRIPTION

This is the L<example repo proejct|https://github.com/9re/git-filter-credentials-test>. More detailed description is also available there.

=head1 LICENSE

Copyright (C) Taro Kobayashi.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Taro Kobayashi E<lt>9re.3000@gmail.comE<gt>

=cut

