#!/usr/bin/perl
#
# Name: to_lower.pl
# Date: 27 April, 2011
# Author: David McKoskey

=pod

=begin html

<blockquote>

=end html



=head2 Synopsis

=over 4

=item *

Name: to_lower.pl

=item *

Author: David McKoskey

=back



=head2 Purpose

Change a file name to all lower case.  



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
        <td>April 27, 2011</td>
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

=head2 Functions

=cut


if($#ARGV < 0) { Syntax(); }

use strict;
use warnings;

# my @infilenames = glob($ARGV[0]);
  my @infilenames = @ARGV;

foreach my $infilename (@infilenames)
{
    next if -f lc($infilename);

    my $newfilename = $infilename;

    $newfilename = lc $newfilename;
    $newfilename =~ s/ /_/g;
    $newfilename =~ s/"//g;
    $newfilename =~ s/'//g;
    $newfilename =~ s/\(//g;
    $newfilename =~ s/\)//g;
    $newfilename =~ s/,//g;

    $infilename =~ s/ /\\ /g;
    $infilename =~ s/'/\\'/g;
    $infilename =~ s/\(/\\\(/g;
    $infilename =~ s/\)/\\\)/g;

    my $command = "mv " . $infilename . " " . $newfilename;
    # print $command . "\n";

    system($command);
}


=pod

=head4 syntax()

When the script is executed without any parameters, this function displays script syntax.

=cut
sub Syntax
{
	print "\n\tsyntax: to_lower <files>\n\n";
	exit(-1);
}


=pod

=begin html

</blockquote>

=end html

=cut

#
# end script
#
