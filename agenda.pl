use strict;
use warnings;
use lib qw(c:/bin/perl c:/env/bin/perl /home/mckoskey/bin/perl);

use Carp;
use English;
use IO::File;
use Utilities;
use Getopt::Long;

my $week_number = undef;

GetOptions
(
    'w=s' => \$week_number,
);

my $util = new Utilities();

croak "ERROR: No week specified." unless $util->test_var($week_number);

$week_number = "0" . $week_number if length($week_number) < 2;

my %number_words = (
    "1" => "One",
    "2" => "Two",
    "3" => "Three",
    "4" => "Four",
    "5" => "Five",
    "6" => "Six",
    "7" => "Seven",
    "8" => "Eight",
    "9" => "Nine",
    "10" => "Ten",
    "11" => "Eleven",
    "12" => "Twelve",
    "13" => "Thirteen",
    "14" => "Fourteen",
    "15" => "Fifteen",
    "16" => "Sixteen",
    "17" => "Seventeen",
);

my $main_slide_name = "week_" . $week_number . "_agenda.tex";

# Main program coordination.  The rest is in subroutines.
if(! -e "make_links")     { $util->write_file("make_links",     get_make_links()); }
if(! -e "makefile")       { $util->write_file("makefile",       get_makefile($week_number)); }
if(! -e "r.bat")          { $util->write_file("r.bat",          get_r_bat($week_number)); }
if(! -e "run")            { $util->write_file("run",            get_run($week_number)); }
if(! -e $main_slide_name) { $util->write_file($main_slide_name, get_main_slide($week_number)); }
if(! -e "agenda.tex")     { $util->write_file("agenda.tex",     get_agenda_slide()); }
if(! -e "next_time.tex")  { $util->write_file("next_time.tex",  get_next_time_slide()); }
if(! -e "questions.tex")  { $util->write_file("questions.tex",  get_questions_slide()); }


sub get_make_links
{
    my $make_links=<<MAKE_LINKS;
#!/bin/bash

rm -f course_info.sty
ln -s ../../course_info.sty course_info.sty

rm -f notes_page.pdf
ln -s ../../notes_page/notes_page.pdf notes_page.pdf
MAKE_LINKS

    return $make_links;
}

sub get_makefile
{
    my $week_number = shift;

    my $filename = "week_" . $week_number . "_agenda";

    my $makefile=<<MAKEFILE;
FILE = $filename
HANDOUT = handout
NOTES = notes

# UNIX or Linux
  LATEX     = latex
  PDFLATEX  = latex
  DVIPS     = dvips
  PS2PDF    = ps2pdf
  VIEWER    = evince
  COPY      = cp -f
  REMOVE    = rm -f

# Win32 using MikTeX
# LATEX     = latex     --quiet
# PDFLATEX  = pdflatex  --quiet
# VIEWER    = yap
# COPY      = copy /y
# REMOVE    = del /q

all :
        make preclean
        make compile_slides
        make compile_handout
        make compile_notes
        make clean

compile_slides :
        \${LATEX}  \${FILE}.tex
        \${LATEX}  \${FILE}.tex
        \${DVIPS}  \${FILE}.dvi
        \${REMOVE} \${FILE}.dvi
        \${PS2PDF} \${FILE}.ps
        \${REMOVE} \${FILE}.ps

compile_handout :
        \${LATEX}  \${FILE}_\${HANDOUT}.tex
        \${LATEX}  \${FILE}_\${HANDOUT}.tex
        \${DVIPS}  \${FILE}_\${HANDOUT}.dvi
        \${REMOVE} \${FILE}_\${HANDOUT}.dvi
        \${PS2PDF} \${FILE}_\${HANDOUT}.ps
        \${REMOVE} \${FILE}_\${HANDOUT}.ps

compile_notes :
        \${PDFLATEX} \${FILE}_\${NOTES}.tex
        \${PDFLATEX} \${FILE}_\${NOTES}.tex
        \${REMOVE}   \${FILE}_\${HANDOUT}.pdf

release :
        make all

allclean :
        make preclean
        make clean

preclean :
        \${REMOVE} \${FILE}.ps
        \${REMOVE} \${FILE}.pdf
        \${REMOVE} \${FILE}.dvi
        \${REMOVE} \${FILE}_\${HANDOUT}.ps
        \${REMOVE} \${FILE}_\${HANDOUT}.pdf
        \${REMOVE} \${FILE}_\${HANDOUT}.dvi
        \${REMOVE} \${FILE}_\${NOTES}.ps
        \${REMOVE} \${FILE}_\${NOTES}.pdf
        \${REMOVE} \${FILE}_\${NOTES}.dvi

clean :
        \${REMOVE} *.aux
        \${REMOVE} *.log
        \${REMOVE} *.bbl
        \${REMOVE} *.blg
        \${REMOVE} *.toc
        \${REMOVE} *.lof
        \${REMOVE} *.lot
        \${REMOVE} *.nav
        \${REMOVE} *.out
        \${REMOVE} *.snm
        \${REMOVE} *.vrb
MAKEFILE

    return $makefile;
}

