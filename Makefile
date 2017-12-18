BOOK=ifpl2
TEX=pdflatex
FLAGS=-halt-on-error -shell-escape
TARGET=1000

all: pdf count

test: pdf testcount

quick:
	$(TEX) $(FLAGS) $(BOOK).tex

pdf: *.tex literature.bib
	$(TEX) -draftmode $(FLAGS) $(BOOK).tex
	bibtex $(BOOK)
	$(TEX) -draftmode $(FLAGS) $(BOOK).tex
	makeindex $(BOOK)
	$(TEX) $(FLAGS) $(BOOK).tex
	detex $(BOOK).tex | wc -w

count: *.tex
	echo "$$(date -u +"%F %T"),$$(detex $(BOOK).tex | wc -w)" >> wordcount.csv
	tail wordcount.csv

testcount: *.tex
	echo "($$(tail -1 wordcount.csv | awk -F, '{print $$2}')+$(TARGET))-$$(detex $(BOOK).tex | wc -w)" | bc

clean:
	rm -f $(BOOK).aux $(BOOK).bbl $(BOOK).blg $(BOOK).log $(BOOK).pdf $(BOOK).idx  $(BOOK).ilg $(BOOK).ind *.log
