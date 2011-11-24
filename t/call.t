#Pull it in

use lib '../lib';

BEGIN { print "1..2\n"; }
use strict;
use Proc::Swarm;

print "ok 1\n";

{    #simple call
    my $code = sub {
        my $arg = shift;
        $arg++;
        return($arg);
    };

    my $retvals = Proc::Swarm::swarm({
        code     => $code,
        children => 2,
        work     => [1,5,7,10]
    });
    my @sorted_results = sort {$a <=> $b} $retvals->get_result_objects;
    my @expected_values = (2,6,8,11);
    if (@sorted_results != @expected_values) {
        print "not ok 2\n";
    } else {
        print "ok 2\n";
    }
}
