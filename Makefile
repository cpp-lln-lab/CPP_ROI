.PHONY: clean install_dev version.txt

clean: clean_lib
	rm -rf coverage*
	rm -f version.txt

clean_lib:
	rm -rf lib/bids-matlab

install_dev:
	git clone https://github.com/bids-standard/bids-matlab.git --branch main --depth 1 lib/bids-matlab

version.txt: CITATION.cff
	grep -w "^version" CITATION.cff | sed "s/version: /v/g" > version.txt

validate_cff: CITATION.cff
	cffconvert --validate
