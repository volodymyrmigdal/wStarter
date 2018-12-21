( function _Selector_test_s_() {

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );

  _.include( 'wTesting' );

  require( '../l3/Selector.s' );

}

var _global = _global_;
var _ = _global_.wTools;

// --
// tests
// --

function selectTrivial( test )
{

  test.open( 'trivial' );

  /* */

  var got = _.select( undefined, '' );
  test.identical( got, undefined );

  var got = _.select( undefined, '/' );
  test.identical( got, undefined );

  var got = _.select( null, '' );
  test.identical( got, null );

  var got = _.select( null, '/' );
  test.identical( got, null );

  /* */

  var container =
  {
    a : 11,
    b : 13,
    c : 15,
  }

  var got = _.select( container, 'b' );

  test.identical( got, 13 );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { name : 'name3', value : 55, buffer : new Float32Array([ 1,2,3 ]) },
    d : { name : 'name4', value : 25, date : new Date() },
  }

  var got = _.select( container, '*/name' );

  test.identical( got, { a : 'name1', b : 'name2', c : 'name3', d : 'name4' } );

  /* */

  var container =
  [
    { name : 'name1', value : 13 },
    { name : 'name2', value : 77 },
    { name : 'name3', value : 55, buffer : new Float32Array([ 1,2,3 ]) },
    { name : 'name4', value : 25, date : new Date() },
  ]

  var got = _.select( container, '*/name' );

  test.identical( got, [ 'name1', 'name2', 'name3', 'name4' ] );

  /* */

  var container =
  {
    a : { a1 : 1, a2 : 'a2' },
    b : { b1 : 1, b2 : 'b2' },
    c : { c1 : 1, c2 : 'c2' },
  }

  var got = _.select( container, 'b/b2' );

  test.identical( got, 'b2' );

  /* */

  test.close( 'trivial' );
  test.open( 'usingIndexedAccessToMap' );

  /* */

  var container =
  {
    a : { map : { name : 'name1' }, value : 13 },
    c : { value : 25, date : 53 },
  }

  var got = _.select
  ({
    container : container,
    query : '*/1',
    usingIndexedAccessToMap : 1,
  });

  test.identical( got, { a : 13, c : 53 } );

  /* */

  test.close( 'usingIndexedAccessToMap' );

}

//

function selectMultiple( test )
{

  var container =
  {
    a : { map : { name : 'name1' }, value : 13 },
    b : { b1 : 1, b2 : 'b2' },
    c : { c1 : 1, c2 : 'c2' },
  }

  var expected = [ { b1 : 1, b2 : 'b2' }, { c1 : 1, c2 : 'c2' } ];
  var got = _.select( container, [ 'b', 'c' ] );

  test.identical( got, expected );

}

//

