/* RequireJS configuration */
/* global module:true */

(function() {
  'use strict';

  var extend = require('extend'),
      requirejsOptions = require('../bower_components/mockup/mockup/js/config'),
      ploneMockupPrefix = 'bower_components/mockup/mockup/',
      requirejsOptionsExtend = {
        paths: {
          'mockup-patterns-minimalpattern': 'patterns/minimalpattern/pattern',
          'mockup-bundles-minimalpattern': 'js/bundles/minimalpattern',
        },
        shim: {}
      };

  // fix paths for mockup patterns and resources
  for (var p in requirejsOptions.paths) {
    if(requirejsOptions.paths[p].indexOf('bower_components/') === -1) {
      requirejsOptions.paths[p] = ploneMockupPrefix + requirejsOptions.paths[p];
    }
  }
  extend(true, requirejsOptions, requirejsOptionsExtend);

  if (typeof exports !== 'undefined' && typeof module !== 'undefined') {
    module.exports = requirejsOptions;
  }
  if (typeof requirejs !== 'undefined' && requirejs.config) {
    requirejs.config(requirejsOptions);
  }

}());
