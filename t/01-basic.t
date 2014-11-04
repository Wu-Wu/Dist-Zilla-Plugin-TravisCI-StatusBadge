use Test::Spec;
use Test::Exception;
use Test::DZil;

my $README_MD = <<"END_README_MD";
# NAME

Foo::Bar - Foo and Bar

# VERSION

version 0.001

# SYNOPSIS

    use Foo::Bar;

# DESCRIPTION
Tellus proin aptent mattis vel pulvinar, et dui netus tellus.

Habitant ipsum nisl ad feugiat orci suscipit et sodales sodales.

Aliquam conubia sodales malesuada scelerisque, faucibus orci dapibus senectus eget.

END_README_MD

my $builder = sub {
    Builder->from_config(
        { dist_root => 'corpus/dist/DZT' },
        {
            add_files => {
                'source/README.md'  => $README_MD,
                'source/dist.ini'   => simple_ini( 'GatherDir', @_ ),
            }
        },
    );
};

describe "TravisCI::StatusBadge" => sub {
    it "should compile ok" => sub {
        use_ok( 'Dist::Zilla::Plugin::TravisCI::StatusBadge' );
    };

    describe "when missed" => sub {
        describe "both user and repo" => sub {
            my ( $tzil );

            before all => sub {
                $tzil = $builder->(
                    [ 'TravisCI::StatusBadge' => {} ]
                )
            };

            it "should build dist" => sub {
                lives_ok { $tzil->build; };
            };

            it "should not contains a badge" => sub {
                my $content = eval { $tzil->slurp_file( 'source/README.md' ); };

                like(
                    $content,
                    qr{[^\Q[![Build Status]\E]},
                );
            };
        };

        describe "an user" => sub {
            my ( $tzil );

            before all => sub {
                $tzil = $builder->(
                    [ 'TravisCI::StatusBadge' => { repo => 'p5-John-Doe' } ]
                )
            };

            it "should build dist" => sub {
                lives_ok { $tzil->build; };
            };

            it "should not contains a badge" => sub {
                my $content = eval { $tzil->slurp_file( 'source/README.md' ); };

                like(
                    $content,
                    qr{[^\Q[![Build Status]\E]},
                );
            };
        };

        describe "a repo" => sub {
            my ( $tzil );

            before all => sub {
                $tzil = $builder->(
                    [ 'TravisCI::StatusBadge' => { user => 'johndoe' } ]
                )
            };

            it "should build dist" => sub {
                lives_ok { $tzil->build; };
            };

            it "should not contains a badge" => sub {
                my $content = eval { $tzil->slurp_file( 'source/README.md' ); };

                like(
                    $content,
                    qr{[^\Q[![Build Status]\E]},
                );
            };
        };
    };

    describe "when wrong README" => sub {
        my ( $tzil );

        before all => sub {
            $tzil = $builder->(
                [
                    'TravisCI::StatusBadge' => {
                        repo    => 'p5-John-Doe',
                        user    => 'johndoe',
                        readme  => 'README.markdown'
                    }
                ]
            )
        };

        it "should build dist" => sub {
            lives_ok { $tzil->build; };
        };

        it "should not contains a badge" => sub {
            my $content = eval { $tzil->slurp_file( 'source/README.md' ); };

            like(
                $content,
                qr{[^\Q[![Build Status]\E]},
            );
        };
    };

    describe "otherwise" => sub {
        describe "when user and repo" => sub {
            my ( $tzil );

            before all => sub {
                $tzil = $builder->(
                    [
                        'TravisCI::StatusBadge' => {
                            repo    => 'p5-John-Doe',
                            user    => 'johndoe',
                        }
                    ]
                )
            };

            it "should build dist" => sub {
                lives_ok { $tzil->build; };
            };

            it "should contains a badge" => sub {
                my $content = eval { $tzil->slurp_file( 'source/README.md' ); };

                like(
                    $content,
                    qr{\Q[![Build Status]\E.*travis-ci\.org.*master.*johndoe/p5-John-Doe.*},
                );
            };
        };

        describe "when branch" => sub {
            my ( $tzil );

            before all => sub {
                $tzil = $builder->(
                    [
                        'TravisCI::StatusBadge' => {
                            repo    => 'p5-John-Doe',
                            user    => 'johndoe',
                            branch  => 'foo22',
                        }
                    ]
                )
            };

            it "should build dist" => sub {
                lives_ok { $tzil->build; };
            };

            it "should contains a badge" => sub {
                my $content = eval { $tzil->slurp_file( 'source/README.md' ); };

                like(
                    $content,
                    qr{\Q[![Build Status]\E.*travis-ci\.org.*foo22.*johndoe/p5-John-Doe.*},
                );
            };
        };

        describe "when vector" => sub {
            my ( $tzil );

            before all => sub {
                $tzil = $builder->(
                    [
                        'TravisCI::StatusBadge' => {
                            repo    => 'p5-John-Doe',
                            user    => 'johndoe',
                            vector  => 1,
                        }
                    ]
                )
            };

            it "should build dist" => sub {
                lives_ok { $tzil->build; };
            };

            it "should contains a badge" => sub {
                my $content = eval { $tzil->slurp_file( 'source/README.md' ); };

                like(
                    $content,
                    qr{\Q[![Build Status]\E.*travis-ci\.org.*svg\?branch.*johndoe/p5-John-Doe.*},
                );
            };
        };
    };
};

runtests unless caller;
