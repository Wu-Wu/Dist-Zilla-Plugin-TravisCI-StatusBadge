package Dist::Zilla::Plugin::TravisCI::StatusBadge;

# ABSTRACT: Get Travis CI status badge for your markdown README

use strict;
use warnings;
use Moose;
use namespace::autoclean;

# VERSION
# AUTHORITY

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

=head1 SYNOPSIS

    ; in dist.ini
    [TravisCI::StatusBadge]
    user = johndoe
    repo = p5-John-Doe-Stuff

=head1 DESCRIPTION

Scans dist files if a C<README.md> file has found, a Travis CI 'build status' badge will be added after B<VERSION> header.
Use L<Dist::Zilla::Plugin:::ReadmeAnyFromPod> in markdown mode or any other plugin to generate README.md.

=head1 OPTIONS

=head2 readme

The name of file to inject build status badge. Default value is C<README.md>.

=head2 user

Travis CI username. Required.

=head2 repo

Travis CI repository name. Required.

=head1 SEE ALSO

L<https://travis-ci.org>

L<Dist::Zilla::Plugin:::ReadmeAnyFromPod>

L<Dist::Zilla>

=cut
