#!/usr/bin/perl
#
# Name: make_callers.pl
# Date: 8 June, 2011
# Author: David McKoskey

=pod

=begin html

<blockquote>

=end html



=head2 Synopsis

=over 4

=item *

Name: make_callers.pl

=item *

Author: David McKoskey

=back



=head2 Purpose

Create Win32 batch files to call (these) Perl scripts.  



=head2 Revision History

=begin html

<table border="1" style="border-collapse : collapse" cellpadding="10">
    <tr>
        <th bgcolor="tan">Name</th>
        <th bgcolor="tan">Date</th>
        <th bgcolor="tan">Description</th>
    </tr>
    <tr>
        <td>David McKoskey</td>
        <td>June 8, 2011</td>
        <td>Initial Revision</td>
    </tr>
    <tr>
        <td></td>
        <td></td>
        <td></td>
    </tr>
    <tr>
        <td></td>
        <td></td>
        <td></td>
    </tr>
</table>

=end html

=cut


use strict;
use warnings;

use Carp;
use English;
use IO::File;
use File::Basename;

# my @infilenames = @ARGV;
  my @infilenames = glob($ARGV[0]);

my @extensions = qw(.pl);
my $win32path = "c:\\env\\bin";

foreach my $infilename (@infilenames)
{
    next if $infilename =~ /make_callers/;

    my($name, $path, $extension) = fileparse($infilename, @extensions);

    my $win32outfilename = "..\\" . $name . ".bat";

    print "Creating \"" . $win32outfilename . "\"\n";
    
    my $win32outfile = IO::File->new($win32outfilename, ">") or croak "Unable to create \"" . $win32outfilename . "\": " . $OS_ERROR;

    print $win32outfile "\@echo off\n";
    print $win32outfile "\n";
    print $win32outfile "perl " . $win32path . "\\perl\\" . $infilename . " %1 %2 %3 %4 %5 %6 %7 %8 %9\n";

    close $win32outfile;
}

=pod

=begin html

</blockquote>

=end html

=cut

#
# end script
#
