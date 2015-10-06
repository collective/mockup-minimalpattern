# Name of git binary in path or path to it
GIT = git
# Name of npm binary in path or path to it
NPM = npm

# When doing ``npm link``, we have to deal with different node versions
# differently. So,
# First get the node version, e.g. "0.11.12"
NODE_VERSION = $(shell node -v)
# Now get the major version, e.g. "0"
NODE_VERSION_MAJ = $(shell echo $(NODE_VERSION) | cut -f1 -d. | cut -f2 -dv )
# Then get the minor version, E.g. 11
NODE_VERSION_MIN = $(shell echo $(NODE_VERSION) | cut -f2 -d.)
# Finally, test , the version is below "0.11", E.g. "0.10"
NODE_VERSION_LT_011 = $(shell [ $(NODE_VERSION_MAJ) -eq 0 -a $(NODE_VERSION_MIN) -lt 11 ] && echo true)

# Path to the project's local grunt binary.
GRUNT = ./node_modules/grunt-cli/bin/grunt
# Path to the project's local bower binary.
BOWER = ./node_modules/bower/bin/bower
# Path to the directory, where all node_modules are stored.
NODE_PATH = ./node_modules

# Initialize DEBUG and VERBOSE mode for grunt. Arguments to the `make` script
# land in $(ARGUMENT_NAME) variables.
# In this case, DEBUG is invoked e.g. with: `make all debug=true`
DEBUG =
ifeq ($(debug), true)
	DEBUG = --debug
endif
VERBOSE =
ifeq ($(verbose), true)
	VERBOSE = --verbose
endif


# Make tasks

plone:
	./cleanup-plone.sh
	virtualenv .
	./bin/pip install zc.buildout
	./bin/buildout

plone4:
	./cleanup-plone.sh
	virtualenv .
	./bin/pip install zc.buildout
	./bin/buildout -c buildout-plone4.cfg

# All runs tasks test-once, bundles
all: test-once bundle-minimalpattern

# Minimalpattern build task
bundle-minimalpattern:
	mkdir -p build
	NODE_PATH=$(NODE_PATH) $(GRUNT) bundle-minimalpattern $(DEBUG) $(VERBOSE) --gruntfile=src/mockup-minimalpattern/js/Gruntfile.js

bootstrap: clean
	mkdir -p build
	@echo node version: $(NODE_VERSION)
ifeq ($(NODE_VERSION_LT_011),true)
	# for node < v0.11.x
	$(NPM) link --prefix=.
else
	$(NPM) link
endif
	NODE_PATH=$(NODE_PATH) $(BOWER) install --config.interactive=0
	NODE_PATH=$(NODE_PATH) $(GRUNT) sed:bootstrap $(DEBUG) $(VERBOSE) --gruntfile=src/mockup-minimalpattern/js/Gruntfile.js

# JSHint checker task
jshint:
	NODE_PATH=$(NODE_PATH) $(GRUNT) jshint $(DEBUG) $(VERBOSE) --gruntfile=src/mockup-minimalpattern/js/Gruntfile.js

# Run grunt and watch for changes.
watch:
	NODE_PATH=$(NODE_PATH) $(GRUNT) watch $(DEBUG) $(VERBOSE) --gruntfile=src/mockup-minimalpattern/js/Gruntfile.js

# Run tests headless via PhantomJS and watch for changes.
test:
	NODE_PATH=$(NODE_PATH) $(GRUNT) test $(DEBUG) $(VERBOSE) --pattern=$(pattern) --gruntfile=src/mockup-minimalpattern/js/Gruntfile.js

# Run the tests headless with PhantomJS only once and exit.
test-once:
	NODE_PATH=$(NODE_PATH) $(GRUNT) test_once $(DEBUG) $(VERBOSE) --pattern=$(pattern) --gruntfile=src/mockup-minimalpattern/js/Gruntfile.js

# Run the tests for Chromium and watch for changes.
test-dev:
	NODE_PATH=$(NODE_PATH) $(GRUNT) test_dev $(DEBUG) $(VERBOSE) --pattern=$(pattern) --gruntfile=src/mockup-minimalpattern/js/Gruntfile.js

# Cleanup the project and remove directories set up by previous tasks 
clean:
	mkdir -p build
	rm -rf build
	rm -rf node_modules
	rm -rf mockup/bower_components

# Also clean bower and npm caches.
clean-deep: clean
	if test -f $(BOWER); then $(BOWER) cache clean; fi
	if test -f $(NPM); then $(NPM) cache clean; fi

# Expose these options to the command line shell expansion mechanism
.PHONY: all plone plone4 bundle-minimalpattern bootstrap jshint watch test test-once test-dev clean clean-deep
