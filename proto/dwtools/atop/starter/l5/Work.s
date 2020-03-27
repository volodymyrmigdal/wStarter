( function _Work_s_() {

'use strict';

let _ = _global_.wTools;
let Parent = null;
let Self = function wStarterWork( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Work';

// --
// routine
// --

function finit()
{
  let work = this;
  work.unform();
  return _.Copyable.prototype.finit.call( work );
}

//

function init()
{
  let work = this;

  _.Copyable.prototype.init.call( work );

  let starter = work.starter;

  _.assert( starter instanceof _.starter.Starter );

  starter.workCounter += 1;
  work.id = starter.workCounter;

}

//

function unform()
{
  let work = this;

  _.assert( 0, 'not implemented' );

/*
qqq : implement please
*/

}

//

function form()
{
  let work = this;
  let starter = work.starter;


  return work;
}

// --
// relations
// --

let Composes =
{
}

let Associates =
{
  starter : null,
  servlet : null,
  process : null,
  error : null,
}

let Restricts =
{
  id : null,
}

let Statics =
{
}

let Accessor =
{
}

// --
// prototype
// --

let Proto =
{

  finit,
  unform,
  form,

  /* */

  Composes,
  Associates,
  Restricts,
  Statics,
  Accessor,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.Copyable.mixin( Self );

//

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

_.starter[ Self.shortName ] = Self;

})();