sub get_main_slide
{
    my $week_number = shift;

    $week_number = int $week_number; # strip leading zero

    my $week_date = "week" . get_number_word($week_number) . "Date";

    my $main_slide=<<MAIN_SLIDE;
\\documentclass{beamer}

%%%%% Packages %%%%%
\\usepackage{course_info}                % Course Information
\\usepackage{amsfonts}                   % AMS Fonts
\\usepackage{amsmath}                    %  "  Math
\\usepackage{amssymb}                    %  "  Symbols
\\usepackage{epic}                       % Line Graphics
\\usepackage{eepic}
\\usepackage{color}                      % Color
\\usepackage{setspace}                   % Paragraph Spacing
\\usepackage{listings}                   % Source Code Formatting
\\usepackage{lscape}                     % Landscape mode
\\usepackage{multirow}                   % Table multi row / column
\\usepackage{colortbl}                   % Table color
\\usepackage{arydshln}                   % Table dashed rows and columns

%%%%% Base Beamer Classes %%%%%
\\usepackage{beamerthemesplit}
\\usetheme{\\courseTheme}
\\usecolortheme{\\courseColorTheme}

%%%%% Colors %%%%%
\\definecolor{lightgray}{rgb}{0.9,0.9,0.9} % rgb color model

%%%%% Global Variables %%%%%
\\newcommand{\\figurewidth}{6.5in}
\\newcommand{\\figureunitlength}{0.75 cm}

\\begin{document}

%%%%% Title Page %%%%%
\\title[\\courseCallNumber\ : Week $week_number Agenda]{\\courseCallNumber\\ Week $week_number: Agenda}
\\author{\\courseAuthor}
\\date{\\$week_date}
\\institute[\\institutionName]{\\departmentFullName \\\\ \\institutionName}
\\subject{\\courseCallNumber\ : Week $week_number Agenda}
\\maketitle
% \\thispagestyle{empty} % no page number on title page

%%%%% Presentation %%%%%
\\input{agenda}
\\input{next_time}
\\input{questions}

\\end{document}
MAIN_SLIDE
}

sub get_agenda_slide
{
    my $agenda=<<AGENDA;
\\section[Agenda]{Agenda}\\label{sec:Agenda}

\\begin{frame}

\\frametitle{Agenda}

\\onslide<1->
{
}

\\begin{itemize}
    \\item<2-> 
    \\item<3-> 
    \\item<4-> 
\\end{itemize}

\\end{frame}
AGENDA

    return $agenda;
}

sub get_next_time_slide
{
    my $next_time=<<NEXT_TIME;
\\section[Next Time]{Next Time}\\label{sec:NextTime}

\\begin{frame}

\\frametitle{Next Time}

\\onslide<1->
{
}

\\begin{itemize}
    \\item<2-> 
    \\item<3-> 
    \\item<4-> Complete and submit any lab work not finished tonight by Monday.
\\end{itemize}

\\end{frame}
NEXT_TIME

    return $next_time;
}

sub get_questions_slide
{
    my $questions=<<QUESTIONS;
\\section[Questions]{Questions}\\label{sec:Questions}

\\begin{frame}

% \\frametitle{Questions}

\\begin{center}
{ \\Huge Questions ? }
\\end{center}

\\end{frame}
QUESTIONS

    return $questions;
}

sub get_r_bat
{
    my $week_number = shift;

    my $filename = "week_" . $week_number . "_agenda";

    my $r_bat=<<R_BAT;
\@echo off

make release

start $filename.pdf
R_BAT

    return $r_bat;
}

sub get_run
{
    my $week_number = shift;

    my $filename = "week_" . $week_number . "_agenda";

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

sub get_number_word
{
    my $week_number = shift;

    $week_number = int $week_number;

    return $number_words{$week_number};
}
