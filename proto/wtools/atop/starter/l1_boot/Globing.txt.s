( function _Globing_txt_s_()
{

'use strict';

const _ = _global_.wTools;

// --
// begin
// --

function _Begin()
{

  'use strict';

  const _global = _global_;
  let _starter_ = _global._starter_ = _global._starter_ || Object.create( null );
  let _ = _starter_;

  //

  function TokensSyntax()
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

const Self =
{
  begin : _Begin,
  end : _End,
}

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
