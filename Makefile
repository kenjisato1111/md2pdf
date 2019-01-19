all: pdf

clean:
	rm *.pdf

install: install_haskell install_texlive

install_haskell:
	apt update; \
	apt -y install haskell-platform

install_texlive:
	apt -y install texlive-full

build: build_pandoc build_pandoc_crossref

upgrade_cabal:
	cabal update; \
	cabal install cabal-install

force_upgrade_cabal:
	cabal update; \
	cabal install cabal-install --force-reinstall

build_pandoc:
	mkdir -p pandoc; \
	cd pandoc; \
	cabal sandbox init; \
	cabal install pandoc --force-reinstalls; \
	cp .cabal-sandbox/bin/pandoc ~/.cabal/bin

build_pandoc_crossref:
	mkdir -p pandoc-crossref; \
	cd pandoc-crossref; \
	cabal sandbox init; \
	cabal install pandoc-crossref; \
	cp .cabal-sandbox/bin/pandoc-crossref ~/.cabal/bin

pdf: sample.pdf

sample.pdf:
	pandoc -o sample.pdf \
		-N \
		-f markdown+ignore_line_breaks+footnotes+definition_lists \
		-V CJKmainfont=IPAexGothic \
		-V titlepage=true \
		-V toc-own-page=true \
		-F pandoc-crossref \
		--table-of-contents \
		--toc-depth=3 \
		--pdf-engine=lualatex \
		--template eisvogel \
		--highlight-style tango \
		sample.md
