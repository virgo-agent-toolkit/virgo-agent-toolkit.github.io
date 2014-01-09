%.html:	%.md style.css Makefile
	pandoc -s --smart -f markdown -t html -c bootstrap.min.css -c bootstrap.responsive.min.css -c style.css --standalone -o $@ $<

default: index.html
