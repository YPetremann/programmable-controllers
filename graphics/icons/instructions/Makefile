.SECONDARY:

all: h0x h1x h2x h3x h4x h5x h6x h7x
	@true

h%x: pci-%0.png pci-%1.png pci-%2.png pci-%3.png pci-%4.png pci-%5.png pci-%6.png pci-%7.png pci-%8.png pci-%9.png pci-%A.png pci-%B.png pci-%C.png pci-%D.png pci-%E.png pci-%F.png
	@true

hx%: pci-0%.png pci-1%.png pci-2%.png pci-3%.png pci-4%.png pci-5%.png pci-6%.png pci-7%.png pci-8%.png pci-9%.png pci-A%.png pci-B%.png pci-C%.png pci-D%.png pci-E%.png pci-F%.png
	@true

pci-%.png: .tmp/gen.svg
	inkscape $^ -e $@ -i $@

.tmp/XX.png: .src/XX.png
	cp $^ $@

.tmp/gen.svg: .src/model.xml .tmp/XX.png
	xsltproc $^ > $@

.tmp/gen.png:
	inkscape $^ -e $@

.tmp:
	mkdir .tmp
