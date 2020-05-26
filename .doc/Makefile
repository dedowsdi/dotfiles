# *.md to build/*.7
MANS=$(shell echo *.[0-7])

# build/*.7 to build/*.7.gz
GZS=$(MANS:%=%.gz)

all: $(GZS)

.PHONY: install
install : $(GZS)
	sudo mkdir -p /usr/local/man/man7
	sudo mv $(GZS) /usr/local/man/man7

%.gz : %
	gzip -k $<
