.SILENT:
.ONESHELL:
.PHONY: all instructions-icons

all: instructions-icons instruction-locale files.lua
	true

files.lua: Makefile
	echo "== Building file list"
	TARGET=$@
	FOLDER=$(dir $(abspath $@))
	MODNAME=__$$(cat $(dir $(abspath $@))info.json | jq -r ".name")__
	echo $$TARGET $$FOLDER $$MODNAME
	echo "return {"> $@
	prefix() { while read line; do echo "${1}${line}"; done; }
	suffix() { while read line; do echo "${line}${1}"; done; }

	find . -not -path '*/\.*' -print | cut -b 2- | tail -n +2 | while read line; do echo "\t[\"$$MODNAME$$line\"]=true,"; done >> $@
	echo "}">> $@

instructions-icons:
	echo "== Building instructions icons"
	cd graphics/icons/instructions;$(MAKE) all --no-print-directory

instruction-locale:
	echo "== Building instructions locale"
	#cat $< | grep "\-\-@@" | cut -b 6- > locale/en/instructions.cfg
	#echo done
