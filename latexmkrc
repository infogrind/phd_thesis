# Enable latex and pdflatex to call external programs.
$latex = 'latex %O -shell-escape %S';
$pdflatex = 'pdflatex %O -shell-escape %S';

$pdf_mode = 1;

# Add missing file warning of tikz plots to array of file-not-found messages.
push @file_not_found, '^Package pgf Warning: Plot data file `([^\\\']*)\\\'';

# Set main tex file to compile (if latexmk is run without arguments)
@default_files = ( 'mk_publications.tex', 'thesis.tex' );

#vim:ft=perl