function selectMissing( test )
{

  test.open( 'missingAction:undefine' );

  /* */

  var container =
  {
    a : { map : { name : 'name1' }, value : 13 },
    b : { map : { name : 'name2' }, value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    container : container,
    query : 'a/map/name',
    missingAction : 'undefine',
  });

  test.identical( got, 'name1' );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    container : container,
    query : 'x',
    missingAction : 'undefine',
  })

  test.identical( got, undefined );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    container : container,
    query : 'x/x',
    missingAction : 'undefine',
  })

  test.identical( got, undefined );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    container : container,
    query : 'x/x/x',
    missingAction : 'undefine',
  })

  test.identical( got, undefined );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    container : container,
    query : '*/name',
    missingAction : 'undefine',
  });

  test.identical( got, { a : 'name1', b : 'name2', d : undefined } );

  /* */

  var container =
  {
    a : { map : { name : 'name1' }, value : 13 },
    b : { map : { name : 'name2' }, value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    container : container,
    query : '*/map/name',
    missingAction : 'undefine',
  });

  test.identical( got, { a : 'name1', b : 'name2', c : undefined } );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    container : container,
    query : '*',
    missingAction : 'undefine',
  })

  test.identical( got, container );
  test.is( got !== container );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    container : container,
    query : '*/*',
    missingAction : 'undefine',
  })

  test.identical( got, container );
  test.is( got !== container );

  /* */

  var expected =
  {
    a : { name : undefined, value : undefined },
    c : { value : undefined, date : undefined },
  }

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    container : container,
    query : '*/*/*',
    missingAction : 'undefine',
  })

  test.identical( got, expected );
  test.is( got !== container );

  /* */

  var expected =
  {
    a : { name : undefined, value : undefined },
    c : { value : undefined, date : undefined },
  }

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    container : container,
    query : '*/*/*/*',
    missingAction : 'undefine',
  })

  test.identical( got, expected );
  test.is( got !== container );

  /* */

  test.close( 'missingAction:undefine' );
  test.open( 'missingAction:ignore' );

  /* */

  var container =
  {
    a : { map : { name : 'name1' }, value : 13 },
    b : { map : { name : 'name2' }, value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    container : container,
    query : 'a/map/name',
    missingAction : 'ignore',
  });

  test.identical( got, 'name1' );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    container : container,
    query : 'x',
    missingAction : 'ignore',
  })

  test.identical( got, undefined );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    container : container,
    query : 'x/x',
    missingAction : 'ignore',
  })

  test.identical( got, undefined );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    container : container,
    query : 'x/x/x',
    missingAction : 'ignore',
  })

  test.identical( got, undefined );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    container : container,
    query : '*/name',
    missingAction : 'ignore',
  });

  test.identical( got, { a : 'name1', b : 'name2' } );

  /* */

  var container =
  {
    a : { map : { name : 'name1' }, value : 13 },
    b : { map : { name : 'name2' }, value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    container : container,
    query : '*/map/name',
    missingAction : 'ignore',
  });

  test.identical( got, { a : 'name1', b : 'name2' } );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    container : container,
    query : '*',
    missingAction : 'ignore',
  })

  test.identical( got, container );
  test.is( got !== container );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    container : container,
    query : '*/*',
    missingAction : 'ignore',
  })

  test.identical( got, container );
  test.is( got !== container );

  /* */

  var expected =
  {
    a : {},
    c : {},
  }

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    container : container,
    query : '*/*/*',
    missingAction : 'ignore',
  })

  test.identical( got, expected );
  test.is( got !== container );

  /* */

  var expected =
  {
    a : {},
    c : {},
  }

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    container : container,
    query : '*/*/*/*',
    missingAction : 'ignore',
  })

  test.identical( got, expected );
  test.is( got !== container );

  /* */

  test.close( 'missingAction:ignore' );
  test.open( 'missingAction:ignore + restricted selector' );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    container : container,
    query : '*=2/name',
    missingAction : 'ignore',
  });

  test.identical( got, { a : 'name1', b : 'name2' } );

  test.shouldThrowErrorSync( () => _.select
  ({
    container : container,
    query : '*=1/name',
    missingAction : 'ignore',
  }));

  /* */

  var container =
  {
    a : { map : { name : 'name1' }, value : 13 },
    b : { map : { name : 'name2' }, value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    container : container,
    query : '*=2/map/name',
    missingAction : 'ignore',
  });

  test.identical( got, { a : 'name1', b : 'name2' } );

  test.shouldThrowErrorSync( () => _.select
  ({
    container : container,
    query : '*=3/name',
    missingAction : 'ignore',
  }));

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    container : container,
    query : '*=2',
    missingAction : 'ignore',
  })

  test.identical( got, container );
  test.is( got !== container );

  test.shouldThrowErrorSync( () => _.select
  ({
    container : container,
    query : '*=3',
    missingAction : 'ignore',
  }));

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    container : container,
    query : '*=2/*=2',
    missingAction : 'ignore',
  })

  test.identical( got, container );
  test.is( got !== container );

  test.shouldThrowErrorSync( () => _.select
  ({
    container : container,
    query : '*=3/*=2',
    missingAction : 'ignore',
  }));

  test.shouldThrowErrorSync( () => _.select
  ({
    container : container,
    query : '*=2/*=3',
    missingAction : 'ignore',
  }));

  /* */

  var expected =
  {
    a : {},
    c : {},
  }

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    container : container,
    query : '*=2/*=0/*=0',
    missingAction : 'ignore',
  })

  test.identical( got, expected );
  test.is( got !== container );

  test.shouldThrowErrorSync( () => _.select
  ({
    container : container,
    query : '*=1/*=0/*=0',
    missingAction : 'ignore',
  }));

  test.shouldThrowErrorSync( () => _.select
  ({
    container : container,
    query : '*=2/*=1/*=0',
    missingAction : 'ignore',
  }));

  test.shouldThrowErrorSync( () => _.select
  ({
    container : container,
    query : '*=2/*=0/*=1',
    missingAction : 'ignore',
  }));

  /* */

  var expected =
  {
    a : {},
    c : {},
  }

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    container : container,
    query : '*=2/*=0/*=0/*=0',
    missingAction : 'ignore',
  })

  test.identical( got, expected );
  test.is( got !== container );

  /* */

  test.close( 'missingAction:ignore + restricted selector' );
  test.open( 'missingAction:error' );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    container : container,
    query : 'x',
    missingAction : 'error',
  });

  test.is( got instanceof _.ErrorLooking );
  console.log( got );

  var got = _.select
  ({
    container : container,
    query : 'x/x',
    missingAction : 'error',
  });

  test.is( got instanceof _.ErrorLooking );
  console.log( got );

  var got = _.select
  ({
    container : container,
    query : '*/x',
    missingAction : 'error',
  });

  test.is( got instanceof _.ErrorLooking );
  console.log( got );

  var got = _.select
  ({
    container : container,
    query : '*/*/*',
    missingAction : 'error',
  });

  test.is( got instanceof _.ErrorLooking );
  console.log( got );

  var got = _.select
  ({
    container : container,
    query : '..',
    missingAction : 'error',
  });

  test.is( got instanceof _.ErrorLooking );
  console.log( got );

  var got = _.select
  ({
    container : container,
    query : 'a/../..',
    missingAction : 'error',
  });

  test.is( got instanceof _.ErrorLooking );
  console.log( got );

  /* */

  test.close( 'missingAction:error' );
  test.open( 'missingAction:throw' );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  // if( Config.debug )
  test.shouldThrowErrorSync( () => _.select
  ({
    container : container,
    query : 'x',
    missingAction : 'throw',
  }));

  // if( Config.debug )
  test.shouldThrowErrorSync( () => _.select
  ({
    container : container,
    query : 'x/x',
    missingAction : 'throw',
  }));

  // if( Config.debug )
  test.shouldThrowErrorSync( () => _.select
  ({
    container : container,
    query : '*/x',
    missingAction : 'throw',
  }));

  // if( Config.debug )
  test.shouldThrowErrorSync( () => _.select
  ({
    container : container,
    query : '*/*/*',
    missingAction : 'throw',
  }));


  // if( Config.debug )
  test.shouldThrowErrorSync( () => _.select
  ({
    container : container,
    query : '..',
    missingAction : 'throw',
  }));

  // if( Config.debug )
  test.shouldThrowErrorSync( () => _.select
  ({
    container : container,
    query : 'a/../..',
    missingAction : 'throw',
  }));

  /* */

  test.close( 'missingAction:throw' );
}

