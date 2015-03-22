#!/usr/bin/perl
#
# Name: today.pl
# Date: 24 May, 2001
# Author: David McKoskey

=pod

=begin html

<blockquote>

=end html



=head2 Synopsis

=over 4

=item *

Name: today.pl

=item *

Author: David McKoskey

=back



=head2 Purpose

Create a LaTeX journal page.  



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
        <td>May 24, 2001</td>
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


use strict;
use warnings;
use lib qw(c:/bin/perl c:/env/bin/perl /home/mckoskey/bin/perl);

use Carp;
use English;
use IO::File;
use Getopt::Std;
use Utilities;
use vars qw($opt_i);
getopts('i:');

# print "Current day and time: " . (scalar localtime) . "\n";

my $util = new Utilities();
# my $prefix = shift @ARGV;
# $prefix = 'sketch' unless defined($prefix) && length($prefix) > 0;
my $today = $util->get_print_date();
my $short_today = $util->get_short_date();
# my $filename = $prefix . "_" . $util->get_file_date() . ".tex";
my $filename = $util->get_file_date() . ".tex";

if(! -e $filename)
{
	my $file = IO::File->new($filename, ">") or croak "Unable to create \"" . $filename . "\": " . $OS_ERROR;

	print $file "\\subsection[". $short_today . "]{" . $today . "}\\label{subsec:" . $short_today . "}\n";
	print $file "\n";

	if(defined($opt_i)) # optionally inline another file (additional subsections, etc.)
	{
		if(-e $opt_i)
		{
			my $infile = IO::File->new($opt_i, "<") or croak "Unable to create \"" . $opt_i . "\": " . $OS_ERROR;

			while(my $inline = <$infile>) { print $file $inline; }

			close($infile);
		}
		else { print "Error: unable to inline \"" . $opt_i . "\" into file.\n"; }
	}
	else { print $file "\n"; }

	close($file);
}

# system("vi $filename");
system("gvim $filename &");

=pod

=begin html

</blockquote>

=end html

=cut

#
# end script
#
