require 5.005;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'Proc::Swarm',
    VERSION_FROM => 'lib/Proc/Swarm.pm',
    dist         => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    $] >= 5.005 ? (
        AUTHOR => 'Dana M. Diederich <diederich@gmail.com>',
        ABSTRACT => 'Produces arbitrary work multiplicity'
    ) : ()
);
