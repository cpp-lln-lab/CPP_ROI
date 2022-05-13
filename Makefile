.PHONY: clean install_dev

clean:
	rm -rf coverage*
install_dev:
	git clone https://github.com/bids-standard/bids-matlab.git --branch dev --depth 1 lib/bids-matlab
