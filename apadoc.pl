#!/usr/bin/perl
#
# Name: apadoc.pl
# Date: 14 September, 2014
# Author: David McKoskey


use strict;
use warnings;
use lib qw(c:/bin/perl c:/env/bin/perl /home/mckoskey/bin/perl);

use Carp;
use English;
use IO::File;
use Utilities;
use File::Basename;

if($#ARGV < 0) { syntax(); }

my $util = new Utilities();
my $today = $util->get_print_date();

my $filename = shift @ARGV;
my @extensions = qw(.tex);

my($title, $path, $extension) = fileparse($filename, @extensions);

$filename = $title;

if(! -e $filename . ".tex")     { $util->write_file($filename . ".tex", get_main($filename)); }
if(! -e $filename . ".bib")     { $util->write_file($filename . ".bib", get_main_bib($filename)); }
if(! -e "code_format.tex")      { $util->write_file("code_format.tex",  get_code_format()); }
if(! -e "outline.tex")          { $util->write_file("outline.tex",      get_outline()); }
if(! -e "abstract.tex")         { $util->write_file("abstract.tex",     get_abstract()); }
if(! -e "introduction.tex")     { $util->write_file("introduction.tex", get_introduction()); }
if(! -e "conclusion.tex")       { $util->write_file("conclusion.tex",   get_conclusion()); }
if(! -e "make_links")           { $util->write_file("make_links",       get_make_links()); }
if(! -e "makefile")             { $util->write_file("makefile",         get_makefile($filename)); }
if(! -e "r.bat")                { $util->write_file("r.bat",            get_r_bat($filename)); }
if(! -e "run")                  { $util->write_file("run",              get_run($filename)); }


sub get_main
{
    my $filename   = shift;
    my $print_date = $util->get_print_date();
    my $title      = $util->get_title($filename);

    my $main_file=<<MAIN_FILE;
% Document: $filename.tex
% Date: $print_date
% Author: David McKoskey

\\documentclass[jou, 12pt]{article}

%%%%% Packages %%%%%
\\usepackage{course_info}                % Course Information
\\usepackage{apa6}                       % APA 6.0 Document Format
\\usepackage{apacite}                    % APA-style citations
\\usepackage{amsfonts}                   % AMS Fonts
\\usepackage{amsmath}                    %  \"  Math
\\usepackage{amssymb}                    %  \"  Symbols
\\usepackage{bbding}                     % Dingbat Font
\\usepackage{textcomp}                   % Misc. Fonts
\\usepackage{epic}                       % Line Graphics
\\usepackage{eepic}
\\usepackage{ecltree}                    % Simple Trees
\\usepackage{color}                      % Color
\\usepackage{setspace}                   % Paragraph Spacing
\\usepackage{listings}                   % Source Code Formatting 
\\usepackage{marginnote}                 % Margin Notes
\\usepackage{lastpage}                   % Last Page Number
\\usepackage{lscape}                     % Landscape mode
\\usepackage{multirow}                   % Table multi row / column
\\usepackage{arydshln}                   %   \"   column dashed line
\\usepackage{colortbl}                   %   \"   cell color
\\usepackage{graphicx}                   % EPS Graphics files
% \\usepackage[dvipdfm]{hyperref}          % Creates hyperlink references to sections

%%%%% Colors %%%%%
\\definecolor{lightgray}{rgb}{0.9,0.9,0.9} % rgb color model

%%%%% Global Variables %%%%%
\\newcommand{\\figurewidth}{6.5in}
\\newcommand{\\figureunitlength}{0.75 cm}

% \\setcounter{secnumdepth}{-1} % Turn off section numbering without removing them from the TOC

%%%%% Document Setup %%%%%
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

%%%%% Source Code Listing Style %%%%%
\\input{code_format}

%%%%% Title Page %%%%%
\\title{$title}
\\shorttitle{$title}
\\leftheader{\\courseAuthor}
\\affiliation{\\institutionName}
\\author{\\courseAuthor}
\\authornote{\\courseAuthor}
% \\journal{}
% \\volume{}
% \\ccopy{}
% \\copynum{}
\\date{}


%%%%% Abstract %%%%%
\\abstract{}

\\begin{document}

\\maketitle
\\thispagestyle{empty} % no page number on first page

%%%%% TOC and Lists %%%%%
\\tableofcontents
% \\listoffigures
% \\listoftables
\\newpage

%%%%% Sketches and Outlines %%%%%
\\input{outline}
\\newpage

%%%%% Main Body %%%%%
\\input{introduction}
% \\input{}
\\input{conclusion}

%%%%% Appendix %%%%%
% \\newpage
% \\appendix
% \\include{}

\\bibliographystyle{apacite}
% \\bibliography{\\bibFileName,$filename}

\\end{document}
MAIN_FILE

    return $main_file;
}

sub get_main_bib
{
    my $title = shift;

    my $main_bib=<<MAIN_BIB;
% Default bibliography for $title


MAIN_BIB

    return $main_bib;
}


sub get_outline
{
    my $outline=<<OUTLINE;
\\section[Outline]{Outline}\\label{sec:Outline}

\\begin{enumerate}
    \\item Introduction
    \\begin{enumerate}
        \\item 
        \\item 
        \\item 
    \\end{enumerate}
    \\item 
    \\begin{enumerate}
        \\item 
        \\item 
        \\item 
    \\end{enumerate}
    \\item 
    \\begin{enumerate}
        \\item 
        \\item 
        \\item 
    \\end{enumerate}
    \\item Conclusion
    \\begin{enumerate}
        \\item 
        \\item 
        \\item 
    \\end{enumerate}
\\end{enumerate}
OUTLINE

    return $outline;
}


sub get_abstract
{
    my $abstract=<<ABSTRACT;
\\begin{abstract}
Abstract goes here.
\\end{abstract}
ABSTRACT

    return $abstract;
}


sub get_code_format
{
    my $code_format=<<CODEFORMAT;
\\definecolor{darkred}{rgb}{0.75, 0.0, 0.75}
\\definecolor{darkgreen}{rgb}{0.0, 0.5, 0.0}
\\definecolor{darkblue}{rgb}{0.0, 0.0, 0.75}

\\lstset
{
    language=SQL,
    basicstyle=\\ttfamily\\scriptsize,
    keywordstyle=\\color{blue},
    commentstyle=\\color{green},
    stringstyle=\\color{mauve},
    stringstyle=\\ttfamily\\scriptsize,
    showstringspaces=false
}
CODEFORMAT

    return $code_format;
}


sub get_introduction
{
    my $introduction=<<INTRODUCTION;
\\section[Introduction]{Introduction}\\label{sec:Introduction}


INTRODUCTION

    return $introduction;
}


sub get_conclusion
{
    my $conclusion=<<CONCLUSION;
\\section[Conclusion]{Conclusion}\\label{sec:Conclusion}


CONCLUSION

    return $conclusion;
}


sub get_make_links
{
    my $make_links=<<MAKE_LINKS;
#!/bin/bash

rm -f course_info.sty
ln -s ../../../course_info.sty course_info.sty

rm -f code_format.tex
ln -s ../../../code_format.tex code_format.tex
MAKE_LINKS

    return $make_links;
}


sub get_makefile
{
    my $filename = shift;

    my $makefile=<<MAKEFILE;
FILE = $filename

LATEX     = latex
PDFLATEX  = latex
BIBTEX    = bibtex
DVIPS     = dvips
PS2PDF    = ps2pdf
LATEX2RTF = latex2rtf
VIEWER    = evince
COPY      = cp -f
REMOVE    = rm -f

all :
	make preclean
	make compile
	make clean

compile :
	\${LATEX}     \${FILE}.tex
	\${BIBTEX}    \${FILE}
	\${LATEX}     \${FILE}.tex
	\${LATEX}     \${FILE}.tex
	\${LATEX2RTF} \${FILE}.tex

compile_nobib :
	\${LATEX}     \${FILE}.tex
	\${LATEX}     \${FILE}.tex

view:
	\${VIEWER}    \${FILE}.dvi

ps :
	make all
	\${DVIPS}     \${FILE}.dvi
	\${REMOVE}    \${FILE}.dvi

pdf :
	make all
	dvipdfm -q    \${FILE}.dvi
	\${REMOVE}    \${FILE}.dvi

ps_pdf :
	make ps
	\${PS2PDF}    \${FILE}.ps
	\${REMOVE}    \${FILE}.ps

copy_ps :
	make all
	\${DVIPS} -h copy.pro \${FILE}.dvi
	\${REMOVE}    \${FILE}.dvi

copy_pdf :
	make all
	\${DVIPS} -h copy.pro \${FILE}.dvi
	\${PS2PDF}    \${FILE}.ps
	\${REMOVE}    \${FILE}.ps
	\${REMOVE}    \${FILE}.dvi

draft_ps :
	make all
	\${DVIPS} -h draft.pro \${FILE}.dvi
	\${REMOVE}    \${FILE}.dvi

draft_pdf :
	make all
	\${DVIPS} -h draft.pro \${FILE}.dvi
	\${PS2PDF}    \${FILE}.ps
	\${REMOVE}    \${FILE}.ps
	\${REMOVE}    \${FILE}.dvi

n_up_ps :
	make all
	\${DVIPS}     \${FILE}.dvi
	\${REMOVE}    \${FILE}.dvi
	psnup \${N_UP_FL} -pletter -m0in -\${N_UP} \${FILE}.ps \${N_UP}up\${FILE}.ps
	\${COPY}      \${N_UP}up\${FILE}.ps \${FILE}.ps
	\${REMOVE}    \${N_UP}up\${FILE}.ps

n_up_pdf :
	make n_up_ps
	\${PS2PDF}    \${FILE}.ps
	\${REMOVE}    \${FILE}.ps

release :
	make ps_pdf

allclean :
	make preclean
	make clean

preclean :
	\${REMOVE}    \${FILE}.ps
	\${REMOVE}    \${FILE}.pdf
	\${REMOVE}    \${FILE}.dvi

clean : 
	\${REMOVE} *.aux
	\${REMOVE} *.log
	\${REMOVE} *.bbl
	\${REMOVE} *.blg
	\${REMOVE} *.toc
	\${REMOVE} *.lof
	\${REMOVE} *.lot
	\${REMOVE} *.out
MAKEFILE

    return $makefile;
}


sub get_r_bat
{
    my $filename = shift;

    my $r_bat=<<R_BAT;
\@echo off

make release

start $filename.pdf
R_BAT

    return $r_bat;
}


sub get_run
{
    my $filename = shift;

    my $run=<<RUN;
#!/bin/bash

make release

if [[ -f $filename.pdf ]]
then
    evince $filename.pdf &
fi
RUN

    return $run;
}


sub syntax
{
    print "\n";
    print "\tSyntax: doc <filename(s)>\n";
    print "\n";
    print "\tNote: do not use wildcards\n";
    print "\n";
    exit -1;
}

#
# end script
#
