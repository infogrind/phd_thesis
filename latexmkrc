#vim:ft=perl
$latex = 'latex %O -shell-escape %S';
$pdflatex = 'pdflatex %O -shell-escape %S';

# Set main tex file to compile (if latexmk is run without arguments)
@default_files = ( 'thesis.tex' );