//

function selectSet( test )
{

  /* */

  var expected =
  {
    a : { name : 'x', value : 13 },
    b : { name : 'x', value : 77 },
    c : { name : 'x', value : 25, date : new Date() },
  }

  var container =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    container : container,
    query : '*/name',
    set : 'x',
    missingAction : 'undefine',
  });

  test.identical( got, { a : 'name1', b : 'name2', c : undefined } );
  test.identical( container, expected );

  /* */

  var container = {};
  var expected = { a : 'c' };

  var got = _.select
  ({
    container : container,
    query : '/a',
    set : 'c',
    setting : 1,
  });

  test.identical( got, undefined );
  test.identical( container, expected );

  /* */

  var container = {};
  var expected = { '1' : {} };

  var got = _.select
  ({
    container : container,
    query : '/1',
    set : {},
    setting : 1,
    usingIndexedAccessToMap : 0,
  });

  test.identical( got, undefined );
  test.identical( container, expected );

  /* */

  var container = {};
  var expected = {};

  var got = _.select
  ({
    container : container,
    query : '/1',
    set : {},
    setting : 1,
    usingIndexedAccessToMap : 1,
  });

  test.identical( got, undefined );
  test.identical( container, expected );

  /* */

  var container = { a : '1', b : '1' };
  var expected = { a : '1', b : '2' };

  var got = _.select
  ({
    container : container,
    query : '/1',
    set : '2',
    setting : 1,
    usingIndexedAccessToMap : 1,
  });

  test.identical( got, '1' );
  test.identical( container, expected );

  /* */

  test.shouldThrowErrorSync( () => _.select
  ({
    container : {},
    query : '/',
    set : { a : 1 },
    setting : 1,
  }));

  /* */

  test.shouldThrowErrorSync( () => _.select
  ({
    container : {},
    query : '/a/b',
    set : 'c',
    setting : 1,
    missingAction : 'throw',
  }));

  /* */

  test.shouldThrowErrorSync( () => _.select
  ({
    container : {},
    query : '/a/b',
    set : 'c',
    setting : 1,
    missingAction : 'ignore',
  }));

  /* */

  test.shouldThrowErrorSync( () => _.select
  ({
    container : {},
    query : '/a/b',
    set : 'c',
    setting : 1,
    missingAction : 'undefine',
  }));

}

