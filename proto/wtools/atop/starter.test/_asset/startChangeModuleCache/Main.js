( function _Main_js_()
{

'use strict';

require( './F1.js' );

debugger;
let Module = require( 'module' );
debugger;
let cache = Module._cache;
Module._cache = Object.create( null );

require( './F1.js' );
require( './F2.js' );

Module._cache = cache;

require( './F2.js' );

})();
