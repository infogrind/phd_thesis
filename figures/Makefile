# Program names
LATEXMK = latexmk
EPSTOPDF = epstopdf
FIG2DEV = fig2dev
MATLAB = matlab
GNUPLOT = gnuplot

# Extensions of temporary files used by latex; these will be removed when
# 'make clean' is called
LATEXAUX = *.log *.aux *.dvi *.bbl *.blg *.idx *.ind *.ilg *.bak *.out

# Create a variable containing PS and PDF targets for each .tex file found
TEXFILES=$(wildcard *.tex)
TEXPDF=$(patsubst %.tex,%.pdf,$(TEXFILES))
TEXPS=$(patsubst %.tex,%.ps,$(TEXFILES))

# Create variables used for xfig targets
FIGFILES=$(wildcard *.fig)
FIGPDF=$(patsubst %.fig,%.pdf,$(FIGFILES))
FIGPS=$(patsubst %.fig,%.ps,$(FIGFILES))
FIG_T=$(patsubst %.fig,%_t,$(FIGFILES))

# Create list of PDF and EPS files for which a .m file exists
MFILES = $(wildcard *.m)
MPDF = $(patsubst %.m,%.pdf,$(MFILES))
MPS = $(patsubst %.m,%.eps,$(MFILES))
MTEXT = $(patsubst %.m,%.tex_t,$(MFILES))

# Create list of PDF files for which an EPS file exists
EPSFILES=$(wildcard *.eps)
EPSPDF=$(patsubst %.eps,%.pdf,$(EPSFILES))

# Default PDF and PS targets
PDFTARGETS += $(TEXPDF)
PSTARGETS += $(TEXPS)

# .table files that need to be generated
TABLEFILES += bsccuc_curve.table
TABLEFILES += bsccuc_tangent.table


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
all : subdirs $(MTEXT) $(TABLEFILES)
	
# The following line allows you to type 'make force'; forcing a rebuild of
# anything regardless of existing files/timestamps
force : clean all

# If you have particular dependencies, e.g., tex files that employ figures,
# include these here. 
# Examples:
#   paper.pdf : channelfig.pdf channelfig_t  (assuming channelfig.fig exists)
#
#   paper.ps : channelfig.ps channelfig_t  (assuming channelfig.fig exists)
#
# etc...
#
bsccuc_curve.table bsccuc_tangent.table : bsccuc.gnuplot
	$(GNUPLOT) $<


# Add here subdirectories where you would like 'make' to run recursively. 
SUBDIRS += matlab

# If you want specific files to be deleted upon 'make clean', add them to the
# variable CLEAN.
CLEAN += 

################################################################################
# Default rule section
################################################################################

# Default objects to clean:
# - All .ps and .pdf files for which a .tex file of the same name exists
# - All .ps, .pdf, and _t files for which a .fig files exists
# - All auxiliary latex files (.aux, .log, .bbl, .dvi, ...)
clean :
	rm -Rf $(TEXPS) $(TEXPDF) $(FIGPDF) $(EPSPDF) $(FIGPS) $(FIG_T) 	\
		$(MPDF) $(MPS) $(MTEXT) $(LATEXAUX) $(CLEAN); 	\
		for d in $(SUBDIRS); do $(MAKE) --directory=$$d clean; done

subdirs : $(SUBDIRS)
  
$(SUBDIRS) : 
	$(MAKE) --directory=$@

# Compile latex to pdf
%.pdf : %.tex
	$(LATEXMK) -g -pdf $<

# Compile latex to postscript
%.ps : %.tex
	$(LATEXMK) -g -ps $<

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
	$(MATLAB) -nodisplay -nojvm < $<

# Convert MATLAB to tex_t
%.tex_t : %.m
	$(MATLAB) -nodisplay -nojvm < $<

# Convert .gnuplot to .table
%.table : %.gnuplot
	$(GNUPLOT) $<

# Phony targets
.PHONY : all clean subdirs $(SUBDIRS)
	
