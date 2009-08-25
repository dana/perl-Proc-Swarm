
use lib '../lib';

BEGIN { print "1..2\n"; }
use strict;
use Proc::Swarm;

print "ok 1\n";

{	#simple call that generates an error on even numbers
	my $code = sub {
		my $arg = shift;
		my $val = $arg % 2;
		return(4 / $val);	#This blows up on even $arg
	};

	my $retvals = Proc::Swarm::swarm({	'code' => $code,
						'children' => 2,
						'work' => [2,5,7,10]});
	if($retvals->get_result(2)->get_result_type eq 'error') {
		print "ok 2\n";
	} else {
		print "not ok 2\n";
	}
}
