all: addsub.pdf

new:
	rm -f addsub.tex
	$(MAKE) addsub.pdf

%.pdf: %.tex
	latexmk -pdf $*

%.exe: %.hs
	ghc -Wall -Werror --make -o $@ $^ -main-is $*

addsub.tex: addsub.tpl MkAddSub.exe
	./MkAddSub.exe 8 $< $@

clean:
	rm -f *.log *.aux *.fdb_latexmk *.synctex.gz *.fls
	rm -f MkAddSub.exe
	rm -f *.o *.hi
	rm -f addsub.pdf addsub.tex

.PHONY: all clean
