
use strict;
use warnings;
use File::Spec;
use Module::Build;

use vars qw/ %StarConfig /;

# See if we can find a starlink system
# $STARLINK env overrides everything
if (exists $ENV{STARLINK} && defined $ENV{STARLINK}) {
  print "Using STARLINK environment variable: $ENV{STARLINK}\n";
  %StarConfig = (
		 Star_Inc => $ENV{STARLINK}."/include",
		 Star_Lib => $ENV{STARLINK}."/lib",
		 Star_Bin => $ENV{STARLINK}."/bin",
		);
} else {
  # Must look for it
  eval "use Starlink::Config";
  if ($@) {
    # do not have a Starlink configuration so guess /star
    %StarConfig = (
		   Star_Inc => '/star/include',
		   Star_Lib => '/star/lib',
		   Star_Bin => '/star/bin',
		  );
  } else {
    print "Found Starlink configuration. Using $StarConfig{Star}\n";
  }
}

my $file = File::Spec->catfile( "lib", "Astro", "PAL.pm" );
my $build = Module::Build->new
  (
   module_name => "Astro::PAL",
   abstract_from => $file,
   license => "gpl3",
   author => [
              'Tim Jenness <tjenness@cpan.org>',
             ],
   version_from => $file,
   meta_merge => {
               resources =>  {
                              repository => "git://github.com/timj/perl-Astro-PAL.git",
                              homepage => "http://github.com/timj/perl-Astro-PAL/tree/master",
                             },
                },
   script_files => [ qw/
                         stime
                       /],
   requires => {
                "Pod::Usage" => 0,
                "Getopt::Long" => 0,
               },
   build_requires => {
                      "Test::More" => 0,
                     },
   c_source => "src",  # Only one option so use single string
   extra_compiler_flags => "-I$StarConfig{Star_Inc}",
   extra_linker_flags => [ "-L$StarConfig{Star_Lib}", "-lpal"],
  );

$build->create_build_script;

