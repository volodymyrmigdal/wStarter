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

    // debugger;
    if( o.filePath === '/wtools/atop/testing/l7/TesterTop.s' )
    debugger;

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

    if( starter.interpreter === 'browser' )
    starter._broSourceFile( sourceFile, o );
    else
    starter._njsSourceFile( sourceFile, o );

    /* */

    if( starter.loggingSourceFiles )
    console.log( ` . SourceFile ${o.filePath}` );

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

  SourceFile.prototype = Object.create( null );

  //

  function _sourceMake( filePath, dirPath, nakedCall )
  {
    let r = SourceFile({ filePath, dirPath, nakedCall });
    return r;
  }

  //

  function _sourceIncludeResolvedCalling( parentSource, childSource, sourcePath )
  {
    let starter = this;

    try
    {

      if( !childSource )
      throw _._err({ args : [ `Found no source file ${sourcePath}` ], level : 4 });

      if( childSource.state === 'errored' || childSource.state === 'opening' || childSource.state === 'opened' )
      return childSource.exports;

      if( childSource.filePath === '/wtools/atop/testing/l7/TesterTop.s' )
      debugger;
      if( parentSource && parentSource.filePath === '/wtools/atop/testing/l7/TesterTop.s' )
      debugger;

      childSource.parent = parentSource || null;

      childSource.state = 'opening';
      childSource.nakedCall();
      childSource.state = 'opened';

      if( Config.interpreter === 'njs' )
      starter._njsModuleFromSource( childSource );

    }
    catch( err )
    {
      debugger;
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

    try
    {

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

      // debugger; /* ttt */
      if( !_starter_.withServer && _.path.isGlob( filePath ) ) /* xxx : workaround */
      {
        let resolvedFilePath = starter._pathResolveLocal( parentSource, basePath, filePath );
        let filtered = _.mapKeys( _.path.globShortFilterKeys( starter.sourcesMap, resolvedFilePath ) );
        if( filtered.length )
        return starter._sourceInclude( parentSource, basePath, filtered );
      }
      else
      {
        let childSource = starter._sourceForInclude.apply( starter, arguments );
        if( childSource )
        return starter._sourceIncludeResolvedCalling( parentSource, childSource, filePath );
      }

      return starter._includeAct( parentSource, basePath, filePath );
    }
    catch( err )
    {
      debugger;
      err = _.err( err, `\nError including source file ${ filePath }` );
      throw err;
    }

  }

  //

  function _sourceResolve( parentSource, basePath, filePath )
  {
    let starter = this;
    let result = starter._sourceOwnResolve( parentSource, basePath, filePath );
    if( result !== null )
    return result;

    return starter._sourceResolveAct( parentSource, basePath, filePath );
  }

  //

  function _sourceOwnResolve( parentSource, basePath, filePath )
  {
    let starter = this;
    let childSource = starter._sourceForInclude.apply( starter, arguments );
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

  function _sourceForInclude( sourceFile, basePath, filePath )
  {
    let resolvedFilePath = this._pathResolveLocal( sourceFile, basePath, filePath );
    let childSource = this.sourcesMap[ resolvedFilePath ];
    if( childSource )
    return childSource;
    return null;
  }

  //

  function _pathResolveLocal( sourceFile, basePath, filePath )
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

    let isAbsolute = filePath[ 0 ] === '/';
    let isDotted = _.strBegins( filePath, './' ) || _.strBegins( filePath, '../' ) || filePath === '.' || filePath === '..';

    if( !isDotted )
    filePath = starter.path.canonizeTolerant( filePath );

    if( isDotted && !isAbsolute )
    {
      filePath = starter.path.canonizeTolerant( basePath + '/' + filePath );
      if( filePath[ 0 ] !== '/' )
      filePath = './' + filePath;
    }

    return filePath;
  }

  //

  function _Setup()
  {

    if( this._inited )
    {
      debugger;
      return;
    }

    if( _starter_.catchingUncaughtErrors )
    {
      _starter_.error._setupUncaughtErrorHandler2();
      _starter_.error._setupUncaughtErrorHandler9();
    }

    this._SetupAct();

    this._inited = 1;
  }

}

// --
// end
// --

function _End()
{

  let Extension =
  {

    SourceFile,

    _sourceMake,
    _sourceIncludeResolvedCalling,
    _includeAct : null,
    _sourceInclude,
    _sourceResolveAct : null,
    _sourceResolve,
    _sourceOwnResolve,
    _sourceForPathGet,
    _sourceForInclude,

    _pathResolveLocal,

    _Setup,

    // fields

    redirectingConsole : null,
    _inited : false,

  }

  for( let k in Extension )
  if( _starter_[ k ] === undefined )
  _starter_[ k ] = Extension[ k ];

  _starter_._Setup();

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
