#test module to see if the returned processing time is correct.

use lib '../lib';

BEGIN { print "1..2\n"; }
use strict;
use Proc::Swarm;

print "ok 1\n";

{    #simple call that generates an error on even numbers
    my $code = sub {
        my $arg = shift;
        sleep($arg);
        return($arg);
    };

    my $retvals = Proc::Swarm::swarm({
        code     => $code,
        children => 2,
        sort => 1,
        work => [1,2,3]
    });

    my @runtimes = $retvals->get_result_times;

    #sleep is a tricky thing on UNIX.  This test is very conservative.
    if(($runtimes[0] > 0) and ($runtimes[1] > 1) and ($runtimes[2] > 2)) {
        print "ok 2\n";
    } else {
        print "not ok 2\n";
    }
}
