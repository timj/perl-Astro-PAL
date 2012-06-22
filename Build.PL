
use strict;
use warnings;
use File::Spec;
use Module::Build;


# Try to decide whether to build with copysign() enabled.
# Solaris systems on CPAN testers do not enable C99 features.
# Another option would be to try to guess whether we can add the C99
# compiler flags directly.
# This is a bit of a hack.
my $d_copysign = "-DHAVE_COPYSIGN=1";
if ($^O eq 'solaris') {
  $d_copysign = '';
}


my $file = File::Spec->catfile( "lib", "Astro", "PAL.pm" );
my $build = Module::Build->new
  (
   module_name => "Astro::PAL",
   abstract_from => $file,
   license => "gpl",
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
   configure_requires => {
                          "Module::Build" => 0.3604, # c_source as array ref
                         },
   c_source => ["src","sofasrc","palsrc"],
   extra_compiler_flags => "-DNOSTARUTIL=1 $d_copysign",
  );

$build->create_build_script;

