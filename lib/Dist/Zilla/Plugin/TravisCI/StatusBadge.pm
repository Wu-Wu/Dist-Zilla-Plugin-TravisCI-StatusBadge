package Dist::Zilla::Plugin::TravisCI::StatusBadge;

# ABSTRACT: Get Travis CI status badge for your dist

use strict;
use warnings;
use Moose;
use namespace::autoclean;

with qw(
    Dist::Zilla::Role::Plugin
    Dist::Zilla::Role::InstallTool
);

has readme => (
    is      => 'rw',
    isa     => 'Str',
    default => sub { 'README.md' },
);

has user => (
    is          => 'rw',
    isa         => 'Str',
    required    => 1,
);

has repo => (
    is          => 'rw',
    isa         => 'Str',
    required    => 1,
);

sub setup_installer {
    my ($self) = @_;

    my $edited;
    my $readme = first { $_->name eq $self->readme } @{ $self->zilla->files } or return;

    foreach my $line (split /\n/, $readme->content) {
        if ($line =~ /^# VERSION/) {
            $line .= "\n" . sprintf(
                '[![build status](https://secure.travis-ci.org/%s/%s.png)](https://travis-ci.org/%s/%s)' =>
                ($self->user, $self->repo) x 2
            );
        }
        $edited .= $line . "\n";
    }

    $readme->content($edited);
}

__PACKAGE__->meta->make_immutable;

1; # End of Dist::Zilla::Plugin::TravisCI::StatusBadge

__END__

=pod

=cut
