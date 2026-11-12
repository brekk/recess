BUILD_DIR := ./build
SRC_DIR := ./src

version.lock:
	madlib install

README.md: madlib.json
	pilcrow -i README.md --repo brekk/recess --auto

.PHONY: clean
clean:
	rm -r $(BUILD_DIR)
