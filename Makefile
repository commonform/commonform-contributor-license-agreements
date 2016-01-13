COMMONFORM=./node_modules/.bin/commonform
TARGETS=icla cla-corporate
SOURCE=terms.cform

all: $(TARGETS:=.docx) $(TARGETS:=.pdf) $(TARGETS:=.txt)

$(COMMONFORM):
	npm i commonform-cli@0.12.x

%.docx: %.cform %.blanks.json %.sigs.json %.options $(COMMONFORM)
	$(COMMONFORM) render \
		-f docx \
		-b $*.blanks.json \
		-s $*.sigs.json \
		$(shell cat $*.options) \
		< $< > $@

%.pdf: %.docx
	doc2pdf $<

%.txt: %.docx
	docx2txt < $< \
		| tr '\t' ' ' \
		| awk '1; {print ""}' \
		> $@

.PHONY: test lint critique clean

test: lint critique

lint: $(COMMONFORM)
	$(COMMONFORM) lint < $(SOURCE)

critique: $(COMMONFORM)
	$(COMMONFORM) critique < $(SOURCE)

clean:
	rm -rf $(TARGETS)
