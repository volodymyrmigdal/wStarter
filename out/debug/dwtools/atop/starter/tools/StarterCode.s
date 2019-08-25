( function _StarterWare_s_() {

'use strict';

let _ = wTools;

// debugger;
// let wasPrepareStackTrace = Error.prepareStackTrace;
// Error.prepareStackTrace = function( err, stack )
// {
//   debugger;
// }

// --
// begin
// --

function _Begin()
{

  'use strict';

  let _global = _global_;
  if( _global._starter_ && _global._starter_.SourceFile )
  return;

  let _starter_ = _global._starter_;
  let _ = _starter_;
  let sourcesMap = _starter_.sourcesMap = _starter_.sourcesMap || Object.create( null );

  let _nativeInclude = typeof require !== 'undefined' ? require : null;
  let _nativeResolve = typeof require !== 'undefined' ? require.resolve : null;

  //

  function SourceFile( o )
  {
    if( !( this instanceof SourceFile ) )
    return new SourceFile( o );

    if( o.njsModule === undefined )
    o.njsModule = null;
    if( o.njsModule )
    o.njsModule.sourceFile = this;

    if( o.isScript === undefined )
    o.isScript = true;

    o.filePath = _starter_.path.canonizeTolerant( o.filePath );
    if( !o.dirPath )
    o.dirPath = _starter_.path.dir( o.filePath );
    o.dirPath = _starter_.path.canonizeTolerant( o.dirPath );

    this.filePath = o.filePath;
    this.dirPath = o.dirPath;
    this.nakedCall = o.nakedCall;
    this.isScript = o.isScript;

    this.filename = o.filePath;
    this.exports = undefined;
    this.parent = null;
    this.njsModule = o.njsModule;
    this.error = null;
    this.state = o.nakedCall ? 'preloaded' : 'created';

    this.starter = _starter_;
    this.include = _starter_._sourceInclude.bind( _starter_, this, this.dirPath );
    this.resolve = _starter_._sourceResolve.bind( _starter_, this, this.dirPath );
    this.include.resolve = this.resolve;
    this.include.sourceFile = this;

    this._nativeInclude = _nativeInclude;
    this._nativeResolve = _nativeResolve;

    /* njs compatibility */

    this.path = [ '/' ];
    this.loaded = false;
    this.id = o.filePath;

    // console.log( 'SourceFile', this.filePath );

    _starter_.sourcesMap[ o.filePath ] = this;
    Object.preventExtensions( this );
    return this;
  }

  //

  function _njsModuleFromSource( sourceFile )
  {
    if( sourceFile.njsModule )
    return sourceFile.njsModule;
    let Module = _nativeInclude( 'module' );
    let nativePath = this.path.nativize( sourceFile.filePath );
    let njsModule = Module._cache[ nativePath ];
    if( !njsModule )
    {
      njsModule = new Module( nativePath, sourceFile.parent ? sourceFile.parent.njsModule : null );
      Module._cache[ nativePath ] = njsModule;
    }
    njsModule.sourceFile = sourceFile;
    sourceFile.njsModule = njsModule;
    return njsModule;
  }

  //

  function _pathResolve( sourceFile, basePath, filePath )
  {

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

    filePath = _starter_.path.canonizeTolerant( filePath );

    if( isRelative && filePath[ 0 ] !== '/' )
    {
      filePath = _starter_.path.canonizeTolerant( basePath + '/' + filePath );
      if( filePath[ 0 ] !== '/' )
      filePath = './' + filePath;
    }

    return filePath;
  }

  //

  function _sourceIncludeAct( parentSource, childSource, sourcePath )
  {
    try
    {

      if( !childSource )
      throw _._err({ args : [ `Found no source file ${sourcePath}` ], level : 4 });

      if( childSource.state === 'errored' || childSource.state === 'opening' || childSource.state === 'opened' )
      return childSource.exports;

      childSource.state = 'opening';
      childSource.parent = parentSource || null;
      childSource.nakedCall.call( childSource );
      childSource.loaded = true;
      childSource.state = 'opened';

      if( Config.platform === 'nodejs' )
      _starter_._njsModuleFromSource( childSource );

    }
    catch( err )
    {
      // debugger;
      // err.message += '\nError including ' + ( childSource ? childSource.filePath : 'source file' );
      err = _.err( err, `\nError including source file ${ childSource ? childSource.filePath : '' }` );
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

  function _sourceIncludeFromNjsAct( njsModule, childSource, sourcePath )
  {
    let parentSource = njsModule.sourceFile || null;
    return this._sourceIncludeAct( parentSource, childSource, sourcePath );
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

    let childSource = _starter_._sourceForIncludeGet.apply( starter, arguments );
    if( childSource )
    return _starter_._sourceIncludeAct( parentSource, childSource, filePath );

    if( _platform_ === 'browser' )
    {
      return starter._browserInclude( parentSource, basePath, filePath );
    }
    else
    {
      let _nativeInclude;
      if( parentSource )
      _nativeInclude = parentSource._nativeInclude;
      else
      _nativeInclude = _starter_._nativeInclude;
      return _nativeInclude( filePath );
    }

  }

  //

  function _sourceResolve( parentSource, basePath, filePath )
  {
    let result = this._sourceOwnResolve( parentSource, basePath, filePath );
    if( result !== null )
    return result;

    if( _platform_ === 'browser' )
    {
      return this._browserResolve( parentSource, basePath, filePath );
    }
    else
    {

      let _nativeResolve
      if( parentSource )
      {
        debugger;
        _nativeResolve = parentSource._nativeResolve;
      }
      else
      {
        debugger;
        _nativeResolve = this._nativeResolve;
      }

      return _nativeResolve( filePath );
    }

  }

  //

  function _sourceOwnResolve( parentSource, basePath, filePath )
  {
    let childSource = _starter_._sourceForIncludeGet.apply( this, arguments );
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

  function _sourceWithNjsModuleGet( njsModule, filePath )
  {
    let sourceFile = njsModule.sourceFile || null;
    return this._sourceForIncludeGet( sourceFile, this.path.dir( njsModule.filename ), filePath );
  }

  //

  function _sourceFromNjsModule( njsModule )
  {
    let r = this._sourceForPathGet( njsModule.filename );
    if( r )
    return r;
    r = SourceFile({ filePath : njsModule.filename, njsModule });
    if( !r.parent )
    if( njsModule.parent )
    r.parent = this._sourceFromNjsModule( njsModule.parent );
    return r;
  }

  //

  function _sourceMake( filePath, dirPath, nakedCall )
  {
    let r = SourceFile({ filePath, dirPath, nakedCall });
    return r;
  }

  //

  function _initNjs()
  {
    let Module = _nativeInclude( 'module' );
    let NjsResolveFilename = Module._resolveFilename;
    Module._resolveFilename = function _resolveFilename( request, parent, isMain, options )
    {
      let result = _starter_._sourceOwnResolve( parent, null, request );
      if( result === null )
      return NjsResolveFilename.apply( this, arguments );
      return result;
    }
    let NjsLoad = Module._load;
    Module._load = function _load( request, parent, isMain )
    {
      if( !parent.sourceFile )
      _starter_._sourceFromNjsModule( parent );
      let childSource = _starter_._sourceWithNjsModuleGet( parent, request );
      if( childSource === null )
      {
        let result = NjsLoad.apply( this, arguments );
        let child = Module._cache[ NjsResolveFilename.apply( this, arguments ) ];
        if( child )
        _starter_._sourceFromNjsModule( child );
        return result;
      }
      return _starter_._sourceIncludeFromNjsAct( parent, childSource, request );
    }
  }

  //

  function _init()
  {
    if( this._inited )
    {
      debugger;
      return;
    }
    if( Config.platform === 'nodejs' )
    this._initNjs();
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

    _njsModuleFromSource,
    _pathResolve,

    _nativeInclude,
    _sourceIncludeAct,
    _sourceIncludeFromNjsAct,
    _sourceInclude,
    _sourceResolve,
    _sourceOwnResolve,
    _sourceForPathGet,
    _sourceForIncludeGet,
    _sourceWithNjsModuleGet,
    _sourceFromNjsModule,
    _sourceMake,

    _initNjs,
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
