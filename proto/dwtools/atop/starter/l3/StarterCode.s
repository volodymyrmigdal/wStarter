( function _StarterCode_s_() {

'use strict';

let _ = _global_.wTools;

// let wasPrepareStackTrace = Error.prepareStackTrace;
// Error.prepareStackTrace = function( err, stack )
// {
// }

// --
// begin
// --

function _Begin()
{

  'use strict';

  let _global = _global_;
  if( _global._starter_ && _global._starter_._inited )
  return;

  let _starter_ = _global_._starter_;
  let _ = _starter_;
  let path = _starter_.path;
  let sourcesMap = _starter_.sourcesMap;

  //

  function SourceFile( o )
  {
    let starter = _starter_;
    let sourceFile = this;

    if( !( sourceFile instanceof SourceFile ) )
    return new SourceFile( o );

    if( o.isScript === undefined )
    o.isScript = true;

    o.filePath = starter.path.canonizeTolerant( o.filePath );
    if( !o.dirPath )
    o.dirPath = starter.path.dir( o.filePath );
    o.dirPath = starter.path.canonizeTolerant( o.dirPath );

    sourceFile.filePath = o.filePath;
    sourceFile.dirPath = o.dirPath;
    sourceFile.nakedCall = o.nakedCall;
    sourceFile.isScript = o.isScript;

    sourceFile.filename = o.filePath;
    sourceFile.exports = Object.create( null );
    sourceFile.parent = null;
    sourceFile.njsModule = o.njsModule;
    sourceFile.error = null;
    sourceFile.state = o.nakedCall ? 'preloaded' : 'created';

    sourceFile.starter = starter;
    sourceFile.include = starter._sourceInclude.bind( starter, sourceFile, sourceFile.dirPath );
    sourceFile.resolve = starter._sourceResolve.bind( starter, sourceFile, sourceFile.dirPath );
    sourceFile.include.resolve = sourceFile.resolve;
    sourceFile.include.sourceFile = sourceFile;

    /* njs compatibility */

    sourceFile.path = [ '/' ];
    getter( 'id', idGet );
    getter( 'loaded', loadedGet );

    /* interpreter-specific */

    if( _interpreter_ === 'browser' )
    starter._broSourceFile( sourceFile, o );
    else
    starter._njsSourceFile( sourceFile, o );

    /* */

    starter.sourcesMap[ o.filePath ] = sourceFile;
    Object.preventExtensions( sourceFile );
    return sourceFile;

    /* - */

    function idGet()
    {
      return this.filePath;
    }

    function loadedGet()
    {
      return this.state === 'opened';
    }

    function getter( fieldName, onGet )
    {
      Object.defineProperty( sourceFile, fieldName,
      {
        enumerable : true,
        configurable : true,
        get : onGet,
      });
    }

  }

  //

  function _sourceMake( filePath, dirPath, nakedCall )
  {
    let r = SourceFile({ filePath, dirPath, nakedCall });
    return r;
  }

  //

  function _sourceIncludeAct( parentSource, childSource, sourcePath )
  {
    let starter = this;

    try
    {

      if( !childSource )
      throw _._err({ args : [ `Found no source file ${sourcePath}` ], level : 4 });

      if( childSource.state === 'errored' || childSource.state === 'opening' || childSource.state === 'opened' )
      return childSource.exports;

      childSource.state = 'opening';
      childSource.parent = parentSource || null;

      var childSourceProxy = new Proxy( childSource, { set: function( target, property, value, receiver )
      {
        _global[ property ] = value;
        return true;
      }})

      childSource.nakedCall.call( childSourceProxy );
      childSource.state = 'opened';

      if( Config.interpreter === 'njs' )
      starter._njsModuleFromSource( childSource );

    }
    catch( err )
    {
      err = _.err( err, `\nError including source file ${ childSource ? childSource.filePath : sourcePath }` );
      if( childSource )
      {
        childSource.error = err;
        childSource.state = 'errored';
      }
      throw err;
    }

    return childSource.exports;
  }

  //

  function _sourceInclude( parentSource, basePath, filePath )
  {
    let starter = this;

    if( _.arrayIs( filePath ) )
    {
      let result = [];
      for( let f = 0 ; f < filePath.length ; f++ )
      {
        let r = starter._sourceInclude( parentSource, basePath, filePath[ f ] );
        if( r !== undefined )
        _.arrayAppendArrays( result, r );
        else
        result.push( r );
      }
      return result;
    }

    let childSource = starter._sourceForIncludeGet.apply( starter, arguments );
    if( childSource )
    return starter._sourceIncludeAct( parentSource, childSource, filePath );

    if( _interpreter_ === 'browser' )
    return starter._broInclude( parentSource, basePath, filePath );
    else
    return starter._njsInclude( parentSource, basePath, filePath );

  }

  //

  function _sourceResolve( parentSource, basePath, filePath )
  {
    let result = this._sourceOwnResolve( parentSource, basePath, filePath );
    if( result !== null )
    return result;

    if( _interpreter_ === 'browser' )
    {
      return this._broResolve( parentSource, basePath, filePath );
    }
    else
    {
      return this._njsResolve( parentSource, basePath, filePath );
    }

  }

  //

  function _sourceOwnResolve( parentSource, basePath, filePath )
  {
    let starter = this;
    let childSource = starter._sourceForIncludeGet.apply( this, arguments );
    if( !childSource )
    return null;
    return childSource.filePath;
  }

  //

  function _sourceForPathGet( filePath )
  {
    filePath = this.path.canonizeTolerant( filePath );
    let childSource = this.sourcesMap[ filePath ];
    if( childSource )
    return childSource;
    return null;
  }

  //

  function _sourceForIncludeGet( sourceFile, basePath, filePath )
  {
    let resolvedFilePath = this._pathResolve( sourceFile, basePath, filePath );
    let childSource = this.sourcesMap[ resolvedFilePath ];
    if( childSource )
    return childSource;
    return null;
  }

  //

  function _pathResolve( sourceFile, basePath, filePath )
  {
    let starter = this;

    if( sourceFile && !basePath )
    {
      basePath = sourceFile.dirPath;
    }

    if( !basePath && !sourceFile )
    {
      debugger;
      throw 'Base path is not specified, neither script file';
    }

    let isRelative = _.strBegins( filePath, './' ) || _.strBegins( filePath, '../' ) || filePath === '.' || filePath === '..';

    filePath = starter.path.canonizeTolerant( filePath );

    if( isRelative && filePath[ 0 ] !== '/' )
    {
      filePath = starter.path.canonizeTolerant( basePath + '/' + filePath );
      if( filePath[ 0 ] !== '/' )
      filePath = './' + filePath;
    }

    return filePath;
  }

  //

  function _init()
  {
    if( this._inited )
    {
      debugger;
      return;
    }
    if( Config.interpreter === 'njs' )
    this._njsInit();
    else
    this._broInit();
    this._inited = 1;
  }

}

// --
// end
// --

function _End()
{

  let Fields =
  {

    _inited : false,

  }

  let Routines =
  {

    SourceFile,

    _sourceMake,
    _sourceIncludeAct,
    _sourceInclude,
    _sourceResolve,
    _sourceOwnResolve,
    _sourceForPathGet,
    _sourceForIncludeGet,

    _pathResolve,

    _init,

  }

  Object.assign( _starter_, Routines );
  Object.assign( _starter_, Fields );

  _starter_._init();

}

// --
// export
// --

let Self =
{
  begin : _Begin,
  end : _End,
}

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
