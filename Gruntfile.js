/* globals module:true */
module.exports = function(grunt) {
  'use strict';

  // Get mockup-core's grunt infrastructure
  var MockupGrunt = require('./bower_components/mockup/mockup/js/grunt');

  // Include the project's RequireJS configuration
  var requirejsOptions = require('./js/config');

  // Create a new insance of the Mockup grunt task suite.
  var mockup = new MockupGrunt(requirejsOptions);

  // list of resources, which should be included for the documentation.
  var docsExtraIncludes = [];

  // Get all patterns and include their paths in the documentation
  for (var i = 0; i < mockup.patterns.length; i = i + 1) {
    if (mockup.patterns[i].indexOf('-url') === -1) {
      docsExtraIncludes.push(mockup.patterns[i]);
      docsExtraIncludes.push('text!' + requirejsOptions.paths[mockup.patterns[i]] + '.js');
    }
  }

  // Register the docs bundle with some custom config.
  mockup.registerBundle('docs',
    {less: {options: {modifyVars: {bowerPath: '"bower_components/"' }}}},
    {extraInclude: docsExtraIncludes},
    ['requirejs', 'uglify', 'less',]
  );

  // Register the Minimalpattern pattern
  mockup.registerBundle('minimalpattern');

  // initialize grunt and set up all tasks.
  mockup.initGrunt(grunt);
};
