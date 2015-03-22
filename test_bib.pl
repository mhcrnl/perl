#!/usr/bin/perl

use strict;
use warnings;

use Carp;
use English;
use IO::File;
use Getopt::Long;
use File::Basename;

my $apacite = 0;

GetOptions
(
    'a' => \$apacite
);

my $bibfilename = shift @ARGV;
my @extensions = qw(.bib);

my %citations;

my ($title, $path, $extension) = fileparse($bibfilename, @extensions);

my $outfiletexname = $path . $title . ".tex";
my $outfilebibname = $path . $title;
my $outfiledviname = $path . $title . ".dvi";
my $outfilepdfname = $path . $title . ".pdf";

cleanup($outfilebibname);

my $bibfile = IO::File->new($bibfilename, '<') or croak "Unable to open \""  . $bibfilename . "\": " . $OS_ERROR;

while (my $line = <$bibfile>)
{
    chomp $line;
    chomp $line;

    next unless $line =~ /@/;

    my @pieces = split /{/, $line;

    my $citation = $pieces[1];

    $citation =~ s/,//g;
    $citation =~ s/ //g;
    $citation =~ s/\n//g;
    $citation =~ s/\r//g;

    $citations{$citation} = 1;
}

close $bibfile;


my $outfiletex = IO::File->new($outfiletexname, '>') or croak "Unable to write \"" . $outfiletexname . "\": " . $OS_ERROR;

print $outfiletex get_header($apacite);

foreach my $citation (sort keys %citations)
{
    print $outfiletex "\\cite{";
    print $outfiletex $citation;
    print $outfiletex "}";
    print $outfiletex "\n";
}

print $outfiletex get_footer($outfilebibname, $apacite);

close $outfiletex;

my $output = `latex   $outfiletexname 2>&1`;
   $output = `bibtex  $outfilebibname 2>&1`;
   $output = `latex   $outfiletexname 2>&1`;
   $output = `latex   $outfiletexname 2>&1`;
   $output = `dvipdfm $outfiledviname 2>&1`;

cleanup($outfilebibname);


sub get_header
{
    my $apacite = shift;

    my $apaciteline = "\\usepackage{apacite}\n";

    my $header1=<<HEADER1;
\\documentclass[letterpaper, 12pt]{article}

HEADER1

    my $header2=<<HEADER2;

\\renewcommand{\\familydefault}{\\sfdefault}

\\setlength{\\topmargin}{0in}         % Top margins
\\setlength{\\headheight}{0in}
\\setlength{\\voffset}{-0.4in}
\\setlength{\\headsep}{0.5in}
\\setlength{\\topskip}{0in}
\\setlength{\\oddsidemargin}{0in}     % Side margins
\\setlength{\\evensidemargin}{-0.5in}
\\setlength{\\textwidth}{6.5in}       % Text width
\\setlength{\\textheight}{9in}        % Text height
% \\setlength{\\footskip}{0.5in}        % Bottom margins
\\setlength{\\parindent}{0in}         % Paragraph indent
\\pagestyle{plain}                   % Simple page format
\\begin{document}

\\title{Test BibTeX File}
\\author{David McKoskey}
\\maketitle

HEADER2

    my $header = "";

    if($apacite)
    {
        $header = $header1 . $apaciteline . $header2;
    }
    else
    {
        $header = $header1 . $header2;
    }

    return $header;
}

sub get_footer
{
    my $outfilebibname = shift;
    my $apacite = shift;

    my $citestyle = "plain";

    if($apacite)
    {
        $citestyle = "apacite";
    }

    my $footer=<<FOOTER;

%%%%% Appendix %%%%%
% \\newpage
% \\appendix
% \\include{}

\\bibliographystyle{$citestyle}
\\bibliography{$outfilebibname}

\\end{document}
FOOTER

    return $footer;
}

sub cleanup
{
    my $outfilebibname = shift;

    my @extensions = qw(.aux .log .bbl .blg .toc .lof .lot .out .dvi .tex);

    foreach my $extension (@extensions)
    {
        my $filename = $outfilebibname . $extension;

        if(-f $filename)
        {
            unlink $filename;
        }
    }
}
