#Pull it in

use lib '../lib';

BEGIN { print "1..3\n"; }
use strict;
use Proc::Swarm;

print "ok 1\n";

{   #simple call
    my $code = sub {
        my $arg = shift;
        select undef, undef, undef, rand(15);   #sleep rand 15 seconds to
                                                #make sure these come back out
                                                #of order.
        $arg++;
        return $arg;
    };

    my $retvals = Proc::Swarm::swarm({
        code     => $code,
        children => 4,
        sort     => 1,
        work     => ['a', 'z', 'I', '_']
    });
    my @expected_values = ('b','aa','J','1');
    my @sorted_results = $retvals->get_result_objects;
    if (join(':', @sorted_results) ne join(':', @expected_values)) {
        print "not ok 2\n";
    } else {
        print "ok 2\n";
    }
}

{   #Same test, but un-sorted to make sure we come back OUT of order
    my $code = sub {
        my $arg = shift;
        select undef, undef, undef, rand(5);   #sleep rand 5 seconds to
                                                #make sure these come back out
                                                #of order.
        $arg++;
        return $arg;
    };

    my $retvals = Proc::Swarm::swarm({
        code     => $code,
        children => 8,
        work     => ['b','c','d','e','f','g','a','z','I','_']
    });
    my @expected_values = ('c','d','e','f','g','h','b','aa','J','1');
    my @unsorted_results = $retvals->get_result_objects;
    if (join(':', @unsorted_results) ne join(':', @expected_values)) {
        print "ok 3\n";
    } else {
        print "not ok 3\n";
    }

}

#{    #This test tests the passed sort coderef option.
#    my $code = sub {
#        my $arg = shift;
#        return($arg);
#    };
#
#    my $sort_code = q
#                sub { $sort_hash{$a->get_object}
#            <=> $sort_hash{$b->get_object} };
#;
#
#    my $retvals = Proc::Swarm::swarm({    'code' => $code,
#                        'sort' => 1,
#                        'sort_code' => $sort_code,
#                        'children' => 8,
#                        'work' => [9, 99, 10, 2, 11]});
#    my @expected_values = (2, 9, 10, 11, 99);
#    my @sorted_results = $retvals->get_result_objects;
#    if (join(':', @sorted_results) ne join(':', @expected_values)) {
#        print "not ok 4\n";
#    } else {
#        print "ok 4\n";
#    }
#}
