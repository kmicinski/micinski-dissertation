# Makefile for Android GUI declassification paper

PDFLATEX=pdflatex -halt-on-error -file-line-error --shell-escape

TEXFILE=paper.tex
BIBIDENT=paper

default: paper.pdf

# Use LaTeX to process .tex files after generating them with Ott
paper.pdf: $(TEXFILE)
	$(PDFLATEX) $(TEXFILE)
	bibtex $(BIBIDENT)
	$(PDFLATEX) $(TEXFILE)
	$(PDFLATEX) $(TEXFILE)

clean:
	rm -rf *.aux *.lgpl *.log *.bbl *.blg *.pdf
