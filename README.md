# NAME

Dist::Zilla::Plugin::TravisCI::StatusBadge - Get Travis CI status badge for your markdown README

# VERSION

version 0.002

# SYNOPSIS

    ; in dist.ini
    [TravisCI::StatusBadge]
    user = johndoe
    repo = p5-John-Doe-Stuff

# DESCRIPTION

Scans dist files if a `README.md` file has found, a Travis CI 'build status' badge will be added before the __VERSION__ header.
Use [Dist::Zilla::Plugin:::ReadmeAnyFromPod](http://search.cpan.org/perldoc?Dist::Zilla::Plugin:::ReadmeAnyFromPod) in markdown mode or any other plugin to generate README.md.

# OPTIONS

## readme

The name of file to inject build status badge. Default value is `README.md`.

## user

Travis CI username. Required.

## repo

Travis CI repository name. Required.

# SEE ALSO

[https://travis-ci.org](https://travis-ci.org)

[Dist::Zilla::Plugin:::ReadmeAnyFromPod](http://search.cpan.org/perldoc?Dist::Zilla::Plugin:::ReadmeAnyFromPod)

[Dist::Zilla](http://search.cpan.org/perldoc?Dist::Zilla)

# AUTHOR

Anton Gerasimov <chim@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Anton Gerasimov.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.