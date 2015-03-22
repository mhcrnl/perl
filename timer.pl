#!/usr/bin/perl
#
# Name: timer.pl
# Date: 9 June, 2011
# Author: David McKoskey

=pod

=begin html

<blockquote>

=end html



=head2 Synopsis

=over 4

=item *

Name: timer.pl

=item *

Author: David McKoskey

=back



=head2 Purpose

Time the execution of another application.  



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
        <td>June 9, 2011</td>
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


if($#ARGV < 0) { Syntax(); exit 0; }

use strict;
use warnings;

my $command;

while (@ARGV)
{
	$command = $command . shift @ARGV;
	if($#ARGV >= 0) { $command = $command . " "; }
}

print " Executing: \"" . $command . "\"\n";
print "     Start: ";
print scalar localtime; # UNIX-style time
print "\n";
system($command);
print "       End: ";
print scalar localtime; # UNIX-style time
print "\n";


=pod

=head4 syntax()

When the script is executed without any parameters, this function displays script syntax.

=cut
sub Syntax
{
	print "\n";
	print "    ";
	print "timer <command>";
	print "\n";
}

=pod

=begin html

</blockquote>

=end html

=cut

#
# end script
#
