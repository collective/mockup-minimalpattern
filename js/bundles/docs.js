/* Minimalpattern documentation bundle
 *
 */

require([
  'mockup-docs',         // We need mockup's `mockup-doc` pattern,
  'bootstrap-collapse',  // Bootstrap collapse for expanding the pattern title to a pattern, if we click on it,
  'mockup-fakeserver'    // And mockup's fakeserver.
], function(Docs) {
  'use strict';

  var docs = new Docs({
    pages: [
      { // Index page.
        id: 'index',
        title: 'Mockup',
        description: 'A collection of client side patterns for faster and easier ' +
                     'web  development',
        text: '[See it in action!](#pattern)',
        autotoc: false
      },
      { // Patterns page.
        id: 'pattern',
        title: 'Patterns',
        description: 'All the patterns you\'ll ever need',
        autotoc: false,
        patterns: [
          { // Minimalpattern page
            id: 'minimalpattern',  // pattern id.
            title: 'Minimalpattern',  // pattern title.
            description: 'A minimal pattern',  // pattern description.
            url: 'patterns/minimalpattern/pattern.js'  // path to the pattern within the project structure.
          }
        ]
      }
    ]

  });

  return docs; // RequireJS expects you to return, what you want to expose to other modules.
});
