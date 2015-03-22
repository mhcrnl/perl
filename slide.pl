#!/usr/bin/perl
#
# Name: slide.pl
# Date: 14 June, 2011
# Author: David McKoskey

=pod

=begin html

<blockquote>

=end html



=head2 Synopsis

=over 4

=item *

Name: slide.pl

=item *

Author: David McKoskey

=back



=head2 Purpose

Create a new LaTeX Beamer slide.



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
        <td>November 28, 2011</td>
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
use Getopt::Long;

my $fragile = undef;
my $twocolumn = undef;

GetOptions
(
    'c' => \$twocolumn,
    'f' => \$fragile,
);

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

	my $file = IO::File->new($filename, ">") or croak "Unable to open \"" . $filename . "\": " . $OS_ERROR;

	print $file "\\section[" . $util->get_title($filename) . "]{" . $util->get_title($filename) . "}\\label{sec:" . $util->get_label ($filename) . "}\n";
	print $file "\n";

    if($util->test_var($fragile))
    {
	    print $file "\\begin{frame}[fragile]\n";
	    print $file "\n";
	    print $file "\\frametitle{" . $util->get_title($filename) . "}\n";
	    print $file "\n";
	    print $file "Below is a source code example:\\\\[0.25cm]\n";
	    print $file "\n";
	    print $file "\\pause\n";
	    print $file "\n";
	    print $file "\\begin{lstlisting}\n";
	    print $file "\\end{lstlisting}\n";
	    print $file "\n";
	    print $file "\\pause\n";
	    print $file "\n";
	    print $file "Below is another source code example:\\\\[0.25cm]\n";
	    print $file "\n";
	    print $file "\\pause\n";
	    print $file "\n";
	    print $file "\\begin{lstlisting}\n";
	    print $file "\\end{lstlisting}\n";
    }
    elsif ($util->test_var($twocolumn))
    {
	    print $file "\\begin{frame}\n";
	    print $file "\n";
	    print $file "\\frametitle{" . $util->get_title($filename) . "}\n";
	    print $file "\n";
	    print $file "\\onslide<1->\n";
	    print $file "{\n";
	    print $file "    % Opening remarks\n";
	    print $file "}\n";
	    print $file "\n";
	    print $file "\\begin{columns}[c]\n";
	    print $file "\n";
	    print $file "\\column{0.6\\textwidth}\n";
	    print $file "\\begin{itemize}\n";
	    print $file "    \\item<2-> \n";
	    print $file "    \\item<3-> \n";
	    print $file "    \\item<4-> \n";
	    print $file "\\end{itemize}\n";
	    print $file "\n";
	    print $file "\\column{0.4\\textwidth}\n";
	    print $file "\\framebox{\\includegraphics{myimage.jpg}\n";
	    print $file "\n";
	    print $file "\\end{columns}\n";
    }
    else
    {
	    print $file "\\begin{frame}\n";
	    print $file "\n";
	    print $file "\\frametitle{" . $util->get_title($filename) . "}\n";
	    print $file "\n";
	    print $file "\\onslide<1->\n";
	    print $file "{\n";
	    print $file "}\n";
	    print $file "\n";
	    print $file "\\begin{itemize}\n";
	    print $file "    \\item<2-> \n";
	    print $file "    \\item<3-> \n";
	    print $file "    \\item<4-> \n";
	    print $file "\\end{itemize}\n";
    }

	print $file "\n";
	print $file "\\end{frame}\n";

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
	print "\tSyntax: slide <filename(s)>\n";
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
