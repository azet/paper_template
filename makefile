TARGET?=paper
PUBLICATION?=authorversion

LL=latexmk -pdf -f -shell-escape -interaction=nonstopmode
CLEAN=latexmk -C
GITKEY=$(shell git config --global user.signingkey)
TIMESTAMP=$(shell date +"%s")

all: git $(TARGET)
pdf: all
.PHONY: clean git $(TARGET)

$(TARGET): $(TARGET).tex
	$(LL) $<

git:
	echo "%% I belong to makefile!" > git.tex
	git log -1 --format="format:\
		\\gdef\\gitabbrhash{%h} \
		\\gdef\\gitbranch{%D} 	\
		\\gdef\\gitcommuser{%cN}\
		\\gdef\\gitcommmail{%cE}\
		\\gdef\\gitauthuser{%aN}\
		\\gdef\\gitauthmail{%aE}\
		\\gdef\\gitauthdate{%aI}" >> git.tex

submission: git $(TARGET)
	git tag -s -m 'automatically tagged via "make submission"' \
		"$(TARGET)-$(PUBLICATION)@$(TIMESTAMP)+$(GITKEY)"

clean:
	$(CLEAN)

genocide: clean
	test -f *.pdf && rm *.pdf
	test -f git.tex && rm git.tex

#EOF
