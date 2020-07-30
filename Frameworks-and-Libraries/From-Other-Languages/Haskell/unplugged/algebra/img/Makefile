IMG_OBJECTS = Escher-Liberation-1955 Gaus Cardano galois \
Rubik_cube_notation Rubik-cube-F lagrange Fermat Arithmetica \
bracelet-rotate bracelet-identical euler Noether Soccer-ball \
C3 A4 S3 GalSign
DOT_OBJECTS =
DOT_SOURCES = $(foreach file, $(DOT_OBJECTS), $(file).dot)

#suffix replacement, replace .dot with .png
PNG_OBJECTS = $(DOT_SOURCES:.dot=.png)

.SUFFIXES: .eps .jpg .jpeg .png .gif .dot .ps

.PHONY: all

all: convert dot

convert: $(IMG_OBJECTS)

# for details, refer to:
#    http://www.gnu.org/software/autoconf/manual/make/
# Makefile syntax, replace each '%' to 'eps
$(IMG_OBJECTS): % : %.eps

# pattern rule matching
# Makefile auto variable: $< first prerequisite, $@ target
%.eps : %.png
	convert -flatten $< $@

%.eps : %.jpg
	convert $< $@

%.eps : %.jpeg
	convert $< $@

%.eps : %.gif
	convert $< $@

dot: $(DOT_OBJECTS)

$(DOT_OBJECTS): % : %.ps

# Makefile auto variable: $< first prerequisite, $@ target
%.ps : %.dot
	dot -Gsize="8,10.5" -Tps -o $@ $<

png: $(PNG_OBJECTS)

%.png : %.dot
	dot -Tpng -o $@ $<

clean:
	rm -f *.eps *~
	rm -f $(PNG_OBJECTS)
