#Pull it in

use lib '../lib';

BEGIN { print "1..2\n"; }
use strict;
use Proc::Swarm;

print "ok 1\n";

{   #simple call
    my $code = sub {
        my $arg = shift;
        sleep rand(20);
        $arg++;
        return $arg;
    };

    my $retvals = Proc::Swarm::swarm({
        code => $code,
        children => 40,
        work => [1..100]
    });
    my @sorted_results = sort {$a <=> $b} $retvals->get_result_objects;
    my @expected_values = (2..101);
    if (@sorted_results != @expected_values) {
        print "not ok 2\n";
    } else {
        print "ok 2\n";
    }
}
