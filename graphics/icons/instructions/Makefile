ifndef RECURSING
.DEFAULT all:
	@$(MAKE) RECURSING=true $@ -j4 --no-print-directory
	@echo ""
else
ifndef ECHO
HIT_TOTAL != ${MAKE} ${MAKECMDGOALS} --dry-run ECHO="HIT_MARK" | grep -c "HIT_MARK"
HIT_COUNT = $(eval HIT_N != expr ${HIT_N} + 1)${HIT_N}
ECHO = echo "\033[2K(`expr ${HIT_COUNT} '*' 100 / ${HIT_TOTAL}`%)"
#ECHO = echo [${HIT_COUNT}/${HIT_TOTAL}]
RETURN = echo "\033[2A"
endif

.SECONDARY:
.SILENT:
.PHONY : all clean

all: .tmp/gen.png h0x h1x h2x h3x h4x h5x h6x h7x
	@$(ECHO) rule $@ ; $(RETURN)

clean:
	@rm -rfv .tmp

h%x: pci-%0.png pci-%1.png pci-%2.png pci-%3.png pci-%4.png pci-%5.png pci-%6.png pci-%7.png pci-%8.png pci-%9.png pci-%A.png pci-%B.png pci-%C.png pci-%D.png pci-%E.png pci-%F.png
	@true

hx%: pci-0%.png pci-1%.png pci-2%.png pci-3%.png pci-4%.png pci-5%.png pci-6%.png pci-7%.png pci-8%.png pci-9%.png pci-A%.png pci-B%.png pci-C%.png pci-D%.png pci-E%.png pci-F%.png
	@true

pci-%.png: .tmp/pci-%.png
	@$(ECHO) copy $@ from $< ; $(RETURN)
	@cp $< $@

.tmp/pci-%.png: .tmp/pci-%.svg .tmp/gen.xml
	@$(ECHO) render $@ from $< ; $(RETURN)
	@if test -f "$@" && test -f "$<.old" && diff $<.old $<; then touch $@; else \
		dbus-run-session inkscape --without-gui $< --export-png=$@ --export-id=$(basename $(notdir $@)) > /dev/null; \
		cp $< $<.old; \
	fi;


.tmp/gen.png: .tmp/gen.svg .tmp/gen.xml
	@$(ECHO) render $@ from $< ; $(RETURN)
	@dbus-run-session inkscape --without-gui $< --export-png=$@ > /dev/null

.tmp/pci-%.svg: .tmp/pci-%.xml .tmp/XX.png .tmp/instructions.xsl
	@$(ECHO) build $@ from $< ; $(RETURN)
	@xsltproc $< > $@

.tmp/gen.svg: .tmp/gen.xml .tmp/XX.png .tmp/instructions.xsl .tmp
	@$(ECHO) build $@ from $< ; $(RETURN)
	@xsltproc $< > $@

.tmp/pci-%.xml: .tmp/gen.xml .tmp
	@$(ECHO) build $@ from $< ; $(RETURN)
	@awk '!/<instruction / ||/id="$*"/' $<	> $@

.tmp/gen.xml: ../../../instructions.lua .tmp
	@$(ECHO) extract $@ from $< ; $(RETURN)
	@cat $< | grep "\-\-<>" | cut -b 6- > $@

.tmp/XX.png: .src/XX.png .tmp
	@$(ECHO) copy $@ from $< ; $(RETURN)
	@cp $< $@

.tmp/instructions.xsl: .src/instructions.xsl .tmp
	@$(ECHO) copy $@ from $< ; $(RETURN)
	@cp $< $@

.tmp:
	mkdir .tmp

endif
