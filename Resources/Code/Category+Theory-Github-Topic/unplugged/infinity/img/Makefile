IMG_OBJECTS = circle-limit-IV-1960 circle-limit-III-1959 Archimedes Zeno \
Achilles-paradox Dichotomy-paradox Arrow-paradox Moving-rows-paradox Aristotle \
Archimedes-book pi-exhaustion stream-cons circles-paradox Cantor Cantor-1870 \
Hilbert-hotel-1 Hilbert-hotel-2 bijection PWW Dedekind Dedekind-cut Flammarion \
Turner-Snow-Storm starry-night canon-endless Omega-exp-omega
DOT_OBJECTS =
DOT_SOURCES = $(foreach file, $(DOT_OBJECTS), $(file).dot)

#suffix replacement, replace .dot with .png
PNG_OBJECTS = $(DOT_SOURCES:.dot=.png)

.SUFFIXES: .eps .jpg .jpeg .png .gif .dot .ps .svg

.PHONY: all

all: convert dot

convert: $(IMG_OBJECTS)

# for details, refer to:
#    http://www.gnu.org/software/autoconf/manual/make/
# Makefile syntax, replace each '%' to 'eps
$(IMG_OBJECTS): % : %.eps

# pattern rule matching
# Makefile auto variable: $< first prerequisite, $@ target
# -flattern deal with the transparent color
%.eps : %.png
	convert -flatten $< $@

%.eps : %.svg
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
	rm -f *.ps *.eps *~
	rm -f $(PNG_OBJECTS)