//

function selectWithDown( test )
{

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select( container, '' );

  test.identical( got, container );
  test.is( got === container );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select( container, '/' );

  test.identical( got, container );
  test.is( got === container );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select( container, 'a/..' );

  test.identical( got, container );
  test.is( got === container );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select( container, 'a/name/..' );

  test.identical( got, container.a );
  test.is( got === container.a );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select( container, 'a/name/../..' );

  test.identical( got, container );
  test.is( got === container );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select( container, 'a/name/../../a/name' );

  test.identical( got, container.a.name );
  test.is( got === container.a.name );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select( container, 'a/../a/../a/name' );

  test.identical( got, container.a.name );
  test.is( got === container.a.name );

  /* */

  var container =
  {
    a : { b : { c : { d : 'e' } } },
  }

  var got = _.select( container, 'a/b/c/../../b/../b/c/d' );

  test.is( got === container.a.b.c.d );

  /* */

  var container =
  {
    a : { b : { c : { d : 'e' } } },
  }

  var got = _.select( container, 'a/b/c/../../b/../b/c' );

  test.is( got === container.a.b.c );

  /* */

  var container =
  {
    a : { b : { c : { d : 'e' } } },
  }

  var got = _.select( container, 'a/b/c/../../b/../b/c/..' );

  test.is( got === container.a.b );

  /* */

  var container =
  {
    a : { b : { c : { d : 'e' } } },
  }

  var got = _.select( container, 'a/b/c/../../b/../b/c/../../..' );

  test.is( got === container );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var it = _.selectAct( container, 'a/name' );

  test.identical( it.result, container.a.name );
  test.is( it.result === container.a.name );

  var it = _.selectAct( it.lastSelect.reiteration(), '../../b/name' );

  test.identical( it.result, container.b.name );
  test.is( it.result === container.b.name );

  var it = _.selectAct( it.lastSelect.reiteration(), '..' );

  test.identical( it.result, container.b );
  test.is( it.result === container.b );

}

//

