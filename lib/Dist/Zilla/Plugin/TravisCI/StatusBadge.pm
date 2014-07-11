package Dist::Zilla::Plugin::TravisCI::StatusBadge;

# ABSTRACT: Get Travis CI status badge for your markdown README

use strict;
use warnings;
use Path::Tiny 0.004;
use Encode qw(encode);
use Moose;
use namespace::autoclean;
use Dist::Zilla::File::OnDisk;

# VERSION
# AUTHORITY

with qw(
    Dist::Zilla::Role::AfterBuild
);

has readme => (
    is      => 'rw',
    isa     => 'Str',
    default => sub { 'README.md' },
);

has user => (
    is      => 'rw',
    isa     => 'Str',
    default => sub { '' },
);

has repo => (
    is      => 'rw',
    isa     => 'Str',
    default => sub { '' },
);

sub after_build {
    my ($self) = @_;

    if ($self->user eq '' || $self->repo eq '') {
        $self->log("Missing option: user or repo.");
        return;
    }

    my $file  = $self->zilla->root->file($self->readme);

    if (-e $file) {
        $self->log("Override " . $self->readme . " in root directory.");
        my $readme = Dist::Zilla::File::OnDisk->new(name => "$file");

        my $edited;

        foreach my $line (split /\n/, $readme->content) {
            if ($line =~ /^# VERSION/) {
                $self->log("Inject build status badge");
                $line = join '' =>
                    sprintf(
                        "[![Build Status](https://travis-ci.org/%s/%s.png?branch=master)](https://travis-ci.org/%s/%s)\n\n" =>
                        ($self->user, $self->repo) x 2
                    ),
                    $line;
            }
            $edited .= $line . "\n";
        }

        my $encoding =
            $readme->can('encoding')
                ? $readme->encoding
                : 'raw'                             # Dist::Zilla pre-5.0
                ;

        Path::Tiny::path($file)->spew_raw(
            $encoding eq 'raw'
                ? $edited
                : encode($encoding, $edited)
        );
    }
    else {
        $self->log("Not found " . $self->readme . " in root directory.");
        return;
    }

    return;
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

Scans dist files if a C<README.md> file has found, a Travis CI C<build status> badge will be added before the B<VERSION> header.
Use L<Dist::Zilla::Plugin::ReadmeAnyFromPod> in markdown mode or any other plugin to generate README.md.

=head1 OPTIONS

=head2 readme

The name of file to inject build status badge. Default value is C<README.md>.

=head2 user

Github username. Required.

=head2 repo

Github repository name. Required.

=head1 SEE ALSO

L<https://travis-ci.org>

L<Dist::Zilla::Plugin::ReadmeAnyFromPod>

L<Dist::Zilla>

=cut
