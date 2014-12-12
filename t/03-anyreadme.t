use Test::Spec;
use Test::Exception;
use Test::DZil;

use t::lib::Builder;

describe "TravisCI::StatusBadge" => sub {
    describe "guess README name" => sub {
        my ( $tzil );

        it "should be ok" => sub {
            pass;
        };
    };
};

runtests unless caller;
