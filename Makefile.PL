use 5.006;
use ExtUtils::MakeMaker;
use strict;
use warnings;
use Apache::TestMM qw(test clean);

# accept the configs from command line
Apache::TestMM::filter_args();
Apache::TestMM::generate_script('t/TEST');

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Apache2::ExplorerDestroyer',
    VERSION_FROM      => 'lib/Apache2/ExplorerDestroyer.pm', # finds $VERSION
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Apache2/ExplorerDestroyer.pod', # retrieve abstract from module
       AUTHOR         => 'Tyler MacDonald <japh@crackerjack.net>') : ()),
    clean             => { FILES => "@{ clean_files() }" },
);

sub clean_files {
    return [ 't/TEST' ];
}
