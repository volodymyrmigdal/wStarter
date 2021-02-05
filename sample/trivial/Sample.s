let _ = require( 'wstarter' );

let starter = new _.starter.System({ verbosity : 3 });
starter.form();

/*
Starter launches F1.browser.js script in a headless browser
F1.browser.js includes file F2.browser.js
F2.browser.js exports a routine
F1.browser.js calls exported routine
Starter closes the browser when execution is done
*/

console.log( 'Starting browser...' );
starter.start
({
  entryPath : _.path.join( __dirname, './F1.browser.js' ),
  headless : 1,
  timeOut : 5000
})

/* Output:
/sample/trivial/F1.browser.js start
/sample/trivial/F2.browser.js start
/sample/trivial/F2.browser.js end
/sample/trivial/F2.browser.js::routine arguments: arg1 arg2
/sample/trivial/F1.browser.js end
*/

