#!/usr/bin/perl
#
# Name: poem.pl
# Date: 14 June, 2011
# Author: David McKoskey

=pod

=begin html

<blockquote>

=end html



=head2 Synopsis

=over 4

=item *

Name: poem.pl

=item *

Author: David McKoskey

=back



=head2 Purpose

Create a template LaTeX poem page.  



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
        <td>June 14, 2011</td>
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
use Utilities;
use File::Basename;
my @extensions = qw(.tex);

if($#ARGV < 0) { Syntax(); }

my $util = new Utilities();
my $today = $util->get_print_date();

my @infiles = @ARGV;

foreach my $filename (@infiles)
{
	if($filename =~ /\*/)
	{
		print"\n\tERROR: WILDCARD.  Please enumerate file names\n\n";
		Syntax();
	}

	if(-e $filename)
	{
		print "File \"" . $filename . "\" exists, skipping...\n";
		next;
	}

	if($filename !~ /\.tex/)
	{
		$filename = $filename . ".tex";
	}

	if(-e $filename)
	{
		print "File \"" . $filename . "\" exists, skipping...\n";
		next;
	}

    my($name, $path, $extension) = fileparse($filename, @extensions);

    my @names = split /_/, $name;

    my $poemtitle;

    for(my $i = 0; $i <= $#names; $i++)
    {
        $poemtitle .= ucfirst($names[$i]);

        if($i < $#names)
        {
            $poemtitle .= " ";
        }
    }

	my $file = IO::File->new($filename, ">") or croak "Unable to open file \"" . $filename . "\": " . $OS_ERROR;

	print $file "% Document: " . $filename . "\n";
	print $file "% Date: " . $util->get_print_date() . "\n";
	print $file "% Author: David McKoskey\n";
	print $file "\n";
	print $file "\\begin{poem}\n";
	print $file "\\poemtitle{" . $poemtitle . "}\n";
	print $file "\n";
	print $file "\\begin{poemdedication}\n";
	print $file "\\end{poemdedication}\n";
	print $file "\n";
	print $file "\\begin{stanza}\n";
	print $file "\\end{stanza}\n";
	print $file "\n";
	print $file "\\begin{stanza}\n";
	print $file "\\end{stanza}\n";
	print $file "\n";
	print $file "\\begin{stanza}\n";
	print $file "\\end{stanza}\n";
	print $file "\\end{poem}\n";

	close($file);

	print "\t\"" . $filename . "\" created.\n";
}


=pod

=head4 syntax()

When the script is executed without any parameters, this function displays script syntax.

=cut
sub Syntax
{
	print "\n";
	print "\tSyntax: poem <filename(s)>\n";
	print "\n";
	print "\tNote: do not use wildcards\n";
	print "\n";
	exit -1;
}

=pod

=begin html

</blockquote>

=end html

=cut

#
# end script
#