function selectWithGlob( test )
{

  var container =
  {
    aaY : { name : 'a', value : 1 },
    bbN : { name : 'b', value : 2 },
    ccY : { name : 'c', value : 3 },
    ddNx : { name : 'd', value : 4 },
    eeYx : { name : 'e', value : 5 },
  }

  /* */

  test.description = 'trivial';

  var expected = { aaY : { name : 'a', value : 1 } };
  var got = _.select( container, 'a*' );
  test.identical( got, expected );
  test.is( got.aaY === container.aaY );

  var expected = { aaY : { name : 'a', value : 1 }, ccY : { name : 'c', value : 3 } };
  var got = _.select( container, '*Y' );
  test.identical( got, expected );
  test.is( got.aaY === container.aaY && got.ccY === container.ccY );

  var expected = { aaY : { name : 'a', value : 1 } };
  var got = _.select( container, 'a*Y' );
  test.identical( got, expected );
  test.is( got.aaY === container.aaY );

  var expected = { aaY : { name : 'a', value : 1 } };
  var got = _.select( container, '*a*' );
  test.identical( got, expected );
  test.is( got.aaY === container.aaY );

  /* */

  test.description = 'second level';

  var expected = { aaY : 'a', ccY : 'c' };
  var got = _.select( container, '*Y/name' );
  test.identical( got, expected );

  var expected = { aaY : 'a', ccY : 'c', eeYx : 'e' };
  var got = _.select( container, '*Y*/name' );
  test.identical( got, expected );

}

//

function selectWithAssert( test )
{

  var container =
  {
    aaY : { name : 'a', value : 1 },
    bbN : { name : 'b', value : 2 },
    ccY : { name : 'c', value : 3 },
    ddNx : { name : 'd', value : 4 },
    eeYx : { name : 'e', value : 5 },
  }

  /* */

  test.description = 'trivial';

  var expected = { aaY : { name : 'a', value : 1 } };
  var got = _.select( container, 'a*=1' );
  test.identical( got, expected );
  test.is( got.aaY === container.aaY );

  var expected = { aaY : { name : 'a', value : 1 }, ccY : { name : 'c', value : 3 } };
  var got = _.select( container, '*=2Y' );
  test.identical( got, expected );
  test.is( got.aaY === container.aaY && got.ccY === container.ccY );

  var expected = { aaY : { name : 'a', value : 1 } };
  var got = _.select( container, 'a*=1Y' );
  test.identical( got, expected );
  test.is( got.aaY === container.aaY );

  var expected = { aaY : { name : 'a', value : 1 } };
  var got = _.select( container, '*a*=1' );
  test.identical( got, expected );
  test.is( got.aaY === container.aaY );

  /* */

  test.description = 'second level';

  var expected = { name : 'a' };
  var got = _.select( container, 'aaY/n*=1e' );
  test.identical( got, expected );

  var expected = {};
  var got = _.select( container, 'aaY/n*=0x' );
  test.identical( got, expected );

}

//

function selectWithCallback( test )
{

  test.description = 'with callback';

  var container =
  {
    aaY : { name : 'a', value : 1 },
    bbN : { name : 'b', value : 2 },
    ccY : { name : 'c', value : 3 },
    ddNx : { name : 'd', value : 4 },
    eeYx : { name : 'e', value : 5 },
  }

  function onDownBegin()
  {
    let it = this;
    if( !it.isGlob )
    return;
    delete it.result.aaY;
  }

  var expected = {};
  var got = _.select({ container : container, query : 'a*=0', onDownBegin : onDownBegin });
  test.identical( got, expected );

}

// --
// declare
// --

var Self =
{

  name : 'Tools/base/l3/Selector',
  silencing : 1,
  enabled : 1,

  context :
  {
  },

  tests :
  {
    selectTrivial : selectTrivial,
    selectMultiple : selectMultiple,
    selectMissing : selectMissing,
    selectSet : selectSet,
    selectWithDown : selectWithDown,
    selectWithGlob : selectWithGlob,
    selectWithAssert : selectWithAssert,
    selectWithCallback : selectWithCallback,
  }

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
