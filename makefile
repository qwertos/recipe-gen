
all:

install: /usr/local/bin/recipe-gen


/usr/local/lib/recipe-gen:
	mkdir -p /usr/local/lib/recipe-gen

/usr/local/lib/recipe-gen/texml.xsl: /usr/local/lib/recipe-gen texml.xsl
	cp texml.xsl /usr/local/lib/recipe-gen/texml.xsl

/usr/local/bin:
	mkdir -p /usr/local/bin

/usr/local/bin/recipe-gen: /usr/local/bin recipe-gen /usr/local/lib/recipe-gen/texml.xsl
	cp recipe-gen /usr/local/bin/recipe-gen


remove:
	rm -rf /usr/local/lib/recipe-gen
	rm -f /usr/local/bin/recipe-gen


