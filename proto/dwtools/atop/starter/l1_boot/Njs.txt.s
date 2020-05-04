( function _NjsWare_s_() {

'use strict';

let _ = _global_.wTools;

// --
// begin
// --

function _Begin()
{

  'use strict';

  let _global = _global_;
  let _starter_ = _global_._starter_;
  let _ = _starter_;
  let path = _starter_.path; // xxx
  let sourcesMap = _starter_.sourcesMap; // xxx

  // if( _global._starter_ && _global._starter_._inited ) // xxx
  // return;

  let _natInclude = typeof require !== 'undefined' ? require : null;
  let _natResolve = typeof require !== 'undefined' ? require.resolve : null;

  //

  function _njsModuleFromSource( sourceFile )
  {
    if( sourceFile.njsModule )
    return sourceFile.njsModule;
    let Module = _natInclude( 'module' );
    let natPath = this.path.nativize( sourceFile.filePath );
    let njsModule = Module._cache[ natPath ];
    if( !njsModule )
    {
      njsModule = new Module( natPath, sourceFile.parent ? sourceFile.parent.njsModule : null );
      Module._cache[ natPath ] = njsModule;
    }
    njsModule.sourceFile = sourceFile;
    sourceFile.njsModule = njsModule;
    return njsModule;
  }

  //

  function _sourceWithNjsModuleGet( njsModule, filePath )
  {
    let starter = this;
    let sourceFile = njsModule.sourceFile || null;
    return starter._sourceForIncludeGet( sourceFile, _.path.dir( njsModule.filename ), filePath );
  }

  //

  function _sourceFromNjsModule( njsModule )
  {
    let starter = this;
    let r = starter._sourceForPathGet( njsModule.filename );
    if( r )
    {
      debugger;
      starter._njsSourceFileUpdateFromNjs( r, njsModule );
      return r;
    }
    r = starter.SourceFile({ filePath : njsModule.filename, njsModule });
    if( !r.parent )
    if( njsModule.parent )
    r.parent = starter._sourceFromNjsModule( njsModule.parent );
    return r;
  }

  //

  function _njsSourceFile( sourceFile, op )
  {
    let starter = this;

    sourceFile._natInclude = _natInclude;
    sourceFile._natResolve = _natResolve;

    if( sourceFile.njsModule === undefined )
    sourceFile.njsModule = null;
    if( op.njsModule )
    sourceFile.njsModule = op.njsModule;

    starter._njsSourceFileUpdateFromNjs( sourceFile, sourceFile.njsModule );

  }

  //

  function _njsSourceFileUpdateFromNjs( sourceFile, njsModule )
  {

    _.assert
    (
      !sourceFile.njsModule || sourceFile.njsModule === njsModule,
      'Something wrong!'
    );

    sourceFile.njsModule = njsModule;
    if( sourceFile.njsModule )
    {
      sourceFile.njsModule.sourceFile = sourceFile;
      sourceFile.state = njsModule.loaded ? 'opened' : 'opening';
      sourceFile.exports = njsModule.exports;
    }

  }

  //

  function _njsResolve( parentSource, basePath, filePath )
  {
    let _natResolve;

    if( parentSource )
    {
      debugger;
      _natResolve = parentSource._natResolve;
    }
    else
    {
      debugger;
      _natResolve = this._natResolve;
    }

    return _natResolve( filePath );
  }

  //

  function _njsSourceIncludeFromNjsAct( njsModule, childSource, sourcePath )
  {
    let parentSource = njsModule.sourceFile || null;
    return this._sourceIncludeCall( parentSource, childSource, sourcePath );
  }

  //

  function _njsInclude( parentSource, basePath, filePath )
  {
    let starter = this;
    let resolvedFilePath = this._pathResolveLocal( parentSource, basePath, filePath );
    resolvedFilePath = _.path.nativize( resolvedFilePath );
    let _natInclude = parentSource ? parentSource._natInclude : starter._natInclude;
    return _natInclude( resolvedFilePath );
    // return _natInclude( filePath );
  }

  //

  function _njsSetup()
  {
    let starter = this;
    let Module = _natInclude( 'module' );
    let NjsResolveFilename = Module._resolveFilename;
    Module._resolveFilename = function _resolveFilename( request, parent, isMain, options )
    {
      let result = starter._sourceOwnResolve( parent, null, request );
      if( result === null )
      return NjsResolveFilename.apply( this, arguments );
      return result;
    }
    let NjsLoad = Module._load;
    Module._load = function _load( request, parent, isMain )
    {
      if( !parent.sourceFile )
      starter._sourceFromNjsModule( parent );
      let childSource = starter._sourceWithNjsModuleGet( parent, request );
      if( childSource === null )
      {
        let result = NjsLoad.apply( this, arguments );
        let child = Module._cache[ NjsResolveFilename.apply( this, arguments ) ];
        if( child )
        starter._sourceFromNjsModule( child );
        return result;
      }
      return starter._njsSourceIncludeFromNjsAct( parent, childSource, request );
    }
  }

}

// --
// end
// --

function _End()
{

  let Fields =
  {
  }

  let Routines =
  {

    _natInclude,
    _natResolve,

    _njsModuleFromSource,
    _sourceWithNjsModuleGet,
    _sourceFromNjsModule,

    _njsSourceFile,
    _njsSourceFileUpdateFromNjs,
    _njsResolve,
    _njsSourceIncludeFromNjsAct,
    _njsInclude,
    _njsSetup,


  }

  Object.assign( _starter_, Routines );
  Object.assign( _starter_, Fields );

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
