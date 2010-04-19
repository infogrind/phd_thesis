# Program names
LATEXMK = ./latexmk
EPSTOPDF = epstopdf
FIG2DEV = fig2dev
MATLAB = matlab
BUNDLEDOC = bundledoc_mk
BIBFILE = $(shell kpsewhich -progname bibtex mkbiblio.bib)

JOBNAME = thesis

# Extensions of temporary files used by latex; these will be removed when
# 'make clean' is called
LATEXAUX = *.log *.aux *.dvi *.bbl *.blg *.idx *.ind *.ilg *.bak *.out

# Create a variable containing PS and PDF targets for each .tex file found
TEXFILES=$(wildcard *.tex)
TEXPDF=$(patsubst %.tex,%.pdf,$(TEXFILES))
TEXPS=$(patsubst %.tex,%.ps,$(TEXFILES))

JOBPDF=$(JOBNAME).pdf

# Create variables used for xfig targets
FIGFILES=$(wildcard *.fig)
FIGPDF=$(patsubst %.fig,%.pdf,$(FIGFILES))
FIGPS=$(patsubst %.fig,%.ps,$(FIGFILES))
FIG_T=$(patsubst %.fig,%_t,$(FIGFILES))

# Create list of PDF and EPS files for which a .m file exists
MFILES = $(wildcard *.m)
MPDF = $(patsubst %.m,%.pdf,$(MFILES))
MPS = $(patsubst %.m,%.eps,$(MFILES))

# Create list of PDF files for which an EPS file exists
EPSFILES=$(wildcard *.eps)
EPSPDF=$(patsubst %.eps,%.pdf,$(EPSFILES))

# Default PDF and PS targets
PDFTARGETS += $(TEXPDF)
PSTARGETS += $(TEXPS)

# The default behavior is to create PDF files for each TEX file found. If you
# want PS files to be generated, use the variable $(PSTARGETS) instead; or use
# both. 
# You can also specify a single PS or PDF file, or a number of files. 
# Examples:
#
# Single PDF file:
#   all : paper.pdf
#
# Single PS file:
#   all : paper.ps
#
# Both PDF and PS files:
#   all : paper.pdf paper.ps
#
# PDF files for all .tex files in the directory
#   all : $(PDFTARGETS)
#
# PS files for all .tex files in the directory
#   all : $(PSTARGETS)
all : $(JOBPDF)
	
# The following line allows you to type 'make force'; forcing a rebuild of
# anything regardless of existing files/timestamps
force : clean all

# Create a .tar.gz file containing all required files, i.e., a standalone
# archive of the thesis.
# [Marius] Disabled for now. Bundledoc does not reliably work, since the
# snapshot package does not detect files that are input by the primitive \input
# command (such as certain files belonging to tikz/pgf).
###bundle : all
###	$(BUNDLEDOC) --config=tetex.cfg $(JOBNAME).dep

# If you have particular dependencies, e.g., tex files that employ figures,
# include these here. 
# Examples:
#   paper.pdf : channelfig.pdf channelfig_t  (assuming channelfig.fig exists)
#
#   paper.ps : channelfig.ps channelfig_t  (assuming channelfig.fig exists)
#
# etc...
thesis.pdf : subdirs thesis.tex packages.tex tikzstyles.tex theoremdefs.tex \
	$(wildcard ch_*.tex) mk_publications.tex $(BIBFILE)
	$(LATEXMK) -dependents -pdf -g 2>&1 | tee $(JOBNAME).deplist


# Add here subdirectories where you would like 'make' to run recursively. 
SUBDIRS += figures

# If you want specific files to be deleted upon 'make clean', add them to the
# variable CLEAN.
CLEAN += $(JOBNAME)-figure.*

################################################################################
# Default rule section
################################################################################

# Default objects to clean:
# - All .ps and .pdf files for which a .tex file of the same name exists
# - All .ps, .pdf, and _t files for which a .fig files exists
# - All auxiliary latex files (.aux, .log, .bbl, .dvi, ...)
clean : cleansubdirs localclean


localclean :
	rm -Rf $(TEXPS) $(TEXPDF) $(FIGPDF) $(EPSPDF) $(FIGPS) $(FIG_T) 	\
		$(MPDF) $(MPS) $(LATEXAUX) $(CLEAN) $(JOBNAME).*.gnuplot \
	$(JOBNAME).*.table ; \
	$(LATEXMK) -C

cleansubdirs : 
	for d in $(SUBDIRS); do $(MAKE) --directory=$$d clean; done

subdirs : $(SUBDIRS)
  
$(SUBDIRS) : 
	$(MAKE) --directory=$@

## Compile latex to pdf
#%.pdf : %.tex
#	$(LATEXMK) -dependents -g -pdf $< 2>&1 | tee $*.deplist

## Compile latex to postscript
#%.ps : %.tex
#	$(LATEXMK) -g -ps $<

# Convert EPS to PDF
%.pdf : %.eps
	$(EPSTOPDF) $<

# Convert FIG to PDF
%.pdf : %.fig
	$(FIG2DEV) -L pdftex $< $@

# Convert FIG to PS
%.ps : %.fig
	$(FIG2DEV) -L pstex $< $@

# Convert FIG to _T (these are the files to be included in the LaTeX file using
# \input)
%_t : %.fig
	echo -e "\\\\begin{picture}(0,0)%\n\\\\epsfig{file=$(patsubst %.fig,%,$<)}%\n\\\\end{picture}%" > $@
	$(FIG2DEV) -L pdftex_t $< >> $@

# Convert MATLAB to EPS
%.eps : %.m
	$(MATLAB) -nodisplay -nojvm < $< > /dev/null

# Phony targets
.PHONY : all bundle clean subdirs $(SUBDIRS)
	
