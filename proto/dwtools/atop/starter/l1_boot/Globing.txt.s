( function _Globing_txt_s_() {

'use strict';

let _ = _global_.wTools;

// --
// begin
// --

function _Begin()
{

'use strict';

let _global = _global_;
let _starter_ = _global._starter_ = _global._starter_ || Object.create( null );
let _ = _starter_;

//

let TokensSyntax = function TokensSyntax()
{
  let result =
  {
    idToValue : null,
    idToName : [],
    nameToId : {},
    alternatives : {},
  }
  Object.setPrototypeOf( result, TokensSyntax );
  return result;
}

//

}

// --
// end
// --

function _End()
{

let ToolsExtension =
{
  TokensSyntax,
}

Object.assign( _starter_, ToolsExtension );

let PathExtension =
{
}

Object.assign( _starter_.path, PathExtension );

}

// --
// export
// --

let Self =
{
  begin : _Begin,
  end : _End,
}

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
