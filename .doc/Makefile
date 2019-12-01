# convert md to .7, .7 to .7.gz, install it into /usr/local/man/man7
# note the 1st line of markdown is special, it shoulde be:
# % title(section) foot | center title
#                  ^------optional from here
#
# issue: vim complains:
#      <standard input>:1: warning [p 1, 0.0i]: cannot adjust line
#      build/ascii32.70000664000175000017500000001122613570665132013704

BUILD_DIR=build

MDS=$(shell echo *.md)

# *.md to build/*.7
MANS=$(MDS:%.md=$(BUILD_DIR)/%.7)

# build/*.7 to build/*.7.gz
GZS=$(MANS:%=%.gz)

INSTALL_DIR=/usr/local/man/man7

all: $(GZS)

.PHONY: install
install : $(GZS)
	sudo mkdir -p /usr/local/man/man7
	sudo cp $(GZS) /usr/local/man/man7

.phony: clean
uninstall :
	sudo $(RM) $(INSTALL_DIR)/$(GZS:$(BUILD_DIR)/%=%)

%.gz : %
	tar -czvf $@ $<

$(BUILD_DIR)/%.7 : %.md Makefile | build_dir 
    # add header, footer
    # check https://pandoc.org/MANUAL.html for detail
	pandoc -s -t man $< -o $@

build_dir:
	mkdir -p $(BUILD_DIR)

.phony: clean
clean:
	$(RM) $(BUILD_DIR)/*
