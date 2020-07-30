BOOK = unplugged
BOOK_EN = $(BOOK)-en
BOOK_CN = $(BOOK)-zh-cn
OBJ_EN = $(BOOK_EN).pdf
OBJ_CN = $(BOOK_CN).pdf
XELATEX = $(shell which xelatex > /dev/null)

ifdef XELATEX
LATEX = xelatex
DVIPDFM = echo
else
LATEX = latex
DVIPDFM = dvipdfmx
endif

SRC = unplugged
SRC_EN = $(foreach file, $(SRC), $(file)-en.tex)
SRC_CN = $(foreach file, $(SRC), $(file)-zh-cn.tex)
CHAPTERS = nat/nat recursion/recursion algebra/algebra category-theory/category \
deduction/deduction infinity/infinity paradox/paradox
CHAPTER_OBJ_EN = $(foreach file, $(CHAPTERS), $(file)-en.pdf)
CHAPTER_OBJ_CN = $(foreach file, $(CHAPTERS), $(file)-zh-cn.pdf)
CHAPTER_SRC_EN = $(foreach file, $(CHAPTERS), $(file)-en.tex)
CHAPTER_SRC_EN = $(foreach file, $(CHAPTERS), $(file)-zh-cn.tex)

all: cn en

cn: $(OBJ_CN)

en: $(OBJ_EN)

# only build the dependant images, but not the PDF for performance consideration
%.pdf : %.tex
	$(MAKE) -C $(@D) image

image:
	$(MAKE) -C img

index:
	makeindex $(BOOK)

$(OBJ_CN): image $(SRC_CN) $(CHAPTER_OBJ_CN)
	$(LATEX) $(BOOK_CN).tex
	makeindex $(BOOK_CN).idx
	$(LATEX) $(BOOK_CN).tex
	$(DVIPDFM) $(BOOK_CN)

$(OBJ_EN): image $(SRC_EN) $(CHAPTER_OBJ_EN)
	$(LATEX) $(BOOK_EN).tex
	makeindex $(BOOK_EN).idx
	$(LATEX) $(BOOK_EN).tex
	$(DVIPDFM) $(BOOK_EN)

clean:
	rm -f *.aux *.toc *.lon *.lor *.lof *.ilg *.idx *.ind *.out *.log *.exa

distclean: clean
	rm -f *.pdf *.dvi *~
