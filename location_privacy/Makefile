TEX      := latex
PDFTEX   := pdflatex
BIBTEX   := bibtex
RM       := rm -f
OPTIONS  = -o
PDFTEXOPTIONS = --interaction batchmode

DVI     = paper.dvi
TARGET  = paper.pdf
BIBSRC  = $(shell ls *.bib)
BIBFILE = $(shell ls *.bbl)

all: $(TARGET)

paper.pdf: $(DVI)
	clear
	echo Running $(PDFTEX)
	$(PDFTEX) $(PDFTEXOPTIONS) $(basename $(DVI));\

diff.pdf:
	latexdiff most_submitted_paper.tex paper.tex >diff.tex
	pdflatex diff.tex
	pdflatex diff.tex

app-location-use-reasons.tex: app-location-uses-reasons.txt
	@echo "generating app usage reasons..."
	ruby process_app_usage_reasons.rb

tables: $(shell ls *knees.tex) #plots
	@echo "generating tables..."
	cd data/scripts; ruby generate_knee_points.rb

# Sort of bad because we regenerate everything...
plots: $(shell find data/)
	@echo "regenerating plots, this may take a while ..."
	cd data/scripts; ruby main.rb --all-apps --all-plots

paper.dvi: $(shell ls *.tex)
	clear
	echo Running $(PDFTEX)
	echo $(basename $@) 
	$(PDFTEX) $(basename $@)
	clear
	echo Running $(BIBTEX);\
	$(BIBTEX) $(basename $@) ;\
	clear;\
	for i in 1 2; do\
	   echo Running $(PDFTEX);\
	   $(PDFTEX) $(basename $@) ;\
	done

clean: 
	$(RM) $(TARGET)  $(DVI) $(BIBFILE) *.aux *.log *blg *~ semantic.cache $(basename $(TARGET)).out 

