define([
  'expect',
  'jquery',
  'pat-registry',
  'mockup-patterns-minimalpattern',
], function(expect, $, registry, minimalpattern) {
  'use strict';

  window.mocha.setup('bdd');
  $.fx.off = true;

  describe('Minimalpattern', function () {

    afterEach(function() {
      $('body').empty();
    });

    it('Just works.', function() {

      var $doc = $('<div class="pat-minimalpattern"></div>').appendTo('body');
      registry.scan($doc);

      var $el = $('.pat-minimalpattern');
      expect($el.text()).to.be.equal("ey ya!");

    });

  });
});
