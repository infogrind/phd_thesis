# List of .m files that create PDFs.
MTOPDF += ex_shannonscheme.m
MTOPDF += ex_uncoded.m

# List of .m files that create .tex_t files.
MTOTEXT += ex_uncodedpgf.m
MTOTEXT += fig_scalar_comparison.m

# List of .m files from which only a .minc file should be created.
MINCONLY += PerformanceProcessor_ex.m
MINCONLY += Scheme.m
MINCONLY += TheoreticalScheme.m
MINCONLY += PracticalScheme.m

# Program names
LATEXMK = latexmk
EPSTOPDF = epstopdf
FIG2DEV = fig2dev
MATLAB = matlab
TRIM = ./trimignore.pl

# Create list of MINC, PDF and TEX_T file to be generated from MATLAB.
MFILES = $(MTOPDF) $(MTOTEXT) $(MINCONLY)
MINC = $(patsubst %.m,%.minc,$(MFILES))
MPDF = $(patsubst %.m,%.pdf,$(MTOPDF))
MTEXT = $(patsubst %.m,%.tex_t,$(MTOTEXT))

# Targets to make.
all : subdirs $(MINC) $(MPDF) $(MTEXT)
	
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


# Add here subdirectories where you would like 'make' to run recursively. 
SUBDIRS +=

# If you want specific files to be deleted upon 'make clean', add them to the
# variable CLEAN.
CLEAN += $(MINC)
CLEAN += $(MPDF)
CLEAN += $(MTEXT)

################################################################################
# Default rule section
################################################################################

# Default objects to clean:
# - All .ps and .pdf files for which a .tex file of the same name exists
# - All .ps, .pdf, and _t files for which a .fig files exists
# - All auxiliary latex files (.aux, .log, .bbl, .dvi, ...)
clean :
	rm -Rf $(TEXPS) $(TEXPDF) $(FIGPDF) $(EPSPDF) $(FIGPS) $(FIG_T) 		$(MPDF) $(MPS) $(LATEXAUX) $(CLEAN); 	for d in $(SUBDIRS); do $(MAKE) --directory=$$d clean; done

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
	$(MATLAB) -nodisplay -nodesktop < $<

# Convert MATLAB to PDF
%.pdf : %.m
	$(MATLAB) -nodisplay -nodesktop < $<

# Convert MATLAB to TEX_T
%.tex_t : %.m
	$(MATLAB) -nodisplay -nodesktop < $<

# Convert MATLAB to MINC
%.minc : %.m
	$(TRIM) < $< > $@

# Phony targets
.PHONY : all clean subdirs $(SUBDIRS)
	
