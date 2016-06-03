# NAME

Proc::Swarm - intelligently handle massive multi-processing on one machine

# SYNOPSIS

    use Proc::Swarm;

    my $code = sub {
        my $arg = shift;
        sleep $arg;
        $arg++;
        return $arg;
    };

    my $retvals = Proc::Swarm::swarm({
        code     => $code,  #code to run
        children => 2,      #How many child processes to run parallel
        sort     => 1,      #sort the results
        work     => [1,5,7,10]
    });    #List of objects to work on
    my @results = $retvals->get_result_objects;
    #@results contain 2, 6, 8 and 11, in numeric order.

    my @run_times = $retvals->get_result_times;
    #how long each took to run.  Should contain something like 1,5,7 and 10

    my @objects = $retvals->get_objects;
    #The objects passed in.  Should contain 1,5,7 and 10

    my $specific_result = $retvals->get_result(10);    
    #Get specific result as keyed by passed object: 11 in this case.

    my $specific_return_value = $retvals->get_result(5)->get_runtime;
    #Returns how long it took to run object 5.

# DESCRIPTION

This module provides some fairly fine control over heavy-duty multiprocessing
work.  This is probably most useful in two general cases: a multi-CPU system
that doesn't distribute load in a single process across all CPUs, and 
programs that need to do a lot of slow, blocking work quickly with many
simultaneous processes.  (For instance, SNMP, SOAP, etc.)  Swarm gathers
the results of all of the child processes together and returns that in a
results object, along with information about the status of each unit of work,
how long it took to run each unit, and related information.

# DESIGN

The parent process will be the consumer, and thus the last to exit.  The
first forked child will be the producer, which will then in turn manage all
of the children.  The consumer listens to message queue Qc, and the
producer listens to Qp.  When the consumer gets an object, that means that
one of the children has finished.  It then sends a massage to Qp telling it
to spawn another child.  That message will be the object to work on.  As
such, the consumer handles the list of all objects to be worked on.

There are some real advantages to this design.  We can cut the working
children free with double fork, since their results come back on the message
queue.  We don't have to handle any dangerous signals.  Both the consumer
and the producer are simplified because they just block on IPC activity.
The producer just double forks every time it gets a message, and then waits
for another message.  The consumer has to look at every message that comes
back.

See the docs/ directory with the distribution for a comprehensive
outline of the included classes.

# TODO

Fix the below-cited limitation of sort functionality.

Add the ability to sort using an arbitrary code reference.

Add the ability to add and remove call objects runtime.

Eventually add the ability to control processes on many different
systems.

Make the timing of each run optionally calculated with HiRes.

# AUTHOR

Dana M. Diederich <diederich@gmail.com>

# BUGS

The sort option sorts under the assumption that there is a one to one
cardinality between the submitted objects and the result objects.  That is,
if a given input object is repeated, and the code that is ran against it
returns more than one different result, the sort system is not guaranteed
to work correctly.

Some of the test suites are rather slow.  One of them is very CPU 
intensive.  While not a bug, this can be rather alarming.

# COPYRIGHT

Copyright (c) 2001, 2013, 2016 Dana M. Diederich. All Rights Reserved.
This module is free software. It may be used, redistributed
and/or modified under the terms of the Perl Artistic License
  (see http://www.perl.com/perl/misc/Artistic.html)

