package t::lib::Builder;

use Test::DZil;

use constant MD_SAMPLE => <<"MD_SAMPLE";
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

MD_SAMPLE

use constant POD_SAMPLE => <<"POD_SAMPLE";
=pod

=head1 NAME

Foo::Bar - Foo and Bar

=head1 VERSION

version 0.001

=head1 SYNOPSIS

    use Foo::Bar;

=head1 DESCRIPTION

Tellus proin aptent mattis vel pulvinar, et dui netus tellus.

Habitant ipsum nisl ad feugiat orci suscipit et sodales sodales.

Aliquam conubia sodales malesuada scelerisque, faucibus orci dapibus senectus eget.

POD_SAMPLE

# README.md's builder
sub tzil {
    shift;

    get_builder( 'README.md', 'markdown', @_ );
}

# README in POD syntax builder
sub tzil_for_pod {
    shift;

    get_builder( 'README', 'pod', @_ );
}

# any readme builder
sub tzil_for {
    shift;

    get_builder( @_ );
}

sub get_builder {
    ( my $filename, $_, my @params ) = @_;
    my $sample = /markdown/i ? MD_SAMPLE
               : /pod/i      ? POD_SAMPLE
               :               die("Unknown sample type");

    Builder->from_config(
        { dist_root => 'corpus/dist/DZT' },
        {
            add_files => {
                'source/' . $filename   => $sample,
                'source/dist.ini'       => simple_ini( 'GatherDir', @params ),
            }
        },
    );
}

1;
