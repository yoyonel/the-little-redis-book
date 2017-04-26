SOURCE_FILE_NAME = redis.md
BOOK_FILE_NAME = redis

PDF_BUILDER = pandoc
PDF_BUILDER_FLAGS = \
	--latex-engine xelatex \
	--template ../common/pdf-template.tex \
	--listings

EPUB_BUILDER = pandoc
EPUB_BUILDER_FLAGS = \
	--epub-cover-image

MOBI_BUILDER = kindlegen

#
USER_ID = $(shell id -u ${USER})
GROUP_ID = $(shell id -g ${USER})
#
DOCKER_CMD = docker run \
		-it --rm \
		-v `pwd`:/source \
		-v /etc/group:/etc/group:ro \
		-v /etc/passwd:/etc/passwd:ro \
		-u $(USER_ID):$(GROUP_ID) \
		${DOCKER_ID_USER}/pandoc \
		bash -c

all: book

book: en/redis.pdf en/redis.epub 
	# en/redis.mobi

en/redis.pdf:
	$(DOCKER_CMD) "\
		cd en && \
		$(PDF_BUILDER) $(PDF_BUILDER_FLAGS) $(SOURCE_FILE_NAME) -o $(BOOK_FILE_NAME).pdf \
	"

en/redis.epub: en/title.png en/title.txt en/redis.md
	$(DOCKER_CMD) "\
		$(EPUB_BUILDER) $(EPUB_BUILDER_FLAGS) $^ -o $@"

# ne fonctionne pas, faut installer kindlegen !
en/redis.mobi: en/redis.epub
	$(DOCKER_CMD) "\
		$(MOBI_BUILDER) $^"

clean:
	rm -f */$(BOOK_FILE_NAME).pdf
	rm -f */$(BOOK_FILE_NAME).epub
	rm -f */$(BOOK_FILE_NAME).mobi

.PHONY: all book clean en/redis.pdf en/redis.epub en/redis.mobi