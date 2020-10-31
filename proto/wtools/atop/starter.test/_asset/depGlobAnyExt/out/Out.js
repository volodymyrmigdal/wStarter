
/* */  /* begin of library Out_js */ ( function _library_() {

/* */  /* begin of predefined */ ( function _predefined_() {

  

  'use strict';

  let _global = undefined;
  if( !_global && typeof Global !== 'undefined' && Global.Global === Global ) _global = Global;
  if( !_global && typeof global !== 'undefined' && global.global === global ) _global = global;
  if( !_global && typeof window !== 'undefined' && window.window === window ) _global = window;
  if( !_global && typeof self   !== 'undefined' && self.self === self ) _global = self;
  let _realGlobal = _global._realGlobal_ = _global;
  let _wasGlobal = _global._global_ || _global;
  _global = _wasGlobal;
  _global._global_ = _wasGlobal;

  if( !_global_.Config )
  _global_.Config = Object.create( null );
  if( _global_.Config.interpreter === undefined )
  _global_.Config.interpreter = ( ( typeof module !== 'undefined' ) && ( typeof process !== 'undefined' ) ) ? 'njs' : 'browser';
  if( _global_.Config.isWorker === undefined )
  _global_.Config.isWorker = !!( typeof self !== 'undefined' && self.self === self && typeof importScripts !== 'undefined' );

  if( _global._starter_ && _global._starter_._inited )
  return;

  let _starter_ = _global._starter_ = _global._starter_ || Object.create( null );
  let _ = _starter_;
  let Self = _starter_;

  _realGlobal_.HashMap = Map;
  _realGlobal_.HashMapWeak = WeakMap;

  // special tokens

  Self.def = Symbol.for( 'def' );
  Self.null = Symbol.for( 'null' );
  Self.undefined = Symbol.for( 'undefined' );
  Self.nothing = Symbol.for( 'nothing' );
  Self.anything = Symbol.for( 'anything' );
  Self.maybe = Symbol.for( 'maybe' );
  Self.unknown = Symbol.for( 'unknown' );
  Self.dont = Symbol.for( 'dont' );
  Self.unroll = Symbol.for( 'unroll' );
  Self.self = Symbol.for( 'self' );
  Self.optional = Symbol.for( 'optional' );

;

/* */  _global_._starter_.debug = 1;
/* */  _global_._starter_.interpreter = 'browser';
/* */  _global_._starter_.proceduring = 0;
/* */  _global_._starter_.globing = 1;
/* */  _global_._starter_.catchingUncaughtErrors = 1;
/* */  _global_._starter_.loggingApplication = 0;
/* */  _global_._starter_.loggingSourceFiles = 0;
/* */  _global_._starter_.withServer = 0;

/* */  _global_.Config.debug = 1;

  

;

/* */  /* end of predefined */ })();


/* */  /* begin of early */ ( function _early_() {

  

  'use strict';

  let _global = undefined;
  if( !_global && typeof Global !== 'undefined' && Global.Global === Global ) _global = Global;
  if( !_global && typeof global !== 'undefined' && global.global === global ) _global = global;
  if( !_global && typeof window !== 'undefined' && window.window === window ) _global = window;
  if( !_global && typeof self   !== 'undefined' && self.self === self ) _global = self;
  let _realGlobal = _global._realGlobal_ = _global;
  let _wasGlobal = _global._global_ || _global;
  _global = _wasGlobal;
  _global._global_ = _wasGlobal;

  if( !_global_.Config )
  _global_.Config = Object.create( null );
  if( _global_.Config.interpreter === undefined )
  _global_.Config.interpreter = ( ( typeof module !== 'undefined' ) && ( typeof process !== 'undefined' ) ) ? 'njs' : 'browser';
  if( _global_.Config.isWorker === undefined )
  _global_.Config.isWorker = !!( typeof self !== 'undefined' && self.self === self && typeof importScripts !== 'undefined' );

  // if( _global._starter_ && _global._starter_._inited )
  // return;

  let _starter_ = _global._starter_ = _global._starter_ || Object.create( null );
  let _ = _starter_;

  let path = _starter_.path = _starter_.path || Object.create( null );
  let uri = _starter_.uri = _starter_.uri || Object.create( null );
  _starter_.uri.path = _starter_.path;
  let introspector = _starter_.introspector = _starter_.introspector || Object.create( null );
  let setup = _starter_.setup = _starter_.setup || Object.create( null );
  let sourcesMap = _starter_.sourcesMap = _starter_.sourcesMap || Object.create( null );

  // let stackSymbol = Symbol.for( 'stack' );
  // let _diagnosticCodeExecuting = 0;
  // let _errorCounter = 0;
  // let _errorMaking = false;
  //
  // let _ArrayIndexOf = Array.prototype.indexOf;
  // let _ArrayIncludes = Array.prototype.includes;
  // if( !_ArrayIncludes )
  // _ArrayIncludes = function( e ){ _ArrayIndexOf.call( this, e ) }

  //

  function assert( good )
  {
    if( !good )
    {
      debugger;
      throw 'Something wrong!';
      return false;
    }
    return true;
  }

  //

  function assertRoutineOptions()
  {
    return arguments[ 0 ];
  }

  //

  function assertMapHasOnly()
  {
  }

  //

  function assertMapHasNoUndefine()
  {
  }

  //

  function dir( filePath )
  {
    let canonized = this.canonize( filePath );
    let splits = canonized.split( '/' );
    if( splits[ splits.length-1 ] )
    splits.pop();
    return splits.join( '/' );
  }

  //

  function nativize()
  {
    if( _global.process && _global.process.platform === 'win32' )
    this.nativize = this._nativizeWindows;
    else
    this.nativize = this._nativizePosix;
    return this.nativize.apply( this, arguments );
  }

  //

  function toStr( src )
  {
    try
    {
      return String( src );
    }
    catch( err )
    {
      debugger;
      return '{- UNKNOWN DATA TYPE -}';
    }
  }

  //

  function mapFields( src )
  {
    let result = Object.create( null );
    if( !src )
    return result;
    for( let s in src )
    result[ s ] = src[ s ];
    return result;
  }
  //
  // //
  //
  // debugger;
  // ProcedureInit = function init( o )
  // {
  //   let procedure = this; debugger;
  //
  //   // _.workpiece.initFields( procedure );
  //   // Object.preventExtensions( procedure );
  //   // procedure.copy( o );
  //   _.mapExtend( procedure, o );
  //
  //   _.assert( _.strIs( procedure._stack ) );
  //   // _.assert( procedure._sourcePath === null );
  //
  //   procedure._sourcePath = procedure._stack.split( '\n' )[ 0 ];
  //
  //   procedure._longNameMake();
  //
  //   _.arrayAppendOnceStrictly( _.Procedure.InstancesArray, procedure );
  //
  //   _.assert( _.strIs( procedure._sourcePath ) );
  //   _.assert( arguments.length === 1 );
  //   // _.assert( _.Procedure.NamesMap[ procedure._longName ] === procedure, () => `${procedure._longName} not found` );
  //
  //   return procedure;
  // };

;
  

  let StarterExtension =
  {

    assert,
    assertRoutineOptions,
    assertMapHasOnly,
    assertMapHasNoUndefine,
    toStr,
    mapFields,

    path,

  }

  Object.assign( _starter_, StarterExtension );

  let PathExtension =
  {

    dir,
    nativize,

  }

  Object.assign( _starter_.path, PathExtension );

  // let ProcedureExtension =
  // {
  //
  //   ProcedureInit
  //
  // }
  //
  // Object.assign( _starter_.Procedure.prototype, PathExtension );

;

/* */  /* end of early */ })();

  
/* */  /* begin of extract */ ( function _extract_() {

  

  'use strict';

  let _global = _global_;
  let _starter_ = _global_._starter_;
  let _ = _starter_;

  let stackSymbol = Symbol.for( 'stack' );
  let _diagnosticCodeExecuting = 0;
  // let _errorCounter = 0;
  // let _errorMaking = false;
  let _ArrayIndexOf = Array.prototype.indexOf;
  let _ArrayIncludes = Array.prototype.includes;
  if( !_ArrayIncludes )
  _ArrayIncludes = function( e ){ _ArrayIndexOf.call( this, e ) }

;

  
  _.strQuote = function strQuote( o )
  {
  
    if( !_.mapIs( o ) )
    o = { src : arguments[ 0 ], quote : arguments[ 1 ] };
    if( o.quote === undefined || o.quote === null )
    o.quote = strQuote.defaults.quote;
    _.assertMapHasOnly( o, strQuote.defaults );
    _.assert( arguments.length === 1 || arguments.length === 2 );
  
    if( _.arrayIs( o.src ) )
    {
      let result = [];
      for( let s = 0 ; s < o.src.length ; s++ )
      result.push( _.strQuote({ src : o.src[ s ], quote : o.quote }) );
      return result;
    }
  
    let src = o.src;
  
    if( !_.primitiveIs( src ) )
    src = _.toStr( src );
  
    _.assert( _.primitiveIs( src ) );
  
    let result = o.quote + String( src ) + o.quote;
  
    return result;
  }
  _.strQuote.defaults =
  { "src" : null, "quote" : `"` };
  var strQuote = _.strQuote;

//

  _.errInStr = function errInStr( errStr )
  {
    _.assert( _.strIs( errStr ) );
  
    if( !_.strHas( errStr, '= Message of' ) )
    return false;
  
    if( !_.strHas( errStr, '= Beautified calls stack' ) )
    return false;
  
    return true;
  };
  var errInStr = _.errInStr;

//

  _.errFromStr = function errFromStr( errStr )
  {
  
    // debugger;
    try
    {
  
      errStr = _.strLinesStrip( errStr );
  
      let sectionBeginRegexp = /=\s+(.*?)\s*\n/mg;
      let splits = _.strSplitFast
      ({
        src : errStr,
        delimeter : sectionBeginRegexp,
      });
  
      let sectionName;
      let throwCallsStack = '';
      let throwsStack = '';
      let stackCondensing = true;
      let messages = [];
      for( let s = 0 ; s < splits.length ; s++ )
      {
        let split = splits[ s ];
        let sectionNameParsed = sectionBeginRegexp.exec( split + '\n' );
        if( sectionNameParsed )
        {
          sectionName = sectionNameParsed[ 1 ];
          continue;
        }
  
        if( !sectionName )
        messages.push( split );
        else if( !sectionName || _.strBegins( sectionName, 'Message of' ) )
        messages.push( split );
        else if( _.strBegins( sectionName, 'Beautified calls stack' ) )
        throwCallsStack = split;
        else if( _.strBegins( sectionName, 'Throws stack' ) )
        throwsStack = split;
  
      }
  
      let dstError = new Error();
  
      let throwLocation = _.introspector.locationFromStackFrame( throwCallsStack || dstError.stack );
  
      let originalMessage = messages.join( '\n' ); /* xxx : implement routine for joining */
  
      let result = _._errMake
      ({
        dstError : dstError,
        throwLocation : throwLocation,
        stackCondensing : stackCondensing,
        originalMessage : originalMessage,
        beautifiedStack : throwCallsStack,
        throwCallsStack : throwCallsStack,
        throwsStack : throwsStack,
      });
  
      return result;
    }
    catch( err2 )
    {
      console.error( err2 );
      debugger;
      return Error( errStr );
    }
  };
  var errFromStr = _.errFromStr;

//

  _.errOriginalMessage = function errOriginalMessage( err )
  {
  
    if( arguments.length !== 1 )
    throw Error( 'errOriginalMessage : Expects single argument' );
  
    if( _.strIs( err ) )
    return err;
  
    if( !err )
    return;
  
    if( err.originalMessage )
    return err.originalMessage;
  
    let message = err.message;
  
    if( !message && message !== '' )
    message = err.msg;
    if( !message && message !== '' )
    message = err.name;
  
    if( _.mapFields )
    {
      let fields = _.mapFields( err );
      if( Object.keys( fields ).length )
      message += '\n' + _.toStr( fields, { wrap : 0, multiline : 1, levels : 2 } );
    }
  
    return message;
  };
  var errOriginalMessage = _.errOriginalMessage;

//

  _.errOriginalStack = function errOriginalStack( err )
  {
  
    if( arguments.length !== 1 )
    throw Error( 'errOriginalStack : Expects single argument' );
  
    if( !_.errIs( err ) )
    throw Error( 'errOriginalStack : Expects error' );
  
    if( err.throwCallsStack )
    return err.throwCallsStack;
  
    if( err.callsStack )
    return err.callsStack;
  
    if( err[ stackSymbol ] )
    return err[ stackSymbol ];
  
    if( err.stack )
    return _.introspector.stack( err.stack );
  
    /* should return null if nothing found */
    return null;
  };
  var errOriginalStack = _.errOriginalStack;

//

  _.err = function err()
  {
    return _._err
    ({
      args : arguments,
      level : 2,
    });
  };
  var err = _.err;

//

  _._err = function _err( o )
  {
    let dstError;
  
    if( arguments.length !== 1 )
    throw Error( '_err : Expects single argument : options map' );
  
    if( !_.mapIs( o ) )
    throw Error( '_err : Expects single argument : options map' );
  
    if( !_.longIs( o.args ) )
    throw Error( '_err : Expects Long option::args' );
  
    for( let e in o )
    {
      if( _err.defaults[ e ] === undefined )
      {
        debugger;
        throw Error( `Unknown option::${e}` );
      }
    }
  
    for( let e in _err.defaults )
    {
      if( o[ e ] === undefined )
      o[ e ] = _err.defaults[ e ];
    }
  
    if( _._errorMaking )
    {
      debugger;
      throw Error( '_err : recursive dead lock because of error inside of routine _err!' );
    }
    _._errorMaking = true;
  
    if( o.level === undefined || o.level === null )
    o.level = null;
  
    /* let */
  
    let originalMessage = '';
    let fallBackMessage = '';
    let errors = [];
    let beautifiedStack = '';
    let message = null;
  
    /* debugger */
  
    if( o.args[ 0 ] === 'not implemented' || o.args[ 0 ] === 'not tested' || o.args[ 0 ] === 'unexpected' )
    if( _.debuggerEnabled )
    debugger;
    if( _global_.debugger )
    debugger;
  
    /* algorithm */
  
    try
    {
  
      argumentsPreprocessArguments();
      argumentsPreprocessErrors();
      locationForm();
      stackAndErrorForm();
      attributesForm();
      catchesForm();
      sourceCodeForm();
      originalMessageForm();
  
      dstError = _._errMake
      ({
        dstError : dstError,
        throwLocation : o.throwLocation,
        sections : o.sections,
  
        attended : o.attended,
        logged : o.logged,
        brief : o.brief,
        isProcess : o.isProcess,
        debugging : o.debugging,
        stackCondensing : o.stackCondensing,
  
        originalMessage : originalMessage,
        beautifiedStack : beautifiedStack,
        throwCallsStack : o.throwCallsStack,
        throwsStack : o.throwsStack,
        asyncCallsStack : o.asyncCallsStack,
        sourceCode : o.sourceCode,
        reason : o.reason,
      });
  
    }
    catch( err2 )
    {
      debugger;
      _._errorMaking = false;
      console.log( err2.message );
      console.log( err2.stack );
    }
    _._errorMaking = false;
  
    return dstError;
  
    /* */
  
    function argumentsPreprocessArguments()
    {
  
      for( let a = 0 ; a < o.args.length ; a++ )
      {
        let arg = o.args[ a ];
  
        if( !_.errIs( arg ) && _.routineIs( arg ) )
        {
          if( arg.length === 0 )
          {
            try
            {
              arg = o.args[ a ] = arg();
            }
            catch( err )
            {
              debugger;
              arg = o.args[ a ] = '!ERROR PROCESSING ERROR!'
              console.log( String( err ) );
            }
          }
          if( _.unrollIs( arg ) )
          {
            o.args = _.longBut( o.args, [ a, a+1 ], arg );
            a -= 1;
            continue;
          }
        }
  
      }
  
    }
  
    /* */
  
    function argumentsPreprocessErrors()
    {
  
      for( let a = 0 ; a < o.args.length ; a++ )
      {
        let arg = o.args[ a ];
  
        if( _.errIs( arg ) )
        {
  
          errProcess( arg );
          o.args[ a ] = _.errOriginalMessage( arg )
  
        }
        else if( _.strIs( arg ) && _.errInStr( arg ) )
        {
  
          let err = _.errFromStr( arg );
          errProcess( err );
          o.args[ a ] = _.errOriginalMessage( err );
  
        }
  
      }
  
    }
  
    /* */
  
    function errProcess( arg )
    {
  
      if( !dstError )
      {
        dstError = arg;
        if( !o.sourceCode )
        o.sourceCode = arg.sourceCode || null;
        if( o.attended === null )
        o.attended = arg.attended || false;
        if( o.logged === null )
        o.logged = arg.logged || false;
      }
  
      if( arg.throwCallsStack )
      if( !o.throwCallsStack )
      o.throwCallsStack = arg.throwCallsStack;
  
      // if( arg.asyncCallsStack )
      // if( !o.asyncCallsStack )
      // o.asyncCallsStack = arg.asyncCallsStack;
  
      if( arg.throwsStack )
      if( o.throwsStack )
      o.throwsStack += '\n' + arg.throwsStack;
      else
      o.throwsStack = arg.throwsStack;
  
      if( arg.constructor )
      fallBackMessage = fallBackMessage || arg.constructor.name;
      errors.push( arg );
  
    }
  
    /* */
  
    function locationForm()
    {
  
      if( !dstError )
      for( let a = 0 ; a < o.args.length ; a++ )
      {
        let arg = o.args[ a ];
        if( !_.primitiveIs( arg ) && _.objectLike( arg ) )
        try
        {
          o.throwLocation = _.introspector.location
          ({
            error : arg,
            location : o.throwLocation,
          });
        }
        catch( err2 )
        {
          console.error( err2 );
          debugger;
        }
      }
  
      o.throwLocation = o.throwLocation || Object.create( null );
      o.catchLocation = o.catchLocation || Object.create( null );
  
    }
  
    /* */
  
    function stackAndErrorForm()
    {
  
      if( dstError )
      {
  
        /* qqq : cover each if-branch. ask how to. *difficult problem* */
  
        if( !o.throwCallsStack )
        if( o.throwLocation )
        o.throwCallsStack = _.introspector.locationToStack( o.throwLocation );
        if( !o.throwCallsStack )
        o.throwCallsStack = _.errOriginalStack( dstError );
        if( !o.throwCallsStack )
        o.throwCallsStack = _.introspector.stack([ ( o.level || 0 ) + 1, Infinity ]);
  
        if( !o.catchCallsStack && o.catchLocation )
        o.catchCallsStack = _.introspector.locationToStack( o.catchLocation );
        if( !o.catchCallsStack )
        o.catchCallsStack = _.introspector.stack( o.catchCallsStack, [ ( o.level || 0 ) + 1, Infinity ] );
  
        if( !o.throwCallsStack && o.catchCallsStack )
        o.throwCallsStack = o.catchCallsStack;
        if( !o.throwCallsStack )
        o.throwCallsStack = _.introspector.stack( dstError, [ ( o.level || 0 ) + 1, Infinity ] );
  
        o.level = 0;
  
      }
      else
      {
  
        dstError = new Error( originalMessage + '\n' );
        if( o.throwCallsStack )
        {
          dstError.stack = o.throwCallsStack;
          o.catchCallsStack = _.introspector.stack( o.catchCallsStack, [ o.level + 1, Infinity ] );
          o.level = 0;
        }
        else
        {
          if( o.catchCallsStack )
          {
            o.throwCallsStack = dstError.stack = o.catchCallsStack;
          }
          else
          {
            if( o.level === undefined || o.level === null )
            o.level = 1;
            o.level += 1;
            o.throwCallsStack = dstError.stack = _.introspector.stack( dstError.stack, [ o.level, Infinity ] );
          }
          o.level = 0;
          if( !o.catchCallsStack )
          o.catchCallsStack = o.throwCallsStack;
        }
  
      }
  
      _.assert( o.level === 0 );
  
      if( ( o.stackRemovingBeginIncluding || o.stackRemovingBeginExcluding ) && o.throwCallsStack )
      o.throwCallsStack = _.introspector.stackRemoveLeft( o.throwCallsStack, o.stackRemovingBeginIncluding || null, o.stackRemovingBeginExcluding || null );
  
      if( !o.throwCallsStack )
      o.throwCallsStack = dstError.stack = o.fallBackStack;
  
      beautifiedStack = o.throwCallsStack;
  
      _.assert( dstError.asyncCallsStack === undefined || dstError.asyncCallsStack === null || dstError.asyncCallsStack === '' || _.arrayIs( dstError.asyncCallsStack ) );
      if( dstError.asyncCallsStack && dstError.asyncCallsStack.length )
      {
        o.asyncCallsStack = o.asyncCallsStack || [];
        _.arrayAppendArray( o.asyncCallsStack, dstError.asyncCallsStack );
      }
  
      if( o.asyncCallsStack === null || o.asyncCallsStack === undefined )
      if( _.Procedure && _.Procedure.ActiveProcedure )
      o.asyncCallsStack = [ _.Procedure.ActiveProcedure.stack() ];
  
      _.assert( o.asyncCallsStack === null || _.arrayIs( o.asyncCallsStack ) );
      if( o.asyncCallsStack && o.asyncCallsStack.length )
      {
        beautifiedStack += '\n\n' + o.asyncCallsStack.join( '\n\n' );
      }
  
      _.assert( _.strIs( beautifiedStack ) );
      if( o.stackCondensing )
      beautifiedStack = _.introspector.stackCondense( beautifiedStack );
  
    }
  
    /* */
  
    function attributesForm()
    {
  
      try
      {
        o.catchLocation = _.introspector.location
        ({
          stack : o.catchCallsStack,
          location : o.catchLocation,
        });
      }
      catch( err2 )
      {
        console.error( err2 );
        debugger;
      }
  
      try
      {
        o.throwLocation = _.introspector.location
        ({
          error : dstError,
          stack : o.throwCallsStack,
          location : o.throwLocation,
        });
      }
      catch( err2 )
      {
        console.error( err2 );
        debugger;
      }
  
    }
  
    /* */
  
    function catchesForm()
    {
  
      if( o.throws )
      {
        _.assert( _.arrayIs( o.throws ) );
        o.throws.forEach( ( c ) =>
        {
          c = _.introspector.locationFromStackFrame( c ).routineFilePathLineCol;
          if( o.throwsStack )
          o.throwsStack += `\nthrown at ${c}`;
          else
          o.throwsStack = `thrown at ${c}`;
        });
      }
  
      _.assert( _.numberIs( o.catchLocation.internal ) );
      if( !o.catchLocation.internal || o.catchLocation.internal === 1 )
      {
        if( o.throwsStack )
        o.throwsStack += `\nthrown at ${o.catchLocation.routineFilePathLineCol}`;
        else
        o.throwsStack = `thrown at ${o.catchLocation.routineFilePathLineCol}`;
      }
  
    }
  
    /* */
  
    function sourceCodeForm()
    {
  
      if( !o.usingSourceCode )
      return;
  
      if( o.sourceCode )
      return;
  
      if( dstError.sourceCode === undefined )
      {
        let c = _.introspector.code
        ({
          location : o.throwLocation,
          sourceCode : o.sourceCode,
          asMap : 1,
        });
        if( c && c.code && c.code.length < 400 )
        {
          o.sourceCode = c;
        }
      }
  
    }
  
    /* */
  
    function originalMessageForm()
    {
      let multiline = false; // Dmytro : this option is not used in code
      let result = [];
  
      for( let a = 0 ; a < o.args.length ; a++ )
      {
        let arg = o.args[ a ];
        let str;
  
        if( arg && !_.primitiveIs( arg ) )
        {
  
          if( _.primitiveIs( arg ) ) // Dmytro : unnecessary condition, see above
          {
            str = String( arg );
          }
          else if( _.routineIs( arg.toStr ) )
          {
            str = arg.toStr();
          }
          else if( _.errIs( arg ) && _.strIs( arg.originalMessage ) )
          {
            str = arg.originalMessage;
          }
          else if( _.errIs( arg ) )
          {
            if( _.strIs( arg.originalMessage ) ) // Dmytro : duplicates condition above
            str = arg.originalMessage;
            else if( _.strIs( arg.message ) )
            str = arg.message;
            else
            str = _.toStr( arg );
          }
          else
          {
            str = _.toStr( arg, { levels : 2 } );
          }
        }
        else if( arg === undefined )
        {
          str = '\n' + String( arg ) + '\n';
        }
        else
        {
          str = String( arg );
        }
  
        let currentIsMultiline = _.strHas( str, '\n' );
        if( currentIsMultiline )
        multiline = true;
  
        result[ a ] = str;
  
      }
  
      for( let a = 0 ; a < result.length ; a++ )
      {
        let str = result[ a ];
  
        if( !originalMessage.replace( /\s*/m, '' ) )
        {
          originalMessage = str;
        }
        else if( _.strEnds( originalMessage, '\n' ) || _.strBegins( str, '\n' ) )
        {
          originalMessage = originalMessage.replace( /\s+$/m, '' ) + '\n' + str;
        }
        else
        {
          originalMessage = originalMessage.replace( /\s+$/m, '' ) + ' ' + str.replace( /^\s+/m, '' );
        }
  
      }
  
      /*
        remove redundant eol from begin and end of message
      */
  
      originalMessage = originalMessage || fallBackMessage || 'UnknownError';
      originalMessage = originalMessage.replace( /^\x20*\n/m, '' );
      originalMessage = originalMessage.replace( /\x20*\n$/m, '' );
  
    }
  
  }
  _._err.defaults =
  {
    "args" : null, 
    "sections" : null, 
    "level" : 1, 
    "reason" : null, 
    "sourceCode" : null, 
    "stackRemovingBeginIncluding" : 0, 
    "stackRemovingBeginExcluding" : 0, 
    "usingSourceCode" : 1, 
    "stackCondensing" : 1, 
    "attended" : null, 
    "logged" : null, 
    "brief" : null, 
    "isProcess" : null, 
    "debugging" : null, 
    "throwLocation" : null, 
    "catchLocation" : null, 
    "asyncCallsStack" : null, 
    "throwCallsStack" : null, 
    "catchCallsStack" : null, 
    "fallBackStack" : null, 
    "throwsStack" : ``, 
    "throws" : null
  };
  var _err = _._err;

//

  _._errMake = function _errMake( o )
  {
  
    if( arguments.length !== 1 )
    throw Error( 'Expects single argument : options map' );
  
    if( !_.mapIs( o ) )
    throw Error( 'Expects single argument : options map' );
  
    for( let e in o )
    {
      if( _errMake.defaults[ e ] === undefined )
      {
        debugger;
        throw Error( `Unknown option::${e}` );
      }
    }
  
    for( let e in _errMake.defaults )
    {
      if( o[ e ] === undefined )
      o[ e ] = _errMake.defaults[ e ];
    }
  
    if( !_.errIs( o.dstError ) )
    throw Error( 'Expects option.dstError:Error' );
  
    if( !_.strIs( o.originalMessage ) )
    throw Error( 'Expects option.originalMessage:String' );
  
    if( !_.strIs( o.beautifiedStack ) )
    throw Error( 'Expects option.beautifiedStack:String' );
  
    if( !_.strIs( o.throwCallsStack ) )
    throw Error( 'Expects option.throwCallsStack:String' );
  
    if( !_.strIs( o.throwsStack ) )
    throw Error( 'Expects option.throwsStack:String' );
  
    if( !o.throwLocation )
    throw Error( 'Expects option.throwLocation:Location' );
  
    attributesForm();
    sectionsForm();
    messageForm();
    fieldsForm();
  
    return o.dstError;
  
    /* */
  
    function attributesForm()
    {
  
      if( o.attended === null || o.attended === undefined )
      o.attended = o.dstError.attended;
      o.attended = !!o.attended;
  
      if( o.logged === null || o.logged === undefined )
      o.logged = o.dstError.logged;
      o.logged = !!o.logged;
  
      if( o.brief === null || o.brief === undefined )
      o.brief = o.dstError.brief;
      o.brief = !!o.brief;
  
      if( o.isProcess === null || o.isProcess === undefined )
      o.isProcess = o.dstError.isProcess;
      o.isProcess = !!o.isProcess;
  
      if( o.debugging === null || o.debugging === undefined )
      o.debugging = o.dstError.debugging;
      o.debugging = !!o.debugging;
  
      if( o.reason === null || o.reason === undefined )
      o.reason = o.dstError.reason;
  
      let sections = o.dstError.section || Object.create( null );
      if( o.sections )
      _.mapExtend( sections, o.sections );
      o.sections = sections;
  
      o.id = o.dstError.id;
      if( !o.id )
      {
        _._errorCounter += 1;
        o.id = _._errorCounter;
      }
  
    }
  
    /* */
  
    function sectionsForm()
    {
      let result = '';
  
      sectionWrite( 'message', `Message of error#${o.id}`, o.originalMessage );
      sectionWrite( 'callsStack', o.stackCondensing ? 'Beautified calls stack' : 'Calls stack', o.beautifiedStack );
      sectionWrite( 'throwsStack', `Throws stack`, o.throwsStack );
  
      if( o.isProcess && _.process && _.process.entryPointInfo )
      sectionWrite( 'process', `Process`, _.process.entryPointInfo() );
  
      if( o.sourceCode )
      sectionWrite( 'sourceCode', `Source code from ${o.sourceCode.path}`, o.sourceCode.code );
  
      for( let s in o.sections )
      {
        let section = o.sections[ s ];
        if( !_.strIs( section.head ) )
        {
          debugger;
          logger.error( `Each section of an error should have head, but head of section::${s} is ${_.strType(section.head)}` );
          delete o.sections[ s ];
        }
        if( !_.strIs( section.body ) )
        {
          debugger;
          logger.error( `Each section of an error should have body, but body of section::${s} is ${_.strType(section.body)}` );
          delete o.sections[ s ];
        }
      }
  
      return result;
    }
  
    /* */
  
    function sectionWrite( name, head, body )
    {
      let section = { head, body };
      o.sections[ name ] = section;
      return section;
    }
  
    /* */
  
    function strLinesIndentation( str, indentation )
    {
      if( _.strLinesIndentation )
      return indentation + _.strLinesIndentation( str, indentation );
      else
      return str;
    }
  
    /* */
  
    function messageForm()
    {
      let result = '';
  
      if( o.brief )
      {
        result += o.originalMessage;
      }
      else
      {
  
        for( let s in o.sections )
        {
          let section = o.sections[ s ];
          let head = section.head || '';
          let body = strLinesIndentation( section.body, '    ' );
          if( !body.trim().length )
          continue;
          result += ` = ${head}\n${body}\n\n`;
        }
  
      }
  
      o.message = result;
      return result;
    }
  
    /* */
  
    function fieldsForm()
    {
  
      nonenumerable( 'message', o.message );
      nonenumerable( 'originalMessage', o.originalMessage );
      logging( 'stack', o.message );
      nonenumerable( 'reason', o.reason );
  
      nonenumerable( 'callsStack', o.beautifiedStack );
      nonenumerable( 'throwCallsStack', o.throwCallsStack );
      nonenumerable( 'asyncCallsStack', o.asyncCallsStack );
      nonenumerable( 'throwsStack', o.throwsStack );
      nonenumerable( 'catchCounter', o.dstError.catchCounter ? o.dstError.catchCounter+1 : 1 );
  
      nonenumerable( 'attended', o.attended );
      nonenumerable( 'logged', o.logged );
      nonenumerable( 'brief', o.brief );
      nonenumerable( 'isProcess', o.isProcess );
  
      if( o.throwLocation.line !== undefined )
      nonenumerable( 'lineNumber', o.throwLocation.line );
      if( o.dstError.throwLocation === undefined )
      nonenumerable( 'location', o.throwLocation );
      nonenumerable( 'sourceCode', o.sourceCode || null );
      nonenumerable( 'debugging', o.debugging );
      nonenumerable( 'id', o.id );
  
      nonenumerable( 'toString', function() { return this.stack } );
      nonenumerable( 'sections', o.sections );
  
      if( o.debugging )
      debugger;
  
    }
  
    /* */
  
    function nonenumerable( fieldName, value )
    {
      try
      {
        Object.defineProperty( o.dstError, fieldName,
        {
          enumerable : false,
          configurable : true,
          writable : true,
          value : value,
        });
      }
      catch( err2 )
      {
        console.error( err2 );
        debugger;
      }
    }
  
    /* */
  
    function rw( fieldName, value ) // Dmytro : this routine is not used anywhere, similar routine logging() below
    {
      let symbol = Symbol.for( fieldName );
      try
      {
        o.dstError[ symbol ] = value;
        Object.defineProperty( o.dstError, fieldName,
        {
          enumerable : false,
          configurable : true,
          get : get,
          set : set,
        });
      }
      catch( err2 )
      {
        console.error( err2 );
        debugger;
      }
      function get()
      {
        logger.log( `${fieldName} get ${this[ symbol ]}` );
        return this[ symbol ];
      }
      function set( src )
      {
        logger.log( `${fieldName} set` );
        this[ symbol ] = src;
        return src;
      }
    }
  
    /* */
  
    function logging( fieldName, value )
    {
      let symbol = Symbol.for( fieldName );
      try
      {
        nonenumerable( symbol, value );
        Object.defineProperty( o.dstError, fieldName,
        {
          enumerable : false,
          configurable : true,
          get : get,
          set : set,
        });
      }
      catch( err2 )
      {
        console.error( err2 );
        debugger;
      }
      function get()
      {
        _.errLogged( this );
        _.errAttend( this );
        return this[ symbol ];
      }
      function set( src )
      {
        debugger;
        this[ symbol ] = src;
        return src;
      }
    }
  
  }
  _._errMake.defaults =
  {
    "dstError" : null, 
    "id" : null, 
    "throwLocation" : null, 
    "sections" : null, 
    "attended" : null, 
    "logged" : null, 
    "brief" : null, 
    "isProcess" : null, 
    "debugging" : null, 
    "stackCondensing" : null, 
    "originalMessage" : null, 
    "beautifiedStack" : ``, 
    "throwCallsStack" : ``, 
    "throwsStack" : ``, 
    "asyncCallsStack" : ``, 
    "sourceCode" : null, 
    "reason" : null
  };
  var _errMake = _._errMake;

//

  _.errLogged = function errLogged( err, value )
  {
    _.assert( arguments.length === 1 || arguments.length === 2 );
    if( value === undefined )
    value = Config.debug ? _.introspector.stack([ 0, Infinity ]) : true;
    return _._errFields( err, { logged : value } );
  };
  var errLogged = _.errLogged;

//

  _.errAttend = function errAttend( err, value )
  {
    _.assert( arguments.length === 1 || arguments.length === 2 );
    if( value === undefined )
    value = Config.debug ? _.introspector.stack([ 0, Infinity ]) : true;
    let result = _._errFields( err, { attended : value } );
    return result;
  };
  var errAttend = _.errAttend;

//

  _._errFields = function _errFields( args, fields )
  {
  
    _.assert( arguments.length === 2 );
    _.assert( _.mapIs( fields ) )
  
    if( !_.longIs( args ) )
    args = [ args ];
  
    let err = args[ 0 ];
    if( args.length !== 1 || !_.errIsStandard( err ) )
    err = _._err
    ({
      args : args,
      level : 2,
    });
  
    /* */
  
    try
    {
  
      for( let f in fields )
      {
        Object.defineProperty( err, f,
        {
          enumerable : false,
          configurable : true,
          writable : true,
          value : fields[ f ],
        });
      }
  
    }
    catch( err )
    {
      logger.warn( `Cant assign "${f}" property to error\n` + err.toString() );
    }
  
    /* */
  
    return err;
  };
  var _errFields = _._errFields;

//

  _.errIsStandard = function errIsStandard( src )
  {
    if( !_.errIs( src ) )
    return false;
    return src.originalMessage !== undefined;
  };
  var errIsStandard = _.errIsStandard;

//

  _.errIsAttended = function errIsAttended( src )
  {
    if( !_.errIs( src ) )
    return false;
    return !!src.attended;
  };
  var errIsAttended = _.errIsAttended;

//

  _.errProcess = function errProcess()
  {
    return _._err
    ({
      args : arguments,
      level : 2,
      isProcess : 1,
    });
  };
  var errProcess = _.errProcess;

//

  _.assert = function assert( condition )
  {
  
    if( Config.debug === false )
    return true;
  
    if( !condition )
    {
      _assertDebugger( condition, arguments );
      if( arguments.length === 1 )
      throw _err
      ({
        args : [ 'Assertion fails' ],
        level : 2,
      });
      else if( arguments.length === 2 )
      throw _err
      ({
        args : [ arguments[ 1 ] ],
        level : 2,
      });
      else
      throw _err
      ({
        args : Array.prototype.slice.call( arguments, 1 ),
        level : 2,
      });
    }
  
    return true;
  
    function boolLike( src )
    {
      let type = Object.prototype.toString.call( src );
      return type === '[object Boolean]' || type === '[object Number]';
    }
  
    function _assertDebugger( condition, args )
    {
      if( !_.debuggerEnabled )
      return;
      let err = _._err
      ({
        args : Array.prototype.slice.call( args, 1 ),
        level : 3,
      });
      debugger;
    }
  
  };
  var assert = _.assert;

//

  _._errorCounter = 0;

//

  _._errorMaking = false;

//


  _.introspector.code = function code( o )
  {
  
    _.routineOptions( code, o );
    _.assert( arguments.length === 0 || arguments.length === 1 );
  
    if( _diagnosticCodeExecuting )
    return;
    _diagnosticCodeExecuting += 1;
  
    try
    {
  
      if( !o.location )
      {
        if( o.error )
        o.location = _.introspector.location({ error : o.error, level : o.level });
        else
        o.location = _.introspector.location({ stack : o.stack, level : o.stack ? o.level : o.level+1 });
      }
  
      if( !_.numberIs( o.location.line ) )
      return end();
  
      /* */
  
      if( !o.sourceCode )
      {
  
        if( !o.location.filePath )
        return end();
  
        let codeProvider = _.codeProvider || _.fileProvider;
        if( !codeProvider && _global_._testerGlobal_ && _global_._testerGlobal_.wTools )
        codeProvider = _global_._testerGlobal_.wTools.codeProvider || _global_._testerGlobal_.wTools.fileProvider;
  
        if( !codeProvider )
        return end();
  
        try
        {
  
          let filePath = codeProvider.path.normalizeTolerant( o.location.filePath );
          if( codeProvider.path.isAbsolute( filePath ) )
          o.sourceCode = read( codeProvider, filePath );
  
        }
        catch( err )
        {
          o.sourceCode = ` ! Cant load source code of "${ o.location.filePath }"`;
        }
  
        if( !o.sourceCode )
        return end();
  
      }
  
      /* */
  
      let code = _.strLinesSelect
      ({
        src : o.sourceCode,
        line : o.location.line,
        numberOfLines : o.numberOfLines,
        selectMode : o.selectMode,
        zeroLine : 1,
        numbering : 1,
      });
  
      if( code && _.strLinesIndentation && o.identation )
      code = o.identation + _.strLinesIndentation( code, o.identation );
  
      let result = code;
      if( o.withPath )
      {
        if( o.asMap )
        result = { path : o.location.filePathLineCol, code : code };
        else
        result = o.location.filePathLineCol + '\n' + code;
      }
  
      return end( result );
    }
    catch( err )
    {
      console.log( err.toString() );
      return;
    }
  
    /* */
  
    function end( result )
    {
      _diagnosticCodeExecuting -= 1;
      return result;
    }
  
    /* */
  
    function read( codeProvider, filePath )
    {
      // if( _codeCache.map[ filePath ] )
      // return _codeCache.map[ filePath ];
      let result = codeProvider.fileRead
      ({
        filePath : filePath,
        sync : 1,
        throwing : 0,
      });
      // _codeCache.map[ filePath ] = result;
      // _.arrayRemoveOnce( _codeCache.array, filePath );
      // _codeCache.array.push( filePath );
      // if( _codeCache.array.length > _codeCache.limit )
      // {
      //   delete _codeCache.map[ _codeCache.array[ 0 ] ];
      //   _codeCache.array.splice( 0, 1 );
      // }
      return result;
    }
  
    /* */
  
  }
  _.introspector.code.defaults =
  {
    "level" : 0, 
    "numberOfLines" : 5, 
    "withPath" : 1, 
    "asMap" : 0, 
    "selectMode" : `center`, 
    "identation" : null, 
    "stack" : null, 
    "error" : null, 
    "location" : null, 
    "sourceCode" : null
  };
  var code = _.introspector.code;

//

  _.introspector.stack = function stack( stack, range )
  {
  
    if( arguments.length === 1 )
    {
      if( !_.errIs( stack ) )
      if( !_.strIs( stack ) )
      {
        range = arguments[ 0 ];
        stack = undefined;
      }
    }
  
    if( stack === undefined || stack === null )
    {
      stack = new Error();
      if( range === undefined )
      {
        range = [ 1, Infinity ];
      }
      else
      {
        if( _.numberIs( range[ 0 ] ) ) /* Dmytro : previous implementation affects range - not a number value + number => NaN, so assertion does not word properly */
        range[ 0 ] += 1;
        if( _.numberIs( range[ 1 ] ) && range[ 1 ] >= 0 )
        range[ 1 ] += 1;
      }
    }
  
    if( range === undefined )
    range = [ 0, Infinity ];
  
    if( arguments.length !== 0 && arguments.length !== 1 && arguments.length !== 2 )
    {
      debugger;
      throw Error( 'stack : expects one or two or none arguments' );
    }
  
    if( !_.rangeIs( range ) )
    {
      debugger;
      throw Error( 'stack : expects range but, got ' + _.strType( range ) );
    }
  
    let first = range[ 0 ];
    let last = range[ 1 ];
  
    // if( !_.numberIs( first ) ) // Dmytro : it's unnecessary assertions, _.rangeIs checks number value in passed array
    // {
    //   debugger;
    //   throw Error( 'stack : expects number range[ 0 ], but got ' + _.strType( first ) );
    // }
    //
    // if( !_.numberIs( last ) )
    // {
    //   debugger;
    //   throw Error( 'stack : expects number range[ 0 ], but got ' + _.strType( last ) );
    // }
  
    let errIs = 0;
    if( _.errIs( stack ) )
    {
      stack = _.errOriginalStack( stack );
      errIs = 1;
    }
  
    if( !stack )
    return '';
  
    if( !_.arrayIs( stack ) && !_.strIs( stack ) )
    return;
  
    // if( !_.arrayIs( stack ) && !_.strIs( stack ) ) // Dmytro : previous condition is almost identical
    // {
    //   debugger;
    //   throw Error( 'stack expects array or string' );
    // }
  
    if( !_.arrayIs( stack ) )
    stack = stack.split( '\n' );
  
    /* remove redundant lines */
  
    while( stack.length )
    {
      let splice = 0;
      splice |= ( _.strHas( stack[ 0 ], /(^| )at / ) === false && stack[ 0 ].indexOf( '@' ) === -1 );
      splice |= stack[ 0 ].indexOf( '(vm.js:' ) !== -1;
      splice |= stack[ 0 ].indexOf( '(module.js:' ) !== -1;
      splice |= stack[ 0 ].indexOf( '(internal/module.js:' ) !== -1;
      if( splice )
      stack.splice( 0, 1 );
      else break;
    }
  
    if( stack[ 0 ] )
    if( stack[ 0 ].indexOf( 'at ' ) === -1 && stack[ 0 ].indexOf( '@' ) === -1 ) // Dmytro : it's dubious - while loop removes all strings if stack[ 0 ] has not 'at ' or '@'
    {
      console.error( 'stack : failed to parse stack' );
      debugger;
    }
  
    stack = stack.map( ( line ) => line.trim() );
    stack = stack.filter( ( line ) => line );
  
    /* */
  
    first = first === undefined ? 0 : first;
    last = last === undefined ? stack.length : last;
  
    // if( _.numberIs( first ) ) // Dmytro : first and last - is always some numbers, see above about assertions
    if( first < 0 )
    first = stack.length + first;
  
    // if( _.numberIs( last ) )
    if( last < 0 )
    last = stack.length + last + 1;
  
    /* */
  
    if( first !== 0 || last !== stack.length )
    {
      stack = stack.slice( first || 0, last );
    }
  
    /* */
  
    stack = String( stack.join( '\n' ) );
  
    return stack;
  };
  var stack = _.introspector.stack;

//

  _.introspector.stackCondense = function stackCondense( stack )
  {
  
    if( arguments.length !== 1 )
    throw Error( 'Expects single arguments' );
  
    if( !_.strIs( stack ) )
    {
      debugger;
      throw Error( 'Expects string' );
    }
  
    stack = stack.split( '\n' );
  
    for( let s = stack.length-1 ; s >= 0 ; s-- )
    {
      let line = stack[ s ];
      if( s > 0 )
      if( /(\W|^)__\w+/.test( line ) )
      {
        stack.splice( s, 1 );
        continue;
      }
      if( _.strHas( line, '.test.' ) )
      line += ' *';
      stack[ s ] = line;
    }
  
    return stack.join( '\n' );
  };
  var stackCondense = _.introspector.stackCondense;

//

  _.introspector.location = function location( o )
  {
  
    if( _.numberIs( o ) )
    o = { level : o }
    else if( _.strIs( o ) )
    o = { stack : o, level : 0 }
    else if( _.errIs( o ) )
    o = { error : o, level : 0 }
    else if( o === undefined )
    o = { stack : _.introspector.stack([ 1, Infinity ]) };
  
    /* */
  
    if( location.defaults )
    for( let e in o )
    {
      if( location.defaults[ e ] === undefined )
      throw Error( 'Unknown option ' + e );
    }
  
    if( location.defaults )
    for( let e in location.defaults )
    {
      if( o[ e ] === undefined )
      o[ e ] = location.defaults[ e ];
    }
  
    if( !( arguments.length === 0 || arguments.length === 1 ) )
    throw Error( 'Expects single argument or none' );
  
    if( !_.mapIs( o ) )
    throw Error( 'Expects options map' );
  
    if( !o.level )
    o.level = 0;
  
    /* */
  
    if( !o.location )
    o.location = Object.create( null );
  
    /* */
  
    if( o.error )
    {
      let location2 = o.error.location || Object.create( null );
  
      o.location.filePath = _.longLeftDefined([ location2.filePath, o.location.filePath, o.error.filename, o.error.fileName ]).element;
      o.location.line = _.longLeftDefined([ location2.line, o.location.line, o.error.line, o.error.linenumber, o.error.lineNumber, o.error.lineNo, o.error.lineno ]).element;
      o.location.col = _.longLeftDefined([ location2.col, o.location.col, o.error.col, o.error.colnumber, o.error.colNumber, o.error.colNo, o.error.colno ]).element;
  
    }
  
    /* */
  
    if( !o.stack )
    {
      if( o.error )
      {
        o.stack = _.introspector.stack( o.error, undefined );
      }
      else
      {
        o.stack = _.introspector.stack();
        o.level += 1;
      }
    }
  
    if( o.stack === null || o.stack === undefined )
    return o.location;
  
    _.assert( _.strIs( o.stack ) || _.arrayIs( o.stack ) );
  
    let stack = o.stack;
    if( _.strIs( stack ) )
    stack = stack.split( '\n' );
    let stackFrame = stack[ o.level ];
  
    return _.introspector.locationFromStackFrame({ stackFrame : stackFrame, location : o.location });
  }
  _.introspector.location.defaults =
  {
    "level" : 0, 
    "stack" : null, 
    "error" : null, 
    "location" : null
  };
  var location = _.introspector.location;

//

  _.introspector.locationFromStackFrame = function locationFromStackFrame( o )
  {
  
    if( _.strIs( o ) )
    o = { stackFrame : o }
  
    /* */
  
    if( locationFromStackFrame.defaults )
    for( let e in o )
    {
      if( locationFromStackFrame.defaults[ e ] === undefined )
      throw Error( 'Unknown option ' + e );
    }
  
    if( locationFromStackFrame.defaults )
    for( let e in locationFromStackFrame.defaults )
    {
      if( o[ e ] === undefined )
      o[ e ] = locationFromStackFrame.defaults[ e ];
    }
  
    if( !( arguments.length === 1 ) )
    throw Error( 'Expects single argument' );
  
    if( !_.mapIs( o ) )
    throw Error( 'Expects options map' );
  
    if( !( _.strIs( o.stackFrame ) ) )
    throw Error( `Expects string {- stackFrame -}, but fot ${_.strType( o.stackFrame )}` );
  
    if( o.location && !_.mapIs( o.location ) )
    {
      debugger;
      throw Error( 'Expects map option::location' );
    }
  
    /* */
  
    if( !o.location )
    o.location = Object.create( null );
  
    // if( !o.location.original )
    o.location.original = o.stackFrame;
  
    _.introspector.locationNormalize( o.location );
  
    return o.location;
  
    // let hadPath = !!o.location.filePath;
    // if( !o.location.filePath )
    // o.location.filePath = pathFromStack();
    //
    // pathCanonize();
    // routineFromStack();
    // routineAliasFromStack();
    // internalForm();
    //
    // if( !_.strIs( o.location.filePath ) )
    // return end();
    //
    // if( !_.numberIs( o.location.line ) )
    // o.location.filePath = lineColFromPath( o.location.filePath );
    //
    // if( !_.numberIs( o.location.line ) && hadPath )
    // {
    //   let path = pathFromStack();
    //   if( path )
    //   lineColFromPath( path );
    // }
    //
    // return end();
    //
    // /* */
    //
    // function end()
    // {
    //   let path = o.location.filePath;
    //
    //   /* filePathLineCol */
    //
    //   o.location.filePathLineCol = path || '';
    //   if( _.numberIs( o.location.line ) )
    //   {
    //     o.location.filePathLineCol += ':' + o.location.line;
    //     if( _.numberIs( o.location.col ) )
    //     o.location.filePathLineCol += ':' + o.location.col;
    //   }
    //
    //   /* routineFilePathLineCol */
    //
    //   if( o.location.routineName )
    //   o.location.routineFilePathLineCol = o.location.routineName + ' @ ' + o.location.filePathLineCol;
    //
    //   /* fileName */
    //
    //   if( path )
    //   {
    //     let fileName = path;
    //     _.assert( fileName.lastIndexOf );
    //     let i1 = fileName.lastIndexOf( '/' );
    //     let i2 = fileName.lastIndexOf( '\\' );
    //     let i = Math.max( i1, i2 );
    //     if( i !== -1 )
    //     fileName = fileName.substr( i+1 );
    //     o.location.fileName = fileName;
    //   }
    //
    //   /* fileNameLineCol */
    //
    //   o.location.fileNameLineCol = o.location.fileName || '';
    //   if( _.numberIs( o.location.line ) )
    //   {
    //     o.location.fileNameLineCol += ':' + o.location.line;
    //     if( _.numberIs( o.location.col ) )
    //     o.location.fileNameLineCol += ':' + o.location.col;
    //   }
    //
    //   return o.location;
    // }
    //
    // /* */
    //
    // function pathCanonize()
    // {
    //   if( !o.location.filePath )
    //   return;
    //
    //   if( _.path && _.path.canonize )
    //   o.location.filePath = _.path.canonize( o.location.filePath );
    // }
    //
    // /* */
    //
    // function routineFromStack()
    // {
    //   let routineName;
    //
    //   if( o.location.routineName )
    //   return o.location.routineName;
    //
    //   routineName = o.stackFrame;
    //
    //   if( !_.strIs( routineName ) ) // Dmytro : it is duplicated condition. The first is if( !_.strIs( o.stackFrame ) ) throw ...
    //   return '{-anonymous-}';
    //
    //   routineName = routineName.replace( /at eval \(eval at/, '' );
    //   let t = /^\s*(?:at\s+)?([\w\.<>]+)\s*.+/;
    //   let executed = t.exec( routineName );
    //   if( executed )
    //   routineName = executed[ 1 ] || '';
    //
    //   routineName = routineName.replace( /<anonymous>/gm, '{-anonymous-}' );
    //
    //   if( _.strEnds( routineName, '.' ) )
    //   routineName += '{-anonymous-}';
    //
    //   o.location.routineName = routineName;
    //   return o.location.routineName;
    // }
    //
    // /* */
    //
    // function routineAliasFromStack()
    // {
    //   let routineAlias;
    //
    //   if( o.location.routineAlias )
    //   return o.location.routineAlias;
    //
    //   routineAlias = null;
    //
    //   let t = /\[as ([^\]]*)\]/;
    //   let executed = t.exec( o.stackFrame );
    //   if( executed )
    //   routineAlias = executed[ 1 ] || null;
    //
    //   if( routineAlias )
    //   routineAlias = routineAlias.replace( /<anonymous>/gm, '{-anonymous-}' );
    //
    //   o.location.routineAlias = routineAlias;
    //   return o.location.routineAlias;
    // }
    //
    // /* */
    //
    // function internalForm()
    // {
    //
    //   if( _.numberIs( o.location.internal ) )
    //   return;
    //   // Dmytro : maybe, it need assertion o.location.internal <= 2
    //
    //   o.location.internal = 0;
    //
    //   if( o.location.routineName )
    //   {
    //     if( o.location.internal < 2 )
    //     if( _.strBegins( o.location.routineName, '__' ) || o.location.routineName.indexOf( '.__' ) !== -1 )
    //     o.location.internal = 2;
    //     if( o.location.internal < 1 )
    //     if( _.strBegins( o.location.routineName, '_' ) || o.location.routineName.indexOf( '._' ) !== -1 )
    //     o.location.internal = 1;
    //   }
    //
    //   if( o.location.routineAlias )
    //   {
    //     if( o.location.internal < 2 )
    //     if( _.strBegins( o.location.routineAlias, '__' ) || o.location.routineAlias.indexOf( '.__' ) !== -1 )
    //     o.location.internal = 2;
    //     if( o.location.internal < 1 )
    //     if( _.strBegins( o.location.routineAlias, '_' ) || o.location.routineAlias.indexOf( '._' ) !== -1 )
    //     o.location.internal = 1;
    //   }
    //
    //   if( o.location.filePath )
    //   {
    //     if( o.location.internal < 2 )
    //     if( _.strBegins( o.location.filePath, 'internal/' ) )
    //     o.location.internal = 2;
    //   }
    //
    //   // if( o.location.routineAlias )
    //   // splice |= stack[ 0 ].indexOf( '(vm.js:' ) !== -1;
    //   // splice |= stack[ 0 ].indexOf( '(module.js:' ) !== -1;
    //
    // }
    //
    // /* */
    //
    // function pathFromStack()
    // {
    //   let path = o.stackFrame;
    //
    //   if( !_.strIs( path ) )
    //   return;
    //
    //   path = path.replace( /^\s+/, '' );
    //   path = path.replace( /^\w+@/, '' );
    //   path = path.replace( /^at/, '' );
    //   path = path.replace( /^\s+/, '' );
    //   path = path.replace( /\s+$/, '' );
    //
    //   let regexp = /^.*\(([^\)]*)\).*$/;
    //   var parsed = regexp.exec( path );
    //   if( parsed )
    //   path = parsed[ 1 ];
    //
    //   return path;
    // }
    //
    // /* line / col number from path */
    //
    // function lineColFromPath( path )
    // {
    //
    //   let lineNumber, colNumber;
    //   let postfix = /(.+?):(\d+)(?::(\d+))?[^:/]*$/;
    //   let parsed = postfix.exec( path );
    //
    //   if( parsed )
    //   {
    //     path = parsed[ 1 ];
    //     lineNumber = parsed[ 2 ];
    //     colNumber = parsed[ 3 ];
    //   }
    //
    //   lineNumber = parseInt( lineNumber );
    //   colNumber = parseInt( colNumber );
    //
    //   if( isNaN( o.location.line ) && !isNaN( lineNumber ) )
    //   o.location.line = lineNumber;
    //
    //   if( isNaN( o.location.col ) && !isNaN( colNumber ) )
    //   o.location.col = colNumber;
    //
    //   return path;
    // }
  
  }
  _.introspector.locationFromStackFrame.defaults =
  { "stackFrame" : null, "location" : null };
  var locationFromStackFrame = _.introspector.locationFromStackFrame;

//

  _.introspector.locationToStack = function locationToStack( o )
  {
  
    /* */
  
    if( locationNormalize.defaults )
    for( let e in o )
    {
      if( locationNormalize.defaults[ e ] === undefined )
      throw Error( `Location does not have field ${e}` );
    }
  
    if( !( arguments.length === 1 ) )
    throw Error( 'Expects single argument' );
  
    if( !_.mapIs( o ) )
    throw Error( 'Expects options map' );
  
    /* */
  
    _.assertMapHasOnly( o, locationToStack.defaults );
    _.introspector.locationNormalize( o );
  
    if( !o.filePathLineCol )
    return null;
  
    if( o.routineFilePathLineCol )
    {
      _.assert( 0, 'not tested' );
    }
  
    if( o.routineName )
    return `at ${o.routineName} (${o.filePathLineCol})`;
    else
    return `at (${o.filePathLineCol})`;
  
    /*
      at Object.locationToStack (http://127.0.0.1:5000//builder/include/wtools/abase/l0/l3/iIntrospector.s:723:10)
    */
  }
  _.introspector.locationToStack.defaults =
  {
    "original" : null, 
    "filePath" : null, 
    "routineName" : null, 
    "routineAlias" : null, 
    "internal" : null, 
    "line" : null, 
    "col" : null, 
    "filePathLineCol" : null, 
    "routineFilePathLineCol" : null, 
    "fileName" : null, 
    "fileNameLineCol" : null
  };
  var locationToStack = _.introspector.locationToStack;

//

  _.introspector.locationNormalize = function locationNormalize( o )
  {
  
    /* */
  
    if( locationNormalize.defaults )
    for( let e in o )
    {
      if( locationNormalize.defaults[ e ] === undefined )
      throw Error( 'Unknown option ' + e );
    }
  
    if( locationNormalize.defaults )
    for( let e in locationNormalize.defaults )
    {
      if( o[ e ] === undefined )
      o[ e ] = locationNormalize.defaults[ e ];
    }
  
    if( !( arguments.length === 1 ) )
    throw Error( 'Expects single argument' );
  
    if( !_.mapIs( o ) )
    throw Error( 'Expects options map' );
  
    /* */
  
    // if( !o.original )
    // o.original = o.stackFrame;
  
    let hadPath = !!o.filePath;
    if( !o.filePath )
    o.filePath = pathFromStack();
  
    pathCanonize();
    routineFromStack();
    routineAliasFromStack();
    internalForm();
  
    if( !_.strIs( o.filePath ) )
    return end();
  
    if( !_.numberIs( o.line ) )
    o.filePath = lineColFromPath( o.filePath );
  
    if( !_.numberIs( o.line ) && hadPath )
    {
      let path = pathFromStack();
      if( path )
      lineColFromPath( path );
    }
  
    return end();
  
    /* */
  
    function end()
    {
      let path = o.filePath;
  
      /* filePathLineCol */
  
      o.filePathLineCol = path || '';
      if( _.numberIs( o.line ) )
      {
        o.filePathLineCol += ':' + o.line;
        if( _.numberIs( o.col ) )
        o.filePathLineCol += ':' + o.col;
      }
  
      /* routineFilePathLineCol */
  
      if( o.routineName )
      o.routineFilePathLineCol = o.routineName + ' @ ' + o.filePathLineCol;
  
      /* fileName */
  
      if( path )
      {
        let fileName = path;
        _.assert( fileName.lastIndexOf );
        let i1 = fileName.lastIndexOf( '/' );
        let i2 = fileName.lastIndexOf( '\\' );
        let i = Math.max( i1, i2 );
        if( i !== -1 )
        fileName = fileName.substr( i+1 );
        o.fileName = fileName;
      }
  
      /* fileNameLineCol */
  
      o.fileNameLineCol = o.fileName || '';
      if( _.numberIs( o.line ) )
      {
        o.fileNameLineCol += ':' + o.line;
        if( _.numberIs( o.col ) )
        o.fileNameLineCol += ':' + o.col;
      }
  
      return o;
    }
  
    /* */
  
    function pathCanonize()
    {
      if( !o.filePath )
      return;
  
      if( _.path && _.path.canonize )
      o.filePath = _.path.canonize( o.filePath );
    }
  
    /* */
  
    function routineFromStack()
    {
      let routineName;
  
      if( o.routineName )
      return o.routineName;
      if( !o.original )
      return o.routineName;
  
      routineName = o.original;
  
      if( !_.strIs( routineName ) ) // Dmytro : it is duplicated condition. The first is if( !_.strIs( o.stackFrame ) ) throw ...
      return '{-anonymous-}';
  
      routineName = routineName.replace( /at eval \(eval at/, '' );
      let t = /^\s*(?:at\s+)?([\w\.<>]+)\s*.+/;
      let executed = t.exec( routineName );
      if( executed )
      routineName = executed[ 1 ] || '';
  
      routineName = routineName.replace( /<anonymous>/gm, '{-anonymous-}' );
  
      if( _.strEnds( routineName, '.' ) )
      routineName += '{-anonymous-}';
  
      o.routineName = routineName;
      return o.routineName;
    }
  
    /* */
  
    function routineAliasFromStack()
    {
      let routineAlias;
  
      if( o.routineAlias )
      return o.routineAlias;
      if( !o.original )
      return o.routineAlias;
  
      routineAlias = null;
  
      let t = /\[as ([^\]]*)\]/;
      let executed = t.exec( o.original );
      if( executed )
      routineAlias = executed[ 1 ] || null;
  
      if( routineAlias )
      routineAlias = routineAlias.replace( /<anonymous>/gm, '{-anonymous-}' );
  
      o.routineAlias = routineAlias;
      return o.routineAlias;
    }
  
    /* */
  
    function internalForm()
    {
  
      if( _.numberIs( o.internal ) )
      return;
  
      o.internal = 0;
  
      if( o.routineName )
      {
        if( o.internal < 2 )
        if( _.strBegins( o.routineName, '__' ) || o.routineName.indexOf( '.__' ) !== -1 )
        o.internal = 2;
        if( o.internal < 1 )
        if( _.strBegins( o.routineName, '_' ) || o.routineName.indexOf( '._' ) !== -1 )
        o.internal = 1;
      }
  
      if( o.routineAlias )
      {
        if( o.internal < 2 )
        if( _.strBegins( o.routineAlias, '__' ) || o.routineAlias.indexOf( '.__' ) !== -1 )
        o.internal = 2;
        if( o.internal < 1 )
        if( _.strBegins( o.routineAlias, '_' ) || o.routineAlias.indexOf( '._' ) !== -1 )
        o.internal = 1;
      }
  
      if( o.filePath )
      {
        if( o.internal < 2 )
        if( _.strBegins( o.filePath, 'internal/' ) )
        o.internal = 2;
      }
  
      // if( o.routineAlias )
      // splice |= stack[ 0 ].indexOf( '(vm.js:' ) !== -1;
      // splice |= stack[ 0 ].indexOf( '(module.js:' ) !== -1;
  
    }
  
    /* */
  
    function pathFromStack()
    {
      let path = o.original;
  
      if( !_.strIs( path ) )
      return;
  
      path = path.replace( /^\s+/, '' );
      path = path.replace( /^\w+@/, '' );
      path = path.replace( /^at/, '' );
      path = path.replace( /^\s+/, '' );
      path = path.replace( /\s+$/, '' );
  
      let regexp = /^.*\(([^\)]*)\).*$/;
      var parsed = regexp.exec( path );
      if( parsed )
      path = parsed[ 1 ];
  
      return path;
    }
  
    /* line / col number from path */
  
    function lineColFromPath( path )
    {
  
      let lineNumber, colNumber;
      let postfix = /(.+?):(\d+)(?::(\d+))?[^:/]*$/;
      let parsed = postfix.exec( path );
  
      if( parsed )
      {
        path = parsed[ 1 ];
        lineNumber = parsed[ 2 ];
        colNumber = parsed[ 3 ];
      }
  
      lineNumber = parseInt( lineNumber );
      colNumber = parseInt( colNumber );
  
      if( isNaN( o.line ) || o.line === null )
      if( !isNaN( lineNumber ) )
      o.line = lineNumber;
  
      if( isNaN( o.col ) || o.col === null )
      if( !isNaN( colNumber ) )
      o.col = colNumber;
  
      return path;
    }
  
  }
  _.introspector.locationNormalize.defaults =
  {
    "original" : null, 
    "filePath" : null, 
    "routineName" : null, 
    "routineAlias" : null, 
    "internal" : null, 
    "line" : null, 
    "col" : null, 
    "filePathLineCol" : null, 
    "routineFilePathLineCol" : null, 
    "fileName" : null, 
    "fileNameLineCol" : null
  };
  var locationNormalize = _.introspector.locationNormalize;

//


  _.path.refine = function refine( src )
  {
  
    _.assert( arguments.length === 1, 'Expects single argument' );
    _.assert( _.strIs( src ) );
  
    let result = src;
  
    if( result[ 1 ] === ':' )
    {
      if( result[ 2 ] === '\\' || result[ 2 ] === '/' )
      {
        if( result.length > 3 )
        result = '/' + result[ 0 ] + '/' + result.substring( 3 );
        else
        result = '/' + result[ 0 ]
      }
      else if( result.length === 2 )
      {
        result = '/' + result[ 0 ];
      }
    }
  
    result = result.replace( /\\/g, '/' );
  
    return result;
  };
  var refine = _.path.refine;

//

  _.path._normalize = function _normalize( o )
  {
    // let debug = 0;
    // if( 0 )
    // debug = 1;
  
    _.assertRoutineOptions( _normalize, arguments );
    _.assert( _.strIs( o.src ), 'Expects string' );
  
    if( !o.src.length )
    return '';
  
    let result = o.src;
  
    result = this.refine( result );
  
    // if( debug )
    // console.log( 'normalize.refined : ' + result );
  
    /* detrailing */
  
    if( o.tolerant )
    {
      /* remove "/" duplicates */
      result = result.replace( this._delUpDupRegexp, this._upStr );
    }
  
    let endsWithUp = false;
    let beginsWithHere = false;
  
    /* remove right "/" */
  
    if( result !== this._upStr && !_.strEnds( result, this._upStr + this._upStr ) && _.strEnds( result, this._upStr ) )
    {
      endsWithUp = true;
      result = _.strRemoveEnd( result, this._upStr );
    }
  
    /* undoting */
  
    while( !_.strBegins( result, this._hereUpStr + this._upStr ) && _.strBegins( result, this._hereUpStr ) )
    {
      beginsWithHere = true;
      result = _.strRemoveBegin( result, this._hereUpStr );
    }
  
    /* remove second "." */
  
    if( result.indexOf( this._hereStr ) !== -1 )
    {
  
      while( this._delHereRegexp.test( result ) )
      result = result.replace( this._delHereRegexp, function( match, postSlash )
      {
        return postSlash || '';
      });
      if( result === '' )
      result = this._upStr;
  
    }
  
    /* remove .. */
  
    if( result.indexOf( this._downStr ) !== -1 )
    {
  
      while( this._delDownRegexp.test( result ) )
      result = result.replace( this._delDownRegexp, ( match, notBegin, split, preSlash, postSlash ) =>
      {
        if( preSlash === '' )
        return notBegin;
        if( !notBegin )
        return notBegin + preSlash;
        else
        return notBegin + ( postSlash || '' );
      });
  
    }
  
    /* nothing left */
  
    if( !result.length )
    result = '.';
  
    /* dot and trail */
  
    if( o.detrailing )
    if( result !== this._upStr && !_.strEnds( result, this._upStr + this._upStr ) )
    result = _.strRemoveEnd( result, this._upStr );
  
    if( !o.detrailing && endsWithUp )
    if( result !== this._rootStr )
    result = result + this._upStr;
  
    if( !o.undoting && beginsWithHere )
    result = this._dot( result );
  
    // if( debug )
    // console.log( 'normalize.result : ' + result );
  
    return result;
  }
  _.path._normalize.defaults =
  {
    "src" : null, 
    "tolerant" : false, 
    "detrailing" : false, 
    "undoting" : false
  };
  var _normalize = _.path._normalize;

//

  _.path.canonize = function canonize( src )
  {
    let result = this._normalize({ src, tolerant : false, detrailing : true, undoting : true });
  
    _.assert( _.strIs( src ), 'Expects string' );
    _.assert( arguments.length === 1, 'Expects single argument' );
    _.assert( result === this._upStr || _.strEnds( result, this._upStr + this._upStr ) || !_.strEnds( result, this._upStr ) );
    _.assert( result.lastIndexOf( this._upStr + this._hereStr + this._upStr ) === -1 );
    _.assert( !_.strEnds( result, this._upStr + this._hereStr ) );
  
    if( Config.debug )
    {
      let i = result.lastIndexOf( this._upStr + this._downStr + this._upStr );
      _.assert( i === -1 || !/\w/.test( result.substring( 0, i ) ) );
    }
  
    return result;
  };
  var canonize = _.path.canonize;

//

  _.path.canonizeTolerant = function canonizeTolerant( src )
  {
    _.assert( _.strIs( src ),'Expects string' );
  
    let result = this._normalize({ src, tolerant : true, detrailing : true, undoting : true });
  
    _.assert( arguments.length === 1, 'Expects single argument' );
    _.assert( result === this._upStr || _.strEnds( result, this._upStr ) || !_.strEnds( result, this._upStr + this._upStr ) );
    _.assert( result.lastIndexOf( this._upStr + this._hereStr + this._upStr ) === -1 );
    _.assert( !_.strEnds( result, this._upStr + this._hereStr ) );
  
    if( Config.debug )
    {
      _.assert( !this._delUpDupRegexp.test( result ) );
    }
  
    return result;
  };
  var canonizeTolerant = _.path.canonizeTolerant;

//

  _.path._nativizeWindows = function _nativizeWindows( filePath )
  {
    let self = this;
    _.assert( _.strIs( filePath ), 'Expects string' ) ;
    let result = filePath.replace( /\//g, '\\' );
  
    if( result[ 0 ] === '\\' )
    if( result.length === 2 || result[ 2 ] === ':' || result[ 2 ] === '\\' )
    result = result[ 1 ] + ':' + result.substring( 2 );
  
    if( result.length === 2 && result[ 1 ] === ':' )
    result = result + '\\';
  
    return result;
  };
  var _nativizeWindows = _.path._nativizeWindows;

//

  _.path._nativizePosix = function _nativizePosix( filePath )
  {
    let self = this;
    _.assert( _.strIs( filePath ), 'Expects string' );
    return filePath;
  };
  var _nativizePosix = _.path._nativizePosix;

//

  _.path.isGlob = function isGlob( src )
  {
    let self = this;
  
    _.assert( arguments.length === 1, 'Expects single argument' );
    _.assert( _.strIs( src ) );
  
    if( self.fileProvider && !self.fileProvider.globing )
    {
      return false;
    }
  
    if( !self._pathIsGlobRegexp )
    _setup();
  
    return self._pathIsGlobRegexp.test( src );
  
    function _setup()
    {
      let _pathIsGlobRegexpStr = '';
      _pathIsGlobRegexpStr += '(?:[?*]+)'; /* asterix,question mark */
      _pathIsGlobRegexpStr += '|(?:([!?*@+]*)\\((.*?(?:\\|(.*?))*)\\))'; /* parentheses */
      _pathIsGlobRegexpStr += '|(?:\\[(.+?)\\])'; /* square brackets */
      _pathIsGlobRegexpStr += '|(?:\\{(.*)\\})'; /* curly brackets */
      _pathIsGlobRegexpStr += '|(?:\0)'; /* zero */
      self._pathIsGlobRegexp = new RegExp( _pathIsGlobRegexpStr );
    }
  
  };
  var isGlob = _.path.isGlob;

//

  _.path.isRelative = function isRelative( filePath )
  {
    _.assert( arguments.length === 1, 'Expects single argument' );
    _.assert( _.strIs( filePath ), 'Expects string {-filePath-}, but got', _.strType( filePath ) );
    return !this.isAbsolute( filePath );
  };
  var isRelative = _.path.isRelative;

//

  _.path.isAbsolute = function isAbsolute( filePath )
  {
    _.assert( arguments.length === 1, 'Expects single argument' );
    _.assert( _.strIs( filePath ), 'Expects string {-filePath-}, but got', _.strType( filePath ) );
    filePath = this.refine( filePath );
    return _.strBegins( filePath, this._upStr );
  };
  var isAbsolute = _.path.isAbsolute;

//

  _.path.ext = function ext( path )
  {
  
    _.assert( arguments.length === 1, 'Expects single argument' );
    _.assert( _.strIs( path ), 'Expects string {-path-}, but got', _.strType( path ) );
  
    let index = path.lastIndexOf( '/' );
    if( index >= 0 )
    path = path.substr( index+1, path.length-index-1  );
  
    index = path.lastIndexOf( '.' );
    if( index === -1 || index === 0 )
    return '';
  
    index += 1;
  
    return path.substr( index, path.length-index ).toLowerCase();
  };
  var ext = _.path.ext;

//

  _.path.isGlobal = function isGlobal( filePath )
  {
    _.assert( arguments.length === 1, 'Expects single argument' );
    _.assert( _.strIs( filePath ), 'Expects string' );
    return _.strHas( filePath, '://' );
  };
  var isGlobal = _.path.isGlobal;

//

  _.path._rootStr = `/`;

//
  _.path._upStr = `/`;

//
  _.path._hereStr = `.`;

//
  _.path._downStr = `..`;

//
  _.path._hereUpStr = `./`;

//
  _.path._downUpStr = `../`;

//
  _.path._rootRegSource = `\\/`;

//
  _.path._upRegSource = `\\/`;

//
  _.path._downRegSource = `\\.\\.`;

//
  _.path._hereRegSource = `\\.`;

//
  _.path._downUpRegSource = `\\.\\.\\/`;

//
  _.path._hereUpRegSource = `\\.\\/`;

//
  _.path._delHereRegexp = /\/\.(\/|$)/;

//
  _.path._delDownRegexp = /((?:.|^))(?:(?:\/\/)|(((?:^|\/))(?!\.\.(?:\/|$))(?:(?!\/).)+\/))\.\.((?:\/|$))/;

//
  _.path._delUpDupRegexp = /\/{2,}/g;

//
  _.path.currentAtBegin = `/pro/builder/proto/wtools/atop/starter.test/_asset/depGlobAnyAny`;

//


  _.strIs = function strIs( src )
  {
    let result = Object.prototype.toString.call( src ) === '[object String]';
    return result;
  };
  var strIs = _.strIs;

//

  _.strDefined = function strDefined( src )
  {
    if( !src )
    return false;
    let result = Object.prototype.toString.call( src ) === '[object String]';
    return result;
  };
  var strDefined = _.strDefined;

//

  _._strBeginOf = function _strBeginOf( src, begin )
  {
  
    _.assert( _.strIs( src ), 'Expects string' );
    _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  
    if( _.strIs( begin ) )
    {
      if( src.lastIndexOf( begin, 0 ) === 0 )
      return begin;
    }
    else if( _.regexpIs( begin ) )
    {
      let matched = begin.exec( src );
      if( matched && matched.index === 0 )
      return matched[ 0 ];
    }
    else _.assert( 0, 'Expects string-like ( string or regexp )' );
  
    return false;
  };
  var _strBeginOf = _._strBeginOf;

//

  _._strEndOf = function _strEndOf( src, end )
  {
  
    _.assert( _.strIs( src ), 'Expects string' );
    _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  
    if( _.strIs( end ) )
    {
      if( src.indexOf( end, src.length - end.length ) !== -1 )
      return end;
    }
    else if( _.regexpIs( end ) )
    {
      // let matched = end.exec( src );
      let newEnd = RegExp( end.toString().slice(1, -1) + '$' );
      let matched = newEnd.exec( src );
      debugger;
      //if( matched && matched.index === 0 )
      if( matched && matched.index + matched[ 0 ].length === src.length )
      return matched[ 0 ];
    }
    else _.assert( 0, 'Expects string-like ( string or regexp )' );
  
    return false;
  };
  var _strEndOf = _._strEndOf;

//

  _._strRemovedBegin = function _strRemovedBegin( src, begin )
  {
    _.assert( arguments.length === 2, 'Expects exactly two arguments' );
    _.assert( _.strIs( src ), 'Expects string {-src-}' );
  
    let result = src;
    let beginOf = _._strBeginOf( result, begin );
    if( beginOf !== false )
    result = result.substr( beginOf.length, result.length );
  
    return result;
  };
  var _strRemovedBegin = _._strRemovedBegin;

//

  _._strRemovedEnd = function _strRemovedEnd( src, end )
  {
    _.assert( arguments.length === 2, 'Expects exactly two arguments' );
    _.assert( _.strIs( src ), 'Expects string {-src-}' );
  
    let result = src;
    let endOf = _._strEndOf( result, end );
    if( endOf !== false )
    result = result.substr( 0, result.length - endOf.length );
  
    return result;
  };
  var _strRemovedEnd = _._strRemovedEnd;

//

  _.strBegins = function strBegins( src, begin )
  {
  
    _.assert( _.strIs( src ), 'Expects string {-src-}' );
    _.assert( _.strIs( begin ) || _.regexpIs( begin ) || _.longIs( begin ), 'Expects string/regexp or array of strings/regexps {-begin-}' );
    _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  
    if( !_.longIs( begin ) )
    {
      let result = _._strBeginOf( src, begin );
      return result === false ? result : true;
    }
  
    for( let b = 0, blen = begin.length ; b < blen; b++ )
    {
      let result = _._strBeginOf( src, begin[ b ] );
      if( result !== false )
      return true;
    }
  
    return false;
  };
  var strBegins = _.strBegins;

//

  _.strEnds = function strEnds( src, end )
  {
  
    _.assert( _.strIs( src ), 'Expects string {-src-}' );
    _.assert( _.strIs( end ) || _.regexpIs( end ) || _.longIs( end ), 'Expects string/regexp or array of strings/regexps {-end-}' );
    _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  
    if( !_.longIs( end ) )
    {
      let result = _._strEndOf( src, end );
      return result === false ? result : true;
    }
  
    for( let b = 0, blen = end.length ; b < blen; b++ )
    {
      let result = _._strEndOf( src, end[ b ] );
      if( result !== false )
      return true;
    }
  
    return false;
  };
  var strEnds = _.strEnds;

//

  _.strRemoveBegin = function strRemoveBegin( src, begin )
  {
    _.assert( arguments.length === 2, 'Expects exactly two arguments' );
    _.assert( _.longIs( src ) || _.strIs( src ), 'Expects string or array of strings {-src-}' );
    _.assert( _.longIs( begin ) || _.strIs( begin ) || _.regexpIs( begin ), 'Expects string/regexp or array of strings/regexps {-begin-}' );
  
    let result = [];
    let srcIsArray = _.longIs( src );
  
    if( _.strIs( src ) && !_.longIs( begin ) )
    return _._strRemovedBegin( src, begin );
  
    src = _.arrayAs( src );
    begin = _.arrayAs( begin );
    for( let s = 0, slen = src.length ; s < slen ; s++ )
    {
      let beginOf = false;
      let src1 = src[ s ]
      for( let b = 0, blen = begin.length ; b < blen ; b++ )
      {
        beginOf = _._strBeginOf( src1, begin[ b ] );
        if( beginOf !== false )
        break;
      }
      if( beginOf !== false )
      src1 = src1.substr( beginOf.length, src1.length );
      result[ s ] = src1;
    }
  
    if( !srcIsArray )
    return result[ 0 ];
  
    return result;
  };
  var strRemoveBegin = _.strRemoveBegin;

//

  _.strRemoveEnd = function strRemoveEnd( src, end )
  {
    _.assert( arguments.length === 2, 'Expects exactly two arguments' );
    _.assert( _.longIs( src ) || _.strIs( src ), 'Expects string or array of strings {-src-}' );
    _.assert( _.longIs( end ) || _.strIs( end ) || _.regexpIs( end ), 'Expects string/regexp or array of strings/regexps {-end-}' );
  
    let result = [];
    let srcIsArray = _.longIs( src );
  
    if( _.strIs( src ) && !_.longIs( end ) )
    return _._strRemovedEnd( src, end );
  
    src = _.arrayAs( src );
    end = _.arrayAs( end );
  
    for( let s = 0, slen = src.length ; s < slen ; s++ )
    {
      let endOf = false;
      let src1 = src[ s ]
      for( let b = 0, blen = end.length ; b < blen ; b++ )
      {
        endOf = _._strEndOf( src1, end[ b ] );
        if( endOf !== false )
        break;
      }
      if( endOf !== false )
      src1 = src1.substr( 0, src1.length - endOf.length );
      result[ s ] = src1;
    }
  
    if( !srcIsArray )
    return result[ 0 ];
  
    return result;
  };
  var strRemoveEnd = _.strRemoveEnd;

//

  _.regexpIs = function regexpIs( src )
  {
    return Object.prototype.toString.call( src ) === '[object RegExp]';
  };
  var regexpIs = _.regexpIs;

//

  _.longIs = function longIs( src )
  {
    if( _.primitiveIs( src ) )
    return false;
    if( _.routineIs( src ) )
    return false;
    if( _.objectIs( src ) )
    return false;
    if( _.strIs( src ) )
    return false;
    if( _.bufferNodeIs( src ) )
    return false;
  
    if( Object.propertyIsEnumerable.call( src, 'length' ) )
    return false;
    if( !_.numberIs( src.length ) )
    return false;
  
    return true;
  };
  var longIs = _.longIs;

//

  _.primitiveIs = function primitiveIs( src )
  {
    if( !src )
    return true;
    let t = Object.prototype.toString.call( src );
    return t === '[object Symbol]' || t === '[object Number]' || t === '[object BigInt]' || t === '[object Boolean]' || t === '[object String]';
  };
  var primitiveIs = _.primitiveIs;

//

  _.strBegins = function strBegins( src, begin )
  {
  
    _.assert( _.strIs( src ), 'Expects string {-src-}' );
    _.assert( _.strIs( begin ) || _.regexpIs( begin ) || _.longIs( begin ), 'Expects string/regexp or array of strings/regexps {-begin-}' );
    _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  
    if( !_.longIs( begin ) )
    {
      let result = _._strBeginOf( src, begin );
      return result === false ? result : true;
    }
  
    for( let b = 0, blen = begin.length ; b < blen; b++ )
    {
      let result = _._strBeginOf( src, begin[ b ] );
      if( result !== false )
      return true;
    }
  
    return false;
  };
  var strBegins = _.strBegins;

//

  _.objectIs = function objectIs( src )
  {
    return Object.prototype.toString.call( src ) === '[object Object]';
  };
  var objectIs = _.objectIs;

//

  _.objectLike = function objectLike( src )
  {
  
    if( _.objectIs( src ) )
    return true;
  
    if( _.primitiveIs( src ) )
    return false;
    if( _.longIs( src ) )
    return false;
    if( _.routineIsPure( src ) )
    return false;
  
    for( let k in src )
    return true;
  
    return false;
  };
  var objectLike = _.objectLike;

//

  _.arrayLike = function arrayLike( src )
  {
    if( _.arrayIs( src ) )
    return true;
    if( _.argumentsArrayIs( src ) )
    return true;
    return false;
  };
  var arrayLike = _.arrayLike;

//

  _.mapLike = function mapLike( src )
  {
  
    // if( _.complex )
    // if( _.complex.is( src ) )
    // return false;
  
    if( mapIs( src ) )
    return true;
  
    if( !src )
    return false;
  
    // if( src.constructor === Object || src.constructor === null )
    // return true;
  
    if( !_.objectLike( src ) )
    return false;
  
    if( _.instanceIs( src ) )
    return false;
  
    return true;
  };
  var mapLike = _.mapLike;

//

  _.strsLikeAll = function strsLikeAll( src )
  {
    _.assert( arguments.length === 1 );
  
    if( _.arrayLike( src ) )
    {
      for( let s = 0 ; s < src.length ; s++ )
      if( !_.strLike( src[ s ] ) )
      return false;
      return true;
    }
  
    return strLike( src );
  };
  var strsLikeAll = _.strsLikeAll;

//

  _.boolLike = function boolLike( src )
  {
    let type = Object.prototype.toString.call( src );
    return type === '[object Boolean]' || type === '[object Number]';
  };
  var boolLike = _.boolLike;

//

  _.arrayIs = function arrayIs( src )
  {
    return Array.isArray( src );
    // return Object.prototype.toString.call( src ) === '[object Array]';
  };
  var arrayIs = _.arrayIs;

//

  _.numberIs = function numberIs( src )
  {
    return typeof src === 'number';
    return Object.prototype.toString.call( src ) === '[object Number]';
  };
  var numberIs = _.numberIs;

//

  _.setIs = function setIs( src )
  {
    if( !src )
    return false;
    return src instanceof Set || src instanceof WeakSet;
  };
  var setIs = _.setIs;

//

  _.setLike = function setLike( src )
  {
    return _.setIs( src );
  };
  var setLike = _.setLike;

//

  _.hashMapIs = function hashMapIs( src )
  {
    if( !src )
    return false;
    return src instanceof HashMap || src instanceof HashMapWeak;
  };
  var hashMapIs = _.hashMapIs;

//

  _.hashMapLike = function hashMapLike( src )
  {
    return _.hashMapIs( src );
  };
  var hashMapLike = _.hashMapLike;

//

  _.argumentsArrayIs = function argumentsArrayIs( src )
  {
    return Object.prototype.toString.call( src ) === '[object Arguments]';
  };
  var argumentsArrayIs = _.argumentsArrayIs;

//

  _.routineIs = function routineIs( src )
  {
    let result = Object.prototype.toString.call( src );
    return result === '[object Function]' || result === '[object AsyncFunction]';
  };
  var routineIs = _.routineIs;

//

  _.routineIsPure = function routineIsPure( src )
  {
    if( !src )
    return false;
    let proto = Object.getPrototypeOf( src );
    if( proto === Object.getPrototypeOf( Function ) )
    return true;
    if( proto.constructor.name === 'AsyncFunction' )
    return true;
    return false;
  };
  var routineIsPure = _.routineIsPure;

//

  _.lengthOf = function entityLength( src )
  {
    if( src === undefined )
    return 0;
    if( _.longIs( src ) )
    return src.length;
    if( _.setLike( src ) )
    return src.size;
    if( _.hashMapLike( src ) )
    return src.size;
    if( _.objectLike( src ) )
    return _.mapOwnKeys( src ).length;
    return 1;
  };
  var lengthOf = _.lengthOf;

//

  _.mapIs = function mapIs( src )
  {
  
    if( !_.objectIs( src ) )
    return false;
  
    let proto = Object.getPrototypeOf( src );
  
    if( proto === null )
    return true;
  
    if( !proto.constructor )
    return false;
  
    if( proto.constructor.name !== 'Object' )
    return false;
  
    // if( proto.constructor && proto.constructor.name !== 'Object' )
    // return false;
  
    if( Object.getPrototypeOf( proto ) === null )
    return true;
  
    _.assert( proto === null || !!proto, 'unexpected' );
  
    return false;
  };
  var mapIs = _.mapIs;

//

  _.sure = function sure( condition )
  {
  
    if( !condition || !boolLike( condition ) )
    {
      _sureDebugger( condition );
      if( arguments.length === 1 )
      throw _err
      ({
        args : [ 'Assertion fails' ],
        level : 2,
      });
      else if( arguments.length === 2 )
      throw _err
      ({
        args : [ arguments[ 1 ] ],
        level : 2,
      });
      else
      throw _err
      ({
        args : Array.prototype.slice.call( arguments, 1 ),
        level : 2,
      });
    }
  
    return;
  
    function boolLike( src )
    {
      let type = Object.prototype.toString.call( src );
      return type === '[object Boolean]' || type === '[object Number]';
    }
  
  };
  var sure = _.sure;

//

  _.mapBut = function mapBut( srcMap, butMap )
  {
    let result = Object.create( null );
  
    _.assert( arguments.length === 2, 'Expects exactly two arguments' );
    _.assert( !_.primitiveIs( srcMap ), 'Expects map {-srcMap-}' );
  
    if( _.longLike( butMap ) )
    {
      for( let s in srcMap )
      {
        let m;
        for( m = 0 ; m < butMap.length ; m++ )
        {
          if( s === butMap[ m ] )
          break;
          if( _.mapIs( butMap[ m ] ) )
          if( s in butMap[ m ] )
          break;
        }
  
        if( m === butMap.length )
        result[ s ] = srcMap[ s ];
      }
    }
    else if( _.objectLike( butMap ) || _.routineIs( butMap ) )
    {
      for( let s in srcMap )
      {
        if( !( s in butMap ) )
        result[ s ] = srcMap[ s ];
      }
    }
    else
    {
      _.assert( 0, 'Expects object-like or long-like {-butMap-}' );
    }
  
    return result;
  };
  var mapBut = _.mapBut;

//

  _.mapHas = function mapHasKey( srcMap, key )
  {
  
    if( !srcMap )
    return false;
  
    if( typeof srcMap !== 'object' )
    return false;
  
    if( !Reflect.has( srcMap, key ) )
    return false;
  
    return true;
  };
  var mapHas = _.mapHas;

//

  _._mapKeys = function _mapKeys( o )
  {
    let result = [];
  
    _.routineOptions( _mapKeys, o );
  
    let srcMap = o.srcMap;
    let selectFilter = o.selectFilter;
  
    _.assert( arguments.length === 1, 'Expects single argument' );
    _.assert( _.objectLike( o ) );
    _.assert( !( srcMap instanceof Map ), 'not implemented' );
    _.assert( selectFilter === null || _.routineIs( selectFilter ) );
  
    /* */
  
    if( o.enumerable )
    {
      let result1 = [];
  
      _.assert( !_.primitiveIs( srcMap ) );
  
      if( o.own )
      {
        for( let k in srcMap )
        if( Object.hasOwnProperty.call( srcMap, k ) )
        result1.push( k );
      }
      else
      {
        for( let k in srcMap )
        result1.push( k );
      }
  
      filter( srcMap, result1 );
  
    }
    else
    {
      _.assert( !( srcMap instanceof Map ), 'not implemented' );
  
      if( o.own  )
      {
        filter( srcMap, Object.getOwnPropertyNames( srcMap ) );
      }
      else
      {
        let proto = srcMap;
        result = [];
        do
        {
          filter( proto, Object.getOwnPropertyNames( proto ) );
          proto = Object.getPrototypeOf( proto );
        }
        while( proto );
      }
  
    }
  
    return result;
  
    /* */
  
    function filter( srcMap, keys )
    {
  
      if( !selectFilter )
      {
        _.arrayAppendArrayOnce( result, keys );
      }
      else for( let k = 0 ; k < keys.length ; k++ )
      {
        let e = selectFilter( srcMap, keys[ k ] );
        if( e !== undefined )
        _.arrayAppendOnce( result, e );
      }
  
    }
  
  }
  _._mapKeys.defaults =
  {
    "srcMap" : null, 
    "own" : 0, 
    "enumerable" : 1, 
    "selectFilter" : null
  };
  var _mapKeys = _._mapKeys;

//

  _.mapOwnKeys = function mapOwnKeys( srcMap, o )
  {
    let result;
    // let o = this === Self ? Object.create( null ) : this;
  
    _.assert( arguments.length === 1 || arguments.length === 2 );
    o = _.routineOptions( mapOwnKeys, o );
    _.assert( !_.primitiveIs( srcMap ) );
  
    o.srcMap = srcMap;
    o.own = 1;
  
    // if( o.enumerable )
    // result = _._mapEnumerableKeys( o.srcMap, o.own );
    // else
    result = _._mapKeys( o );
  
    if( !o.enumerable )
    debugger;
  
    return result;
  }
  _.mapOwnKeys.defaults =
  { "enumerable" : 1 };
  var mapOwnKeys = _.mapOwnKeys;

//

  _.sureMapHasOnly = function sureMapHasOnly( srcMap, screenMaps, msg )
  {
    _.assert( arguments.length === 2 || arguments.length === 3 || arguments.length === 4, 'Expects two, three or four arguments' );
  
    let but = Object.keys( _.mapBut( srcMap, screenMaps ) );
  
    if( but.length > 0 )
    {
      debugger;
      if( arguments.length === 2 )
      throw _._err
      ({
        args : [ `${ _.strType( srcMap ) } should have no fields :`, _.strQuote( but ).join( ', ' ) ],
        // args : [ _.strType( srcMap ) + ' should have no fields :', _.strQuote( but ).join( ', ' ) ],
        level : 2,
      });
      else
      {
        let arr = [];
        for ( let i = 2; i < arguments.length; i++ )
        {
          if( _.routineIs( arguments[ i ] ) )
          arguments[ i ] = ( arguments[ i ] )();
          arr.push( arguments[ i ] );
        }
        throw _._err
        ({
          args : [ arr.join( ' ' ), _.strQuote( but ).join( ', ' ) ],
          level : 2,
        });
      }
  
      return false;
    }
  
    return true;
  };
  var sureMapHasOnly = _.sureMapHasOnly;

//

  _.sureMapHasNoUndefine = function sureMapHasNoUndefine( srcMap, msg )
  {
  
    _.assert( arguments.length === 1 || arguments.length === 2 || arguments.length === 3, 'Expects one, two or three arguments' )
  
    let but = [];
  
    for( let s in srcMap )
    if( srcMap[ s ] === undefined )
    but.push( s );
  
    if( but.length > 0 )
    {
      debugger;
      if( arguments.length === 1 )
      throw _._err
      ({
        args : [ `${ _.strType( srcMap ) } should have no undefines, but has :`, _.strQuote( but ).join( ', ' ) ],
        level : 2,
      });
      else
      {
        let arr = [];
        for ( let i = 1; i < arguments.length; i++ )
        {
          if( _.routineIs( arguments[ i ] ) )
          arguments[ i ] = ( arguments[ i ] )();
          arr.push( arguments[ i ] );
        }
        throw _._err
        ({
          args : [ arr.join( ' ' ), _.strQuote( but ).join( ', ' ) ],
          level : 2,
        });
      }
  
      return false;
    }
  
    return true;
  };
  var sureMapHasNoUndefine = _.sureMapHasNoUndefine;

//

  _.mapSupplementStructureless = function mapSupplementStructureless( dstMap, srcMap )
  {
    if( dstMap === null && arguments.length === 2 )
    return Object.assign( Object.create( null ), srcMap );
  
    if( dstMap === null )
    dstMap = Object.create( null );
  
    for( let a = 1 ; a < arguments.length ; a++ )
    {
      srcMap = arguments[ a ];
      for( let s in srcMap )
      {
        if( dstMap[ s ] !== undefined )
        continue;
        if( _.objectLike( srcMap[ s ] ) || _.arrayLike( srcMap[ s ] ) )
        {
          debugger;
          throw Error( 'Source map should have only primitive elements, but ' + s + ' is ' + srcMap[ s ] );
        }
        dstMap[ s ] = srcMap[ s ];
      }
    }
  
    return dstMap
  };
  var mapSupplementStructureless = _.mapSupplementStructureless;

//

  _.assertMapHasOnly = function assertMapHasOnly( srcMap, screenMaps, msg )
  {
    if( Config.debug === false )
    return true;
    return _.sureMapHasOnly.apply( this, arguments );
  };
  var assertMapHasOnly = _.assertMapHasOnly;

//

  _.assertMapHasNoUndefine = function assertMapHasNoUndefine( srcMap, msg )
  {
    if( Config.debug === false )
    return true;
    return _.sureMapHasNoUndefine.apply( this, arguments );
  };
  var assertMapHasNoUndefine = _.assertMapHasNoUndefine;

//

  _.routineOptions = function routineOptions( routine, args, defaults )
  {
  
    if( !_.arrayLike( args ) )
    args = [ args ];
    let options = args[ 0 ];
    let name = routine ? routine.name : '';
    if( options === undefined )
    options = Object.create( null );
    defaults = defaults || ( routine ? routine.defaults : null );
  
    _.assert( arguments.length === 2 || arguments.length === 3, 'Expects 2 or 3 arguments' );
    _.assert( _.routineIs( routine ) || routine === null, 'Expects routine' );
    _.assert( _.objectIs( defaults ), 'Expects routine with defined defaults or defaults in third argument' );
    _.assert( _.objectIs( options ), 'Expects object' );
    _.assert( args.length === 0 || args.length === 1, 'Expects single options map, but got', args.length, 'arguments' );
  
    _.assertMapHasOnly( options, defaults, `Routine ${name} does not expect options:` );
    _.mapSupplementStructureless( options, defaults );
    _.assertMapHasNoUndefine( options, `Options map for routine ${name} should have no undefined fileds, but it does have` );
  
    return options;
  };
  var routineOptions = _.routineOptions;

//

  _.routineExtend = function routineExtend( dst, src )
  {
  
    _.assert( arguments.length === 1 || arguments.length === 2 || arguments.length === 3 );
    _.assert( _.routineIs( dst ) || dst === null );
    _.assert( src === null || src === undefined || _.mapLike( src ) || _.routineIs( src ) );
  
    /* generate dst routine */
  
    if( dst === null )
    {
  
      let dstMap = Object.create( null );
      for( let a = 0 ; a < arguments.length ; a++ )
      {
        let src = arguments[ a ];
        if( src === null )
        continue;
        _.mapExtend( dstMap, src )
      }
  
      if( dstMap.head && dstMap.body )
      {
        dst = _.routineUnite( dstMap.head, dstMap.body );
      }
      else
      {
        _.assert( _.routineIs( src ) );
        dst = function(){ return src.apply( this, arguments ); }
      }
      // _.assert( 0, 'Not clear how to construct the routine' );
      // dst = dstMap;
  
    }
  
    /* shallow clone properties of dst routine */
  
    for( let s in dst )
    {
      let property = dst[ s ];
      if( _.mapIs( property ) )
      {
        property = _.mapExtend( null, property );
        dst[ s ] = property;
      }
    }
  
    /* extend dst routine */
  
    for( let a = 0 ; a < arguments.length ; a++ )
    {
      let src = arguments[ a ];
      if( src === null )
      continue;
      _.assert( _.mapLike( src ) || _.routineIs( src ) );
      for( let s in src )
      {
        let property = src[ s ];
        let d = Object.getOwnPropertyDescriptor( dst, s );
        if( d && !d.writable )
        continue;
        if( _.objectIs( property ) )
        {
          _.assert( !_.mapHas( dst, s ) || _.mapIs( dst[ s ] ) );
          property = Object.create( property );
          // property = _.mapExtend( null, property ); /* zzz : it breaks files. investigate */
          if( dst[ s ] )
          _.mapSupplement( property, dst[ s ] );
        }
        dst[ s ] = property;
      }
    }
  
    return dst;
  };
  var routineExtend = _.routineExtend;

//

  _.arrayAppendArray = function arrayAppendArray( dstArray, insArray )
  {
    if( dstArray === null )
    {
      dstArray = [];
      arguments[ 0 ] = dstArray;
    }
  
    _.arrayAppendedArray.apply( this, arguments );
    return dstArray;
  };
  var arrayAppendArray = _.arrayAppendArray;

//

  _.arrayAppendArrays = function arrayAppendArrays( dstArray, insArray )
  {
  
    if( dstArray === null )
    {
      dstArray = [];
      arguments[ 0 ] = dstArray;
    }
  
    if( dstArray === undefined )
    {
      _.assert( arguments.length === 2 );
      return insArray;
    }
  
    _.arrayAppendedArrays.apply( this, arguments );
  
    return dstArray;
  };
  var arrayAppendArrays = _.arrayAppendArrays;

//

  _.arrayAppendedArray = function arrayAppendedArray( dstArray, insArray )
  {
    _.assert( arguments.length === 2 )
    _.assert( _.arrayIs( dstArray ), 'arrayPrependedArray :', 'Expects array' );
    _.assert( _.longLike( insArray ), 'arrayPrependedArray :', 'Expects longLike' );
  
    let result = insArray.length;
    dstArray.push.apply( dstArray, insArray );
    return result;
  };
  var arrayAppendedArray = _.arrayAppendedArray;

//

  _.arrayAppendedArrays = function arrayAppendedArrays( dstArray, insArray )
  {
  
    _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  
    if( !_.longLike( insArray ) && insArray !== undefined )
    insArray = [ insArray ];
  
    // if( !_.longLike( insArray ) )
    // {
    //   if( !_.arrayIs( dstArray ) )
    //   return [ dstArray, insArray ];
    //   else
    //   dstArray.push( insArray );
    //   return 1;
    // }
  
    // if( !_.arrayIs( insArray ) && insArray !== undefined )
    // insArray = [ insArray ];
    // if( !_.arrayIs( insArray ) && insArray !== undefined )
    // insArray = [ insArray ];
  
    _.assert( _.arrayIs( dstArray ), 'Expects array' );
    _.assert( _.longLike( insArray ), 'Expects longLike entity' );
  
    let result = 0;
  
    for( let a = 0, len = insArray.length; a < len; a++ )
    {
      if( _.longLike( insArray[ a ] ) )
      {
        dstArray.push.apply( dstArray, insArray[ a ] );
        result += insArray[ a ].length;
      }
      else
      {
        dstArray.push( insArray[ a ] );
        result += 1;
      }
    }
  
    return result;
  };
  var arrayAppendedArrays = _.arrayAppendedArrays;

//

  _.arrayAppended = function arrayAppended( dstArray, ins )
  {
    _.assert( arguments.length === 2  );
    _.assert( _.arrayIs( dstArray ), () => `Expects array as the first argument {-dstArray-} but got "${ dstArray }"` );
    dstArray.push( ins );
    return dstArray.length - 1;
  };
  var arrayAppended = _.arrayAppended;

//

  _.arrayAppendOnceStrictly = function arrayAppendOnceStrictly( dstArray, ins, evaluator1, evaluator2 )
  {
    if( dstArray === null )
    {
      dstArray = [];
      arguments[ 0 ] = dstArray;
    }
  
    let result;
    if( Config.debug )
    {
      result = _.arrayAppendedOnce.apply( this, arguments );
      _.assert( result >= 0, () => `Array should have only unique elements, but has several ${ _.strEntityShort( ins ) }` );
    }
    else
    {
      result = _.arrayAppended.apply( this, [ dstArray, ins ] );
    }
    return dstArray;
  };
  var arrayAppendOnceStrictly = _.arrayAppendOnceStrictly;

//

  _.arrayAppendArrayOnce = function arrayAppendArrayOnce( dstArray, insArray, evaluator1, evaluator2 )
  {
    if( dstArray === null )
    {
      dstArray = [];
      arguments[ 0 ] = dstArray;
    }
  
    _.arrayAppendedArrayOnce.apply( this, arguments )
    return dstArray;
  };
  var arrayAppendArrayOnce = _.arrayAppendArrayOnce;

//

  _.arrayAppendedArrayOnce = function arrayAppendedArrayOnce( dstArray, insArray, evaluator1, evaluator2 )
  {
    _.assert( _.longLike( insArray ) );
    // _.assert( dstArray !== insArray );
    _.assert( 2 <= arguments.length && arguments.length <= 4 );
  
    let result = 0;
  
    if( dstArray === insArray )
    if( arguments.length === 2 )
    return result;
  
    for( let i = 0, len = insArray.length; i < len ; i++ )
    {
      if( _.longLeftIndex( dstArray, insArray[ i ], evaluator1, evaluator2 ) === -1 )
      {
        dstArray.push( insArray[ i ] );
        result += 1;
      }
    }
  
    return result;
  };
  var arrayAppendedArrayOnce = _.arrayAppendedArrayOnce;

//

  _.arrayAppendedOnce = function arrayAppendedOnce( dstArray, ins, evaluator1, evaluator2 )
  {
    let i = _.longLeftIndex.apply( _, arguments );
  
    if( i === -1 )
    {
      dstArray.push( ins );
      return dstArray.length - 1;
    }
  
    return -1;
  };
  var arrayAppendedOnce = _.arrayAppendedOnce;

//

  _.arrayRemoveOnceStrictly = function arrayRemoveOnceStrictly( dstArray, ins, evaluator1, evaluator2 )
  {
    _.arrayRemoveElementOnceStrictly.apply( this, arguments );
    return dstArray;
  };
  var arrayRemoveOnceStrictly = _.arrayRemoveOnceStrictly;

//

  _.arrayRemoveElementOnceStrictly = function arrayRemoveElementOnceStrictly( dstArray, ins, evaluator1, evaluator2 )
  {
    let result;
    if( Config.debug )
    {
      let result = _.arrayRemovedElementOnce.apply( this, arguments );
      let index = _.longLeftIndex.apply( _, arguments );
      _.assert( index < 0 );
      _.assert( result >= 0, () => 'Array does not have element ' + _.toStrShort( ins ) );
    }
    else
    {
      let result = _.arrayRemovedElement.apply( this, [ dstArray, ins ] );
    }
    return dstArray;
  };
  var arrayRemoveElementOnceStrictly = _.arrayRemoveElementOnceStrictly;

//

  _.arrayRemovedElement = function arrayRemovedElement( dstArray, ins, evaluator1, evaluator2 )
  {
    let index = _.longLeftIndex.apply( this, arguments );
    let removedElements = 0;
  
    for( let i = 0; i < dstArray.length; i++ ) /* Dmytro : bad implementation, this cycle run routine longLeftIndex even if it not needs, better implementation commented below */
    {
      if( index !== -1 )
      {
        dstArray.splice( index, 1 );
        removedElements = removedElements + 1;
        i = i - 1 ;
      }
      index = _.longLeftIndex.apply( this, arguments ); /* Dmytro : this call uses not offset, it makes routine slower */
    }
  
    return removedElements;
  
    // let removedElements = 0;
    // let index = _.longLeftIndex.apply( this, arguments );
    // evaluator1 = _.numberIs( evaluator1 ) ? undefined : evaluator1;
    //
    // while( index !== -1 )
    // {
    //   dstArray.splice( index, 1 );
    //   removedElements = removedElements + 1;
    //   index = _.longLeftIndex( dstArray, ins, index, evaluator1, evaluator2 );
    // }
    //
    // return removedElements;
  };
  var arrayRemovedElement = _.arrayRemovedElement;

//

  _.arrayRemovedElementOnce = function arrayRemovedElementOnce( dstArray, ins, evaluator1, evaluator2 )
  {
  
    let index = _.longLeftIndex.apply( _, arguments );
    if( index >= 0 )
    dstArray.splice( index, 1 );
  
    return index;
    /* "!!! : breaking" */
    /* // arrayRemovedElementOnce should return the removed element
    let result;
    let index = _.longLeftIndex.apply( _, arguments );
  
    if( index >= 0 )
    {
      result = dstArray[ index ];
      dstArray.splice( index, 1 );
    }
  
    return result;
    */
  };
  var arrayRemovedElementOnce = _.arrayRemovedElementOnce;

//

  _.longLike = function longLike( src )
  {
    return _.longIs( src );
  };
  var longLike = _.longLike;

//

  _.longLeft = function longLeft( arr, ins, fromIndex, evaluator1, evaluator2 )
  {
    let result = Object.create( null );
    let i = _.longLeftIndex( arr, ins, fromIndex, evaluator1, evaluator2 );
  
    _.assert( 2 <= arguments.length && arguments.length <= 5 );
  
    result.index = i;
  
    if( i >= 0 )
    result.element = arr[ i ];
  
    return result;
  };
  var longLeft = _.longLeft;

//

  _.longLeftIndex = function longLeftIndex( arr, ins, evaluator1, evaluator2 )
  {
    let fromIndex = 0;
  
    if( _.numberIs( arguments[ 2 ] ) )
    {
      fromIndex = arguments[ 2 ];
      evaluator1 = arguments[ 3 ];
      evaluator2 = arguments[ 4 ];
    }
  
    _.assert( 2 <= arguments.length && arguments.length <= 5, 'Expects 2-5 arguments: source array, element, and optional evaluator / equalizer' );
    _.assert( _.longLike( arr ), 'Expect a Long' );
    _.assert( _.numberIs( fromIndex ) );
    _.assert( !evaluator1 || evaluator1.length === 1 || evaluator1.length === 2 );
    _.assert( !evaluator1 || _.routineIs( evaluator1 ) );
    _.assert( !evaluator2 || evaluator2.length === 1 );
    _.assert( !evaluator2 || _.routineIs( evaluator2 ) );
  
    if( !evaluator1 )
    {
      _.assert( !evaluator2 );
      return _ArrayIndexOf.call( arr, ins, fromIndex );
    }
    else if( evaluator1.length === 2 ) /* equalizer */
    {
      _.assert( !evaluator2 );
      for( let a = fromIndex ; a < arr.length ; a++ )
      {
        if( evaluator1( arr[ a ], ins ) )
        return a;
      }
    }
    else /* evaluator */
    {
  
      if( evaluator2 )
      ins = evaluator2( ins );
      else
      ins = evaluator1( ins );
  
      if( arr.findIndex && fromIndex === 0 )
      {
        return arr.findIndex( ( e ) => evaluator1( e ) === ins );
      }
      else
      {
        for( let a = fromIndex; a < arr.length ; a++ )
        {
          if( evaluator1( arr[ a ] ) === ins )
          return a;
        }
      }
  
    }
  
    return -1;
  };
  var longLeftIndex = _.longLeftIndex;

//

  _.longLeftDefined = function longLeftDefined( arr )
  {
    _.assert( arguments.length === 1, 'Expects single argument' );
    return _.longLeft( arr, true, function( e ){ return e !== undefined; } );
  };
  var longLeftDefined = _.longLeftDefined;

//

  _.longHas = function longHas( array, element, evaluator1, evaluator2 )
  {
    _.assert( 2 <= arguments.length && arguments.length <= 4 );
    _.assert( _.arrayLike( array ) );
  
    if( !evaluator1 && !evaluator2 )
    {
      // return _ArrayIndexOf.call( array, element ) !== -1;
      return _ArrayIncludes.call( array, element );
    }
    else
    {
      if( _.longLeftIndex( array, element, evaluator1, evaluator2 ) >= 0 )
      return true;
      return false;
    }
  
  };
  var longHas = _.longHas;

//

  
    var _routineUnite_head = function routineUnite_head( routine, args )
    {
      let o = args[ 0 ];
    
      if( args[ 1 ] !== undefined )
      {
        o = { pre : args[ 0 ], body : args[ 1 ], name : args[ 2 ] };
      }
    
      _.routineOptions( routine, o );
      _.assert( args.length === 1 || args.length === 2 || args.length === 3 );
      _.assert( arguments.length === 2 );
      _.assert( _.routineIs( o.head ) || _.routinesAre( o.head ), 'Expects routine or routines {-o.head-}' );
      _.assert( _.routineIs( o.body ), 'Expects routine {-o.body-}' );
      _.assert( o.body.defaults !== undefined, 'Body should have defaults' );
    
      return o;
    }
  
    //
  
  
    var _routineUnite_body = function routineUnite_body( o )
    {
    
      _.assert( arguments.length === 1 ); // args, r, o, k
    
      if( !_.routineIs( o.head ) )
      {
        let _head = _.routinesCompose( o.head, function( args, result, op, k )
        {
          _.assert( arguments.length === 4 );
          _.assert( !_.unrollIs( result ) );
          _.assert( _.objectIs( result ) );
          return _.unrollAppend([ callPreAndBody, [ result ] ]);
        });
        _.assert( _.routineIs( _head ) );
        o.head = function pre()
        {
    
          let result = _head.apply( this, arguments );
          return result[ result.length-1 ];
        }
      }
    
      let pre = o.head;
      let body = o.body;
    
      if( !o.name )
      {
        _.assert( _.strDefined( o.body.name ), 'Body routine should have name' );
        o.name = o.body.name;
        if( o.name.indexOf( '_body' ) === o.name.length-5 && o.name.length > 5 )
        o.name = o.name.substring( 0, o.name.length-5 );
      }
    
      let r =
      {
        [ o.name ] : function()
        {
          let result;
          let o = pre.call( this, callPreAndBody, arguments );
          _.assert( !_.argumentsArrayIs( o ), 'does not expect arguments array' );
          if( _.unrollIs( o ) )
          result = body.apply( this, o );
          else
          result = body.call( this, o );
          return result;
        }
      }
    
      let callPreAndBody = r[ o.name ];
    
      _.assert( _.strDefined( callPreAndBody.name ), 'Looks like your interpreter does not support dynamic naming of functions. Please use ES2015 or later interpreter.' );
    
      _.routineExtend( callPreAndBody, o.body );
    
      callPreAndBody.head = o.head;
      callPreAndBody.body = o.body;
    
      return callPreAndBody;
    }
  
    //
  
  _routineUnite_body.defaults = { "pre" : null, "body" : null, "name" : null }
    ;
  _.routineUnite = function routineUnite()
    {
      let o = routineUnite.head.call( this, routineUnite, arguments );
      let result = routineUnite.body.call( this, o );
      return result;
    }
  _.routineUnite.head = _routineUnite_head;
  _.routineUnite.body = _routineUnite_body;
  _.routineUnite.defaults = Object.create( _routineUnite_body.defaults );
  _.routineUnite.defaults =
  { "pre" : null, "body" : null, "name" : null };
  var routineUnite = _.routineUnite;

//

  _.arrayAs = function arrayAs( src )
  {
    _.assert( arguments.length === 1 );
    _.assert( src !== undefined );
  
    if( src === null )
    return [];
    else if( _.longLike( src ) )
    return src;
    else
    return [ src ];
  
  };
  var arrayAs = _.arrayAs;

//

  _.errIs = function errIs( src )
  {
    return src instanceof Error || Object.prototype.toString.call( src ) === '[object Error]';
  };
  var errIs = _.errIs;

//

  _.unrollIs = function unrollIs( src )
  {
    if( !_.arrayIs( src ) )
    return false;
    return !!src[ _.unroll ];
  };
  var unrollIs = _.unrollIs;

//

  _.strType = function strType( src )
  {
  
    _.assert( arguments.length === 1, 'Expects single argument' );
  
    if( !_.primitiveIs( src ) )
    if( src.constructor && src.constructor.name )
    return src.constructor.name;
  
    let result = _.strPrimitiveType( src );
  
    if( result === 'Object' )
    {
      if( Object.getPrototypeOf( src ) === null )
      result = 'Map';
      else if( src.__proto__ !== Object.__proto__ )
      result = 'Object:>Sub';
    }
  
    return result;
  };
  var strType = _.strType;

//

  _.strPrimitiveType = function strPrimitiveType( src )
  {
  
    let name = Object.prototype.toString.call( src );
    let result = /\[(\w+) (\w+)\]/.exec( name );
  
    if( !result )
    throw _.err( 'strType :', 'unknown type', name );
    return result[ 2 ];
  };
  var strPrimitiveType = _.strPrimitiveType;

//

  _.strHas = function strHas( src, ins )
  {
    _.assert( arguments.length === 2, 'Expects exactly two arguments' );
    _.assert( _.strIs( src ), () => `Expects string, got ${_.strType( src )}` );
    _.assert( _.strLike( ins ), () => `Expects string-like, got ${_.strType( ins )}` );
  
    if( _.strIs( ins ) )
    return src.indexOf( ins ) !== -1;
    else
    return ins.test( src );
  
  };
  var strHas = _.strHas;

//

  _.strLike = function strLike( src )
  {
    if( _.strIs( src ) )
    return true;
    if( _.regexpIs( src ) )
    return true;
    return false
  };
  var strLike = _.strLike;

//

  _.rangeIs = function rangeIs( range )
  {
    _.assert( arguments.length === 1 );
    if( !_.numbersAreAll( range ) )
    return false;
    if( range.length !== 2 )
    return false;
    return true;
  };
  var rangeIs = _.rangeIs;

//

  _.numbersAreAll = function numbersAreAll( src )
  {
    _.assert( arguments.length === 1 );
  
    if( _.bufferTypedIs( src ) )
    return true;
  
    if( _.arrayLike( src ) )
    {
      for( let s = 0 ; s < src.length ; s++ )
      if( !_.numberIs( src[ s ] ) )
      return false;
      return true;
    }
  
    return false;
  };
  var numbersAreAll = _.numbersAreAll;

//

  _.bufferTypedIs = function bufferTypedIs( src )
  {
    let type = Object.prototype.toString.call( src );
    if( !/\wArray/.test( type ) )
    return false;
    // Dmytro : two next lines is added to correct returned result when src is SharedArrayBuffer
    if( type === '[object SharedArrayBuffer]' )
    return false;
    if( _.bufferNodeIs( src ) )
    return false;
    return true;
  };
  var bufferTypedIs = _.bufferTypedIs;

//

  _.bufferNodeIs = function bufferNodeIs( src )
  {
    if( typeof BufferNode !== 'undefined' )
    return src instanceof BufferNode;
    return false;
  };
  var bufferNodeIs = _.bufferNodeIs;

//

  _.strLinesStrip = function strLinesStrip( src )
  {
  
    if( arguments.length > 1 )
    {
      let result = _.unrollMake( null );
      for( let a = 0 ; a < arguments.length ; a++ )
      result[ a ] = strLinesStrip( arguments[ a ] );
      return result;
    }
  
    _.assert( _.strIs( src ) || _.arrayIs( src ) );
    _.assert( arguments.length === 1 );
  
    let lines = _.strLinesSplit( src );
    lines = lines.map( ( line ) => line.trim() ).filter( ( line ) => line );
  
    if( _.strIs( src ) )
    lines = _.strLinesJoin( lines );
    return lines;
  };
  var strLinesStrip = _.strLinesStrip;

//

  _.strLinesSplit = function strLinesSplit( src )
  {
    _.assert( _.strIs( src ) || _.arrayIs( src ) );
    _.assert( arguments.length === 1 );
    if( _.arrayIs( src ) )
    return src;
    return src.split( '\n' );
  };
  var strLinesSplit = _.strLinesSplit;

//

  _.strLinesJoin = function strLinesJoin( src )
  {
    _.assert( _.strIs( src ) || _.arrayIs( src ) );
    _.assert( arguments.length === 1 );
    let result = src;
    if( _.arrayIs( src ) )
    result = src.join( '\n' );
    return result;
  };
  var strLinesJoin = _.strLinesJoin;

//

  
    var _strSplitFast_head = function strSplitFast_head( routine, args )
    {
      let o = args[ 0 ];
    
      if( args.length === 2 )
      o = { src : args[ 0 ], delimeter : args[ 1 ] }
      else if( _.strIs( args[ 0 ] ) )
      o = { src : args[ 0 ] }
    
      _.routineOptions( routine, o );
    
      _.assert( arguments.length === 2, 'Expects exactly two arguments' );
      _.assert( args.length === 1 || args.length === 2, 'Expects one or two arguments' );
      _.assert( _.strIs( o.src ) );
      _.assert( _.objectIs( o ) );
    
      return o;
    }
  
    //
  
  
    var _strSplitFast_body = function strSplitFast_body( o )
    {
      let result;
      let closests;
      let position;
      let closestPosition;
      let closestIndex;
      let hasEmptyDelimeter;
      let delimeter
    
      o.delimeter = _.arrayAs( o.delimeter );
    
      let foundDelimeters = o.delimeter.slice();
    
      _.assert( arguments.length === 1 );
      _.assert( _.arrayIs( o.delimeter ) );
      _.assert( _.boolLike( o.preservingDelimeters ) );
    
      /* */
    
      if( !o.preservingDelimeters && o.delimeter.length === 1 )
      {
    
        result = o.src.split( o.delimeter[ 0 ] );
    
        if( !o.preservingEmpty )
        result = result.filter( ( e ) => e ? e : false );
    
      }
      else
      {
    
        if( !o.delimeter.length )
        {
          result = [ o.src ];
          return result;
        }
    
        result = [];
        closests = [];
        position = 0;
        closestPosition = 0;
        closestIndex = -1;
        hasEmptyDelimeter = false;
    
        for( let d = 0 ; d < o.delimeter.length ; d++ )
        {
          let delimeter = o.delimeter[ d ];
          if( _.regexpIs( delimeter ) )
          {
            _.assert( !delimeter.sticky );
            if( delimeter.source === '' || delimeter.source === '()' || delimeter.source === '(?:)' )
            hasEmptyDelimeter = true;
            // debugger;
          }
          else
          {
            if( delimeter.length === 0 )
            hasEmptyDelimeter = true;
          }
          closests[ d ] = delimeterNext( d, position );
        }
    
        // let delimeter;
    
        do
        {
          closestWhich();
    
          if( closestPosition === o.src.length )
          break;
    
          if( !delimeter.length )
          position += 1;
    
          ordinaryAdd( o.src.substring( position, closestPosition ) );
    
          if( delimeter.length > 0 || position < o.src.length )
          delimeterAdd( delimeter );
    
          position = closests[ closestIndex ] + ( delimeter.length ? delimeter.length : 1 );
    
          // debugger;
          for( let d = 0 ; d < o.delimeter.length ; d++ )
          if( closests[ d ] < position )
          closests[ d ] = delimeterNext( d, position );
          // debugger;
    
        }
        while( position < o.src.length );
    
        if( delimeter || !hasEmptyDelimeter )
        ordinaryAdd( o.src.substring( position, o.src.length ) );
    
      }
    
      return result;
    
      /* */
    
      function delimeterAdd( delimeter )
      {
    
        if( o.preservingDelimeters )
        if( o.preservingEmpty || delimeter )
        {
          result.push( delimeter );
          // if( _.regexpIs( delimeter ) )
          // result.push( delimeter );
          // o.src.substring( position, closestPosition )
          // else
          // result.push( delimeter );
        }
    
      }
    
      /*  */
    
      function ordinaryAdd( ordinary )
      {
        if( o.preservingEmpty || ordinary )
        result.push( ordinary );
      }
    
      /* */
    
      function closestWhich()
      {
    
        closestPosition = o.src.length;
        closestIndex = -1;
        for( let d = 0 ; d < o.delimeter.length ; d++ )
        {
          if( closests[ d ] < o.src.length && closests[ d ] < closestPosition )
          {
            closestPosition = closests[ d ];
            closestIndex = d;
          }
        }
    
        delimeter = foundDelimeters[ closestIndex ];
    
      }
    
      /* */
    
      function delimeterNext( d, position )
      {
        _.assert( position <= o.src.length );
        let delimeter = o.delimeter[ d ];
        let result;
    
        if( _.strIs( delimeter ) )
        {
          result = o.src.indexOf( delimeter, position );
        }
        else
        {
          let execed = delimeter.exec( o.src.substring( position ) );
          if( execed )
          {
            result = execed.index + position;
            foundDelimeters[ d ] = execed[ 0 ];
          }
        }
    
        if( result === -1 )
        return o.src.length;
        return result;
      }
    
    }
  
    //
  
  _strSplitFast_body.defaults = {
      "src" : null, 
      "delimeter" : ` `, 
      "preservingEmpty" : 1, 
      "preservingDelimeters" : 1
    }
    ;
  _.strSplitFast = _.routineUnite( _strSplitFast_head, _strSplitFast_body );
  _.strSplitFast.defaults =
  {
    "src" : null, 
    "delimeter" : ` `, 
    "preservingEmpty" : 1, 
    "preservingDelimeters" : 1
  };
  var strSplitFast = _.strSplitFast;

//

  _._strLeftSingle = function _strLeftSingle( src, ins, range )
  {
  
    _.assert( arguments.length === 2 || arguments.length === 3 );
    _.assert( _.strIs( src ) );
  
    if( _.numberIs( range ) )
    range = [ range, src.length ];
    else if( range === undefined )
    range = [ 0, src.length ];
  
    range[ 0 ] = range[ 0 ] === undefined ? 0 : range[ 0 ];
    range[ 1 ] = range[ 1 ] === undefined ? src.length : range[ 1 ];
    if( range[ 0 ] < 0 )
    range[ 0 ] = src.length + range[ 0 ];
    if( range[ 1 ] < 0 )
    range[ 1 ] = src.length + range[ 1 ];
  
    _.assert( _.rangeIs( range ) );
    _.assert( 0 <= range[ 0 ] && range[ 0 ] <= src.length );
    _.assert( 0 <= range[ 1 ] && range[ 1 ] <= src.length );
  
    let result = Object.create( null );
    result.index = src.length;
    result.instanceIndex = -1;
    result.entry = undefined;
  
    ins = _.arrayAs( ins );
    let src1 = src.substring( range[ 0 ], range[ 1 ] );
  
    for( let k = 0 ; k < ins.length ; k++ )
    {
      let entry = ins[ k ];
      if( _.strIs( entry ) )
      {
        let found = src1.indexOf( entry );
        if( found >= 0 && ( found < result.index || result.entry === undefined ) )
        {
          result.instanceIndex = k;
          result.index = found;
          result.entry = entry;
        }
      }
      else if( _.regexpIs( entry ) )
      {
        let found = src1.match( entry );
        if( found && ( found.index < result.index || result.entry === undefined ) )
        {
          result.instanceIndex = k;
          result.index = found.index;
          result.entry = found[ 0 ];
        }
      }
      else _.assert( 0, 'Expects string-like ( string or regexp )' );
    }
  
    if( range[ 0 ] !== 0 && result.index !== src.length )
    result.index += range[ 0 ];
  
    return result;
  };
  var _strLeftSingle = _._strLeftSingle;

//

  _._strRightSingle = function _strRightSingle( src, ins, range )
  {
  
    _.assert( arguments.length === 2 || arguments.length === 3 );
    _.assert( _.strIs( src ) );
  
    if( _.numberIs( range ) )
    range = [ range, src.length ];
    else if( range === undefined )
    range = [ 0, src.length ];
  
    range[ 0 ] = range[ 0 ] === undefined ? 0 : range[ 0 ];
    range[ 1 ] = range[ 1 ] === undefined ? src.length : range[ 1 ];
    if( range[ 0 ] < 0 )
    range[ 0 ] = src.length + range[ 0 ];
    if( range[ 1 ] < 0 )
    range[ 1 ] = src.length + range[ 1 ];
  
    _.assert( _.rangeIs( range ) );
    _.assert( 0 <= range[ 0 ] && range[ 0 ] <= src.length );
    _.assert( 0 <= range[ 1 ] && range[ 1 ] <= src.length );
  
    let olength = src.length;
    let result = Object.create( null );
    result.index = -1;
    result.instanceIndex = -1;
    result.entry = undefined;
    ins = _.arrayAs( ins );
    let src1 = src.substring( range[ 0 ], range[ 1 ] );
  
    for( let k = 0, len = ins.length ; k < len ; k++ )
    {
      let entry = ins[ k ];
      if( _.strIs( entry ) )
      {
        let found = src1.lastIndexOf( entry );
        if( found >= 0 && found > result.index )
        {
          result.instanceIndex = k;
          result.index = found;
          result.entry = entry;
        }
      }
      else if( _.regexpIs( entry ) )
      {
  
        let regexp1 = _.regexpsJoin([ '.*', '(', entry, ')' ]);
        let match1 = src1.match( regexp1 );
        if( !match1 )
        continue;
  
        let regexp2 = _.regexpsJoin([ entry, '(?!(?=.).*', entry, ')' ]);
        let match2 = src1.match( regexp2 );
        _.assert( !!match2 );
  
        let found;
        let found1 = match1[ 1 ];
        let found2 = match2[ 0 ];
        let index;
        let index1 = match1.index + match1[ 0 ].length;
        let index2 = match2.index + match2[ 0 ].length;
  
        if( index1 === index2 )
        {
          if( found1.length < found2.length )
          {
            found = found2;
            index = index2 - found.length;
          }
          else
          {
            found = found1;
            index = index1 - found.length;
          }
        }
        else if( index1 < index2 )
        {
          found = found2;
          index = index2 - found.length;
        }
        else
        {
          found = found1;
          index = index1 - found.length;
        }
  
        if( index > result.index )
        {
          result.instanceIndex = k;
          result.index = index;
          result.entry = found;
        }
  
      }
      else _.assert( 0, 'Expects string-like ( string or regexp )' );
    }
  
    if( range[ 0 ] !== 0 && result.index !== -1 )
    result.index += range[ 0 ];
  
    return result;
  };
  var _strRightSingle = _._strRightSingle;

//

  
    var _strIsolate_head = function strIsolate_head( routine, args )
    {
      let o;
    
      if( args.length > 1 )
      {
        o = { src : args[ 0 ], delimeter : args[ 1 ], times : args[ 2 ] };
      }
      else
      {
        o = args[ 0 ];
        _.assert( args.length === 1, 'Expects single argument' );
      }
    
      _.routineOptions( routine, o );
      _.assert( args.length === 1 || args.length === 2 || args.length === 3 );
      _.assert( arguments.length === 2, 'Expects exactly two arguments' );
      _.assert( _.strIs( o.src ) );
      _.assert( _.strsLikeAll( o.delimeter ) )
      _.assert( _.numberIs( o.times ) );
    
      return o;
    }
  
    //
  
  
    var _strIsolate_body = function strIsolate_body( o )
    {
      let result = [];
      let times = o.times;
      let delimeter
      let index = o.left ? 0 : o.src.length;
      let more = o.left ? strLeft : strRight;
      let delta = ( o.left ? +1 : -1 );
    
      _.assertRoutineOptions( strIsolate_body, arguments );
    
      /* */
    
      if( _.arrayIs( o.delimeter ) && o.delimeter.length === 1 )
      o.delimeter = o.delimeter[ 0 ];
    
      let quote;
      if( o.quote )
      quote = _.strQuoteAnalyze({ src : o.src, quote : o.quote });
    
      /* */
    
      while( times > 0 )
      {
        let found = more( index );
    
        if( found.entry === undefined )
        break;
    
        times -= 1;
    
        if( o.left )
        index = found.index + delta;
        else
        index = found.index + found.entry.length + delta;
    
        if( times === 0 )
        {
          result.push( o.src.substring( 0, found.index ) );
          result.push( found.entry );
          result.push( o.src.substring( found.index + found.entry.length ) );
          return result;
        }
    
        /* */
    
        if( o.left )
        {
          if( index >= o.src.length )
          break;
        }
        else
        {
          if( index <= 0 )
          break;
        }
    
      }
    
      /* */
    
      if( !result.length )
      {
    
        if( o.times === 0 )
        return everything( !o.left );
        else if( times === o.times )
        return everything( o.left ^ o.none );
        else
        return everything( o.left );
    
      }
    
      return result;
    
      /* */
    
      function everything( side )
      {
        return ( side ) ? [ o.src, undefined, '' ] : [ '', undefined, o.src ];
      }
    
      /* */
    
      function strLeft( index )
      {
        let r = _._strLeftSingle( o.src, o.delimeter, [ index, undefined ] );
        if( quote )
        if( r.entry !== undefined )
        {
          let range = inQuoteRange( r.index );
          if( range )
          return strLeft( range[ 1 ]+1 );
        }
        return r;
      }
    
      /* */
    
      function strRight( index )
      {
        let r = _._strRightSingle( o.src, o.delimeter, [ undefined, index ] );
        if( quote )
        if( r.entry !== undefined )
        {
          let range = inQuoteRange( r.index );
          if( range )
          return strRight( range[ 0 ] );
        }
        return r;
      }
    
      /* */
    
      function inQuoteRange( offset )
      {
        let i = _.sorted.searchFirstIndex( quote.ranges, offset );
        if( i % 2 )
        {
          i -= 1;
        }
        if( i < 0 || i >= quote.ranges.length )
        return false;
        let b = quote.ranges[ i ];
        let e = quote.ranges[ i+1 ];
        if( !( b <= offset && offset <= e ) )
        return false;
        return [ b, e ];
      }
    
      /* */
    
      // function binSearch( val )
      // {
      //   let l = 0;
      //   let r = quote.ranges.length;
      //   let m;
      //   if( quote.ranges.length )
      //   debugger;
      //   do
      //   {
      //     m = Math.floor( ( l + r ) / 2 );
      //     if( quote.ranges[ m ] < val )
      //     l = m+1;
      //     else if( quote.ranges[ m ] > val )
      //     r = m;
      //     else
      //     return m;
      //   }
      //   while( l < r );
      //   if( quote.ranges[ m ] < val )
      //   return m+1;
      //   return m;
      // }
    
      /* */
    
      // let quotedRanges = [];
      //
      // function quoteRangesSetup( index )
      // {
      //   let quotes = [];
      //   for( let i = 0 ; i < o.src.length ; i++ )
      //   {
      //     if( _.arrayHas( o.quote,  ) )
      //   }
      // }
      //
      // function quoteRange( index )
      // {
      //   for( let i = 0 ; i < x ; i++ )
      //
      // }
    
    }
  
    //
  
  _strIsolate_body.defaults = {
      "src" : null, 
      "delimeter" : ` `, 
      "quote" : 0, 
      "left" : 1, 
      "times" : 1, 
      "none" : 1
    }
    ;
  _.strIsolate = _.routineUnite( _strIsolate_head, _strIsolate_body );
  _.strIsolate.defaults =
  {
    "src" : null, 
    "delimeter" : ` `, 
    "quote" : 0, 
    "left" : 1, 
    "times" : 1, 
    "none" : 1
  };
  var strIsolate = _.strIsolate;

//

  
    var _strIsolateLeftOrNone_head = function strIsolate_head( routine, args )
    {
      let o;
    
      if( args.length > 1 )
      {
        o = { src : args[ 0 ], delimeter : args[ 1 ], times : args[ 2 ] };
      }
      else
      {
        o = args[ 0 ];
        _.assert( args.length === 1, 'Expects single argument' );
      }
    
      _.routineOptions( routine, o );
      _.assert( args.length === 1 || args.length === 2 || args.length === 3 );
      _.assert( arguments.length === 2, 'Expects exactly two arguments' );
      _.assert( _.strIs( o.src ) );
      _.assert( _.strsLikeAll( o.delimeter ) )
      _.assert( _.numberIs( o.times ) );
    
      return o;
    }
  
    //
  
  
    var _strIsolateLeftOrNone_body = function strIsolateLeftOrNone_body( o )
    {
      o.left = 1;
      o.none = 1;
      let result = _.strIsolate.body( o );
      return result;
    }
  
    //
  
  _strIsolateLeftOrNone_body.defaults = {
      "src" : null, 
      "delimeter" : ` `, 
      "times" : 1, 
      "quote" : null
    }
    ;
  _.strIsolateLeftOrNone = _.routineUnite( _strIsolateLeftOrNone_head, _strIsolateLeftOrNone_body );
  _.strIsolateLeftOrNone.defaults =
  {
    "src" : null, 
    "delimeter" : ` `, 
    "times" : 1, 
    "quote" : null
  };
  var strIsolateLeftOrNone = _.strIsolateLeftOrNone;

//

  
    var _strIsolateRightOrNone_head = function strIsolate_head( routine, args )
    {
      let o;
    
      if( args.length > 1 )
      {
        o = { src : args[ 0 ], delimeter : args[ 1 ], times : args[ 2 ] };
      }
      else
      {
        o = args[ 0 ];
        _.assert( args.length === 1, 'Expects single argument' );
      }
    
      _.routineOptions( routine, o );
      _.assert( args.length === 1 || args.length === 2 || args.length === 3 );
      _.assert( arguments.length === 2, 'Expects exactly two arguments' );
      _.assert( _.strIs( o.src ) );
      _.assert( _.strsLikeAll( o.delimeter ) )
      _.assert( _.numberIs( o.times ) );
    
      return o;
    }
  
    //
  
  
    var _strIsolateRightOrNone_body = function strIsolateRightOrNone_body( o )
    {
      o.left = 0;
      o.none = 1;
      let result = _.strIsolate.body( o );
      return result;
    }
  
    //
  
  _strIsolateRightOrNone_body.defaults = {
      "src" : null, 
      "delimeter" : ` `, 
      "times" : 1, 
      "quote" : null
    }
    ;
  _.strIsolateRightOrNone = _.routineUnite( _strIsolateRightOrNone_head, _strIsolateRightOrNone_body );
  _.strIsolateRightOrNone.defaults =
  {
    "src" : null, 
    "delimeter" : ` `, 
    "times" : 1, 
    "quote" : null
  };
  var strIsolateRightOrNone = _.strIsolateRightOrNone;

//

  
    var _strIsolateLeftOrAll_head = function strIsolate_head( routine, args )
    {
      let o;
    
      if( args.length > 1 )
      {
        o = { src : args[ 0 ], delimeter : args[ 1 ], times : args[ 2 ] };
      }
      else
      {
        o = args[ 0 ];
        _.assert( args.length === 1, 'Expects single argument' );
      }
    
      _.routineOptions( routine, o );
      _.assert( args.length === 1 || args.length === 2 || args.length === 3 );
      _.assert( arguments.length === 2, 'Expects exactly two arguments' );
      _.assert( _.strIs( o.src ) );
      _.assert( _.strsLikeAll( o.delimeter ) )
      _.assert( _.numberIs( o.times ) );
    
      return o;
    }
  
    //
  
  
    var _strIsolateLeftOrAll_body = function strIsolateLeftOrAll_body( o )
    {
      o.left = 1;
      o.none = 0;
      let result = _.strIsolate.body( o );
      return result;
    }
  
    //
  
  _strIsolateLeftOrAll_body.defaults = {
      "src" : null, 
      "delimeter" : ` `, 
      "times" : 1, 
      "quote" : null
    }
    ;
  _.strIsolateLeftOrAll = _.routineUnite( _strIsolateLeftOrAll_head, _strIsolateLeftOrAll_body );
  _.strIsolateLeftOrAll.defaults =
  {
    "src" : null, 
    "delimeter" : ` `, 
    "times" : 1, 
    "quote" : null
  };
  var strIsolateLeftOrAll = _.strIsolateLeftOrAll;

//

  
    var _strIsolateRightOrAll_head = function strIsolate_head( routine, args )
    {
      let o;
    
      if( args.length > 1 )
      {
        o = { src : args[ 0 ], delimeter : args[ 1 ], times : args[ 2 ] };
      }
      else
      {
        o = args[ 0 ];
        _.assert( args.length === 1, 'Expects single argument' );
      }
    
      _.routineOptions( routine, o );
      _.assert( args.length === 1 || args.length === 2 || args.length === 3 );
      _.assert( arguments.length === 2, 'Expects exactly two arguments' );
      _.assert( _.strIs( o.src ) );
      _.assert( _.strsLikeAll( o.delimeter ) )
      _.assert( _.numberIs( o.times ) );
    
      return o;
    }
  
    //
  
  
    var _strIsolateRightOrAll_body = function strIsolateRightOrAll_body( o )
    {
      o.left = 0;
      o.none = 0;
      let result = _.strIsolate.body( o );
      return result;
    }
  
    //
  
  _strIsolateRightOrAll_body.defaults = {
      "src" : null, 
      "delimeter" : ` `, 
      "times" : 1, 
      "quote" : null
    }
    ;
  _.strIsolateRightOrAll = _.routineUnite( _strIsolateRightOrAll_head, _strIsolateRightOrAll_body );
  _.strIsolateRightOrAll.defaults =
  {
    "src" : null, 
    "delimeter" : ` `, 
    "times" : 1, 
    "quote" : null
  };
  var strIsolateRightOrAll = _.strIsolateRightOrAll;

//

  _.strLinesIndentation = function strLinesIndentation( src, tab )
  {
  
    _.assert( arguments.length === 2, 'Expects two arguments' );
    _.assert( _.strIs( src ) || _.arrayIs( src ), 'Expects src as string or array' );
    _.assert( _.strIs( tab ) || _.numberIs( tab ), 'Expects tab as string or number' ); /* aaa2 : cover please */ /*Dmytro : covered */
  
    if( _.numberIs( tab ) )
    tab = _.strDup( ' ', tab );
  
    if( _.strIs( src ) )
    {
  
      if( src.indexOf( '\n' ) === -1 )
      return src;
  
      // if( src.indexOf( '\n' ) === -1 )
      // return tab + src;
  
      src = src.split( '\n' );
  
    }
  
  /*
    should be no tab in prolog
  */
  
    let result = src.join( '\n' + tab );
    // let result = tab + src.join( '\n' + tab );
  
    return result;
  };
  var strLinesIndentation = _.strLinesIndentation;

//

  _.numberFromStrMaybe = function numberFromStrMaybe( src )
  {
    _.assert( arguments.length === 1, 'Expects single argument' );
    _.assert( _.strIs( src ) || _.numberIs( src ) );
    if( _.numberIs( src ) )
    return src;
    let parsed = Number( src );
    if( !isNaN( parsed ) )
    return parsed;
    return src;
  };
  var numberFromStrMaybe = _.numberFromStrMaybe;

//


  _.setup._setupUncaughtErrorHandler2 = function _setupUncaughtErrorHandler2()
  {
  
    if( _global._setupUncaughtErrorHandlerDone )
    return;
  
    _global._setupUncaughtErrorHandlerDone = 1;
  
    _.setup._errUncaughtHandler1 = _errUncaughtHandler1;
    if( _global.process && typeof _global.process.on === 'function' )
    {
      _global.process.on( 'uncaughtException', _.setup._errUncaughtHandler1 );
      _.setup._errUncaughtPre = _errPreNode;
    }
    else if( Object.hasOwnProperty.call( _global, 'onerror' ) )
    {
      _.setup._errUncaughtHandler0 = _global.onerror;
      _global.onerror = _.setup._errUncaughtHandler1;
      _.setup._errUncaughtPre = _errPreBrowser;
    }
  
    /* */
  
    function _errPreBrowser( args )
    {
      return [ new Error( args[ 0 ] ) ];
    }
  
    /* */
  
    function _errPreNode( args )
    {
      return args;
    }
  
    /* */
  
  };
  var _setupUncaughtErrorHandler2 = _.setup._setupUncaughtErrorHandler2;

//

  _.setup._setupUncaughtErrorHandler9 = function _setupUncaughtErrorHandler9()
  {
  
    if( !_global._setupUncaughtErrorHandlerDone )
    {
      debugger;
      throw Error( 'setup0 should be called first' );
    }
  
    if( _global._setupUncaughtErrorHandlerDone > 1 )
    return;
  
    _global._setupUncaughtErrorHandlerDone = 2;
  
    /* */
  
    if( _global.process && _.routineIs( _global.process.on ) )
    {
      _.setup._errUncaughtPre = _errPreNode;
    }
    else if( Object.hasOwnProperty.call( _global, 'onerror' ) )
    {
      _.setup._errUncaughtPre = _errPreBrowser;
    }
  
    /* */
  
    function _errPreBrowser( args )
    {
      let [ message, sourcePath, lineno, colno, error ] = args;
      let err = error || message;
  
      if( _._err )
      err = _._err
      ({
        args : [ error || message ],
        level : 1,
        fallBackStack : 'at handleError @ ' + sourcePath + ':' + lineno,
        throwLocation :
        {
          filePath : sourcePath,
          line : lineno,
          col : colno,
        },
      });
  
      return [ err ];
    }
  
    /* */
  
    function _errPreNode( args )
    {
      return [ args[ 0 ] ];
    }
  
    /* */
  
  };
  var _setupUncaughtErrorHandler9 = _.setup._setupUncaughtErrorHandler9;

//

  _.setup._errUncaughtPre = function _errPreNode( args )
    {
      return [ args[ 0 ] ];
    };
  var _errUncaughtPre = _.setup._errUncaughtPre;

//

  _.setup._errUncaughtHandler1 = function _errUncaughtHandler1()
  {
  
    let args = _.setup._errUncaughtPre( arguments );
    let result = _.setup._errUncaughtHandler2.apply( this, args );
  
    if( _.setup._errUncaughtHandler0 )
    _.setup._errUncaughtHandler0.apply( this, arguments );
  
    return result;
  };
  var _errUncaughtHandler1 = _.setup._errUncaughtHandler1;

//

  _.setup._errUncaughtHandler2 = function _errUncaughtHandler2( err, kind )
  {
    if( !kind )
    kind = 'uncaught error';
    let prefix = `--------------- ${kind} --------------->\n`;
    let postfix = `--------------- ${kind} ---------------<\n`;
    let logger = _global.logger || _global.console;
  
    /* xxx qqq : resolve issue in browser
      if file has syntax error then unachught error should not ( probably ) be throwen
      because browser thows uncontrolled information about syntax error after that
      avoid duplication of errors in log
    */
  
    if( _.errIsAttended( err ) )
    return;
  
    // debugger;
  
    /* */
  
    consoleUnbar();
    attend( err );
  
    console.error( prefix );
  
    errLogFields();
    errLog();
  
    console.error( postfix );
  
    processExit();
  
    /* */
  
    function consoleUnbar()
    {
      try
      {
        if( _.Logger && _.Logger.ConsoleBar && _.Logger.ConsoleIsBarred( console ) )
        _.Logger.ConsoleBar({ on : 0 });
      }
      catch( err2 )
      {
        debugger;
        console.error( err2 );
      }
    }
  
    /* */
  
    function errLog()
    {
      try
      {
        err = _.errProcess( err );
        if( _.errLog )
        _.errLog( err );
        else
        console.error( err );
      }
      catch( err2 )
      {
        debugger;
        console.error( err2 );
        console.error( err );
      }
    }
  
    /* */
  
    function errLogFields()
    {
      if( !err.originalMessage && _.objectLike && _.objectLike( err ) )
      try
      {
        let serr = _.toStr && _.field ? _.toStr.fields( err, { errorAsMap : 1 } ) : err;
        console.error( serr );
      }
      catch( err2 )
      {
        debugger;
        console.error( err2 );
      }
    }
  
    /* */
  
    function attend( err )
    {
      try
      {
        _.errProcess( err );
        if( _.errIsAttended( err ) )
        return
      }
      catch( err2 )
      {
        debugger;
        console.error( err2 );
      }
    }
  
    /* */
  
    function processExit()
    {
      if( _.process && _.process.exit )
      try
      {
        _.process.exitCode( -1 );
        _.process.exitReason( err );
        _.process.exit();
      }
      catch( err2 )
      {
        debugger;
        console.log( err2 );
      }
      else
      try
      {
        if( _global.process )
        {
          if( !process.exitCode )
          process.exitCode = -1;
        }
      }
      catch( err )
      {
      }
    }
  
  };
  var _errUncaughtHandler2 = _.setup._errUncaughtHandler2;

//


  /*
  Uri namespace( parseConsecutive ) is required to make _.include working in a browser
  */

  // parseFull maybe?

  
    var _parse_head = function parse_head( routine, args )
    {
      _.assert( args.length === 1, 'Expects single argument' );
    
      let o = { srcPath : args[ 0 ] };
    
      _.routineOptions( routine, o );
      _.assert( _.strIs( o.srcPath ) || _.mapIs( o.srcPath ) );
      _.assert( _.longHas( routine.Kind, o.kind ), () => 'Unknown kind of parsing ' + o.kind );
    
      return o;
    }
  
    //
  
  
    var _parse_body = function parse_body( o )
    {
      let result = Object.create( null );
    
      if( _.mapIs( o.srcPath ) )
      {
        _.assertMapHasOnly( o.srcPath, this.UriComponents );
    
        if( o.srcPath.protocols )
        return o.srcPath;
        else if( o.srcPath.full )
        o.srcPath = o.srcPath.full;
        else
        o.srcPath = this.str( o.srcPath );
      }
    
      let e = this._uriParseRegexp.exec( o.srcPath );
      _.sure( !!e, 'Cant parse :',o.srcPath );
    
      let params = '';
    
      if( _.strIs( e[ 1 ] ) )
      result.protocol = e[ 1 ];
      if( _.strIs( e[ 3 ] ) )
      result.host = e[ 3 ];
      if( _.strIs( e[ 4 ] ) )
      result.port = _.numberFromStrMaybe( e[ 4 ] );
      // result.port = e[ 4 ];
      if( _.strIs( e[ 5 ] ) )
      {
        result.resourcePath = e[ 5 ];
        let isolatedSlash = _.strIsolateRightOrNone( result.resourcePath, '/' );
        if( isolatedSlash[ 2 ] )
        {
          let isolated = _.strIsolateRightOrNone( isolatedSlash[ 2 ], '@' );
          if( isolated[ 2 ] )
          {
            result.tag = isolated[ 2 ];
            result.resourcePath = isolatedSlash[ 0 ] + isolatedSlash[ 1 ] + isolated[ 0 ]
            params += '@' + result.tag;
          }
        }
      }
      if( _.strIs( e[ 6 ] ) )
      {
        result.query = e[ 6 ];
        params += '?' + result.query;
        let isolated = _.strIsolateRightOrNone( result.query, '@' );
        if( isolated[ 2 ] )
        {
          result.tag = isolated[ 2 ];
          result.query = isolated[ 0 ]
        }
      }
      if( _.strIs( e[ 7 ] ) )
      {
        result.hash = e[ 7 ];
        params += '#' + result.hash;
        let isolated = _.strIsolateRightOrNone( result.hash, '@' );
        if( isolated[ 2 ] )
        {
          result.tag = isolated[ 2 ];
          result.hash = isolated[ 0 ]
        }
      }
    
      /* */
    
      if( o.kind === 'full' )
      {
        let hostWithPort = e[ 2 ] || '';
        result.longPath = hostWithPort + result.resourcePath;
        result.longPathWithParams = result.longPath + params;
        if( result.protocol )
        result.protocols = result.protocol.split( '+' );
        else
        result.protocols = [];
        if( _.strIs( e[ 2 ] ) )
        result.hostWithPort = e[ 2 ];
        if( _.strIs( result.protocol ) || _.strIs( result.hostWithPort ) )
        result.origin = ( _.strIs( result.protocol ) ? result.protocol + '://' : '//' ) + result.hostWithPort;
        result.full = o.srcPath;
      }
      else if( o.kind === 'consecutive' )
      {
        let hostWithPort = e[ 2 ] || '';
        result.longPath = hostWithPort + result.resourcePath;
        result.longPathWithParams = result.longPath + params; /* xxx : redundat! */
        delete result.host;
        delete result.port;
        delete result.resourcePath;
      }
    
      return result;
    
      /*  */
    
      function longPathWithParamsForm()
      {
        let longPathWithParams = result.longPath;
        if( result.query )
        longPathWithParams += '?' + result.query;
        if( result.hash )
        longPathWithParams += '#' + result.hash;
        if( result.tag )
        longPathWithParams += '@' + result.tag;
        return longPathWithParams;
      }
    
      function isolateTagFrom( src )
      {
        let result = _.strIsolateRightOrNone( src, '@' );
        if( result[ 2 ] )
        result.tag = result[ 2 ];
        return result[ 0 ];
      }
    }
  
    //
  
  _parse_body.defaults = { "srcPath" : null, "kind" : `full` }
    _parse_body.components = {
      "protocol" : null, 
      "host" : null, 
      "port" : null, 
      "resourcePath" : null, 
      "query" : null, 
      "hash" : null, 
      "tag" : null, 
      "longPath" : null, 
      "longPathWithParams" : null, 
      "protocols" : null, 
      "hostWithPort" : null, 
      "origin" : null, 
      "full" : null
    }
    _parse_body.Kind = [ `full`, `atomic`, `consecutive` ]
    ;
  _.uri.parseConsecutive = _.routineUnite( _parse_head, _parse_body );
  _.uri.parseConsecutive.defaults =
  { "kind" : `consecutive`, "srcPath" : null };
  var parseConsecutive = _.uri.parseConsecutive;

//

  _.uri.refine = function refine( filePath )
  {
    let parent = this.path;
  
    _.assert( arguments.length === 1, 'Expects single argument' );
    _.assert( _.strIs( filePath ) );
  
    if( this.isGlobal( filePath ) )
    filePath = this.parseConsecutive( filePath );
    else
    return parent.refine.call( this, filePath );
  
    if( _.strDefined( filePath.longPath ) )
    filePath.longPath = parent.refine.call( this, filePath.longPath );
  
    if( filePath.hash || filePath.tag )
    filePath.longPath = parent.detrail( filePath.longPath );
  
    return this.str( filePath );
  };
  var refine = _.uri.refine;

//

  _.uri._normalize = function _normalize( o )
  {
    // let debug = 0;
    // if( 0 )
    // debug = 1;
  
    _.assertRoutineOptions( _normalize, arguments );
    _.assert( _.strIs( o.src ), 'Expects string' );
  
    if( !o.src.length )
    return '';
  
    let result = o.src;
  
    result = this.refine( result );
  
    // if( debug )
    // console.log( 'normalize.refined : ' + result );
  
    /* detrailing */
  
    if( o.tolerant )
    {
      /* remove "/" duplicates */
      result = result.replace( this._delUpDupRegexp, this._upStr );
    }
  
    let endsWithUp = false;
    let beginsWithHere = false;
  
    /* remove right "/" */
  
    if( result !== this._upStr && !_.strEnds( result, this._upStr + this._upStr ) && _.strEnds( result, this._upStr ) )
    {
      endsWithUp = true;
      result = _.strRemoveEnd( result, this._upStr );
    }
  
    /* undoting */
  
    while( !_.strBegins( result, this._hereUpStr + this._upStr ) && _.strBegins( result, this._hereUpStr ) )
    {
      beginsWithHere = true;
      result = _.strRemoveBegin( result, this._hereUpStr );
    }
  
    /* remove second "." */
  
    if( result.indexOf( this._hereStr ) !== -1 )
    {
  
      while( this._delHereRegexp.test( result ) )
      result = result.replace( this._delHereRegexp, function( match, postSlash )
      {
        return postSlash || '';
      });
      if( result === '' )
      result = this._upStr;
  
    }
  
    /* remove .. */
  
    if( result.indexOf( this._downStr ) !== -1 )
    {
  
      while( this._delDownRegexp.test( result ) )
      result = result.replace( this._delDownRegexp, ( match, notBegin, split, preSlash, postSlash ) =>
      {
        if( preSlash === '' )
        return notBegin;
        if( !notBegin )
        return notBegin + preSlash;
        else
        return notBegin + ( postSlash || '' );
      });
  
    }
  
    /* nothing left */
  
    if( !result.length )
    result = '.';
  
    /* dot and trail */
  
    if( o.detrailing )
    if( result !== this._upStr && !_.strEnds( result, this._upStr + this._upStr ) )
    result = _.strRemoveEnd( result, this._upStr );
  
    if( !o.detrailing && endsWithUp )
    if( result !== this._rootStr )
    result = result + this._upStr;
  
    if( !o.undoting && beginsWithHere )
    result = this._dot( result );
  
    // if( debug )
    // console.log( 'normalize.result : ' + result );
  
    return result;
  }
  _.uri._normalize.defaults =
  {
    "src" : null, 
    "tolerant" : false, 
    "detrailing" : false, 
    "undoting" : false
  };
  var _normalize = _.uri._normalize;

//

  _.uri.canonize = function canonize( filePath )
  {
    let parent = this.path;
    if( _.strIs( filePath ) )
    {
      if( this.isGlobal( filePath ) )
      filePath = this.parseConsecutive( filePath );
      else
      return parent.canonize.call( this, filePath );
    }
    _.assert( !!filePath );
    filePath.longPath = parent.canonize.call( this, filePath.longPath );
    return this.str( filePath );
  };
  var canonize = _.uri.canonize;

//

  _.uri.canonizeTolerant = function canonizeTolerant( src )
  {
    _.assert( _.strIs( src ),'Expects string' );
  
    let result = this._normalize({ src, tolerant : true, detrailing : true, undoting : true });
  
    _.assert( arguments.length === 1, 'Expects single argument' );
    _.assert( result === this._upStr || _.strEnds( result, this._upStr ) || !_.strEnds( result, this._upStr + this._upStr ) );
    _.assert( result.lastIndexOf( this._upStr + this._hereStr + this._upStr ) === -1 );
    _.assert( !_.strEnds( result, this._upStr + this._hereStr ) );
  
    if( Config.debug )
    {
      _.assert( !this._delUpDupRegexp.test( result ) );
    }
  
    return result;
  };
  var canonizeTolerant = _.uri.canonizeTolerant;

//

  _.uri._uriParseRegexpStr = `(?:([^:/\\?#]*)://(([^:/\\?#]*)(?::([^/\\?#]*))?))?([^?]*\\?[^:=#]*|[^?#]*)(?:\\?([^#]*))?(?:#([^]*))?\$`;

//
  _.uri._uriParseRegexp = /(?:([^:\/\?#]*):\/\/(([^:\/\?#]*)(?::([^\/\?#]*))?))?([^?]*\?[^:=#]*|[^?#]*)(?:\?([^#]*))?(?:#([^]*))?$/;

//
  _.uri._rootRegSource = `\\/`;

//
  _.uri._upRegSource = `\\/`;

//
  _.uri._downRegSource = `\\.\\.`;

//
  _.uri._hereRegSource = `\\.`;

//
  _.uri._downUpRegSource = `\\.\\.\\/`;

//
  _.uri._hereUpRegSource = `\\.\\/`;

//
  _.uri._delDownRegexp = /((?:.|^))(?:(?:\/\/)|(((?:^|\/))(?!\.\.(?:\/|$))(?:(?!\/).)+\/))\.\.((?:\/|$))/;

//
  _.uri._delHereRegexp = /\/\.(\/|$)/;

//
  _.uri._delUpDupRegexp = /\/{2,}/g;

//
  _.uri._rootStr = `/`;

//
  _.uri._upStr = `/`;

//
  _.uri._hereStr = `.`;

//
  _.uri._downStr = `..`;

//
  _.uri._hereUpStr = `./`;

//
  _.uri._downUpStr = `../`;

//
  _.uri.currentAtBegin = `/pro/builder/proto/wtools/atop/starter.test/_asset/depGlobAnyAny`;

//



  

  let StarterExtension =
  {

    debuggerEnabled : _starter_.debug,

  }

  Object.assign( _starter_, StarterExtension );

;

/* */  /* end of extract */ })();


/* */  /* begin of globing */ ( function _proceduring_() {

  

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

;

  

  _.mapExtend = function mapExtend( dstMap, srcMap )
  {
  
    if( dstMap === null )
    dstMap = Object.create( null );
  
    if( arguments.length === 2 && Object.getPrototypeOf( srcMap ) === null )
    return Object.assign( dstMap, srcMap );
  
    _.assert( arguments.length >= 2, 'Expects at least two arguments' );
    _.assert( !_.primitiveIs( dstMap ), 'Expects non primitive as the first argument' );
  
    for( let a = 1 ; a < arguments.length ; a++ )
    {
      let srcMap = arguments[ a ];
  
      _.assert( !_.primitiveIs( srcMap ), 'Expects non primitive' );
  
      if( Object.getPrototypeOf( srcMap ) === null )
      Object.assign( dstMap, srcMap );
      else
      for( let k in srcMap )
      {
        dstMap[ k ] = srcMap[ k ];
      }
  
    }
  
    return dstMap;
  };
  var mapExtend = _.mapExtend;

//

  _.mapSupplement = function mapSupplement( dstMap, srcMap )
  {
    if( dstMap === null && arguments.length === 2 )
    return Object.assign( Object.create( null ), srcMap );
  
    if( dstMap === null )
    dstMap = Object.create( null );
  
    _.assert( !_.primitiveIs( dstMap ) );
  
    for( let a = 1 ; a < arguments.length ; a++ )
    {
      srcMap = arguments[ a ];
      for( let s in srcMap )
      {
        if( s in dstMap )
        continue;
        dstMap[ s ] = srcMap[ s ];
      }
    }
  
    return dstMap
  };
  var mapSupplement = _.mapSupplement;

//

  
    var _vectorize_head = function vectorize_head( routine, args )
    {
      let o = args[ 0 ];
    
      if( args.length === 2 )
      o = { routine : args[ 0 ], select : args[ 1 ] }
      else if( _.routineIs( o ) || _.strIs( o ) )
      o = { routine : args[ 0 ] }
    
      _.routineOptions( routine, o );
      _.assert( arguments.length === 2, 'Expects exactly two arguments' );
      _.assert( _.routineIs( o.routine ) || _.strIs( o.routine ) || _.strsAreAll( o.routine ), () => 'Expects routine {-o.routine-}, but got ' + o.routine );
      _.assert( args.length === 1 || args.length === 2 );
      _.assert( o.select >= 1 || _.strIs( o.select ) || _.arrayLike( o.select ), () => 'Expects {-o.select-} as number >= 1, string or array, but got ' + o.select );
    
      return o;
    }
  
    //
  
  
    var _vectorize_body = function vectorize_body( o )
    {
    
      _.assertRoutineOptions( vectorize_body, arguments );
    
      if( _.arrayLike( o.routine ) && o.routine.length === 1 )
      o.routine = o.routine[ 0 ];
    
      let routine = o.routine;
      let fieldFilter = o.fieldFilter;
      let bypassingFilteredOut = o.bypassingFilteredOut;
      let bypassingEmpty = o.bypassingEmpty;
      let vectorizingArray = o.vectorizingArray;
      let vectorizingMapVals = o.vectorizingMapVals;
      let vectorizingMapKeys = o.vectorizingMapKeys;
      let vectorizingContainerAdapter = o.vectorizingContainerAdapter;
      let unwrapingContainerAdapter = o.unwrapingContainerAdapter;
      let pre = null;
      let select = o.select === null ? 1 : o.select;
      let selectAll = o.select === Infinity;
      let multiply = select > 1 ? multiplyReally : multiplyNo;
    
      routine = routineNormalize( routine );
    
      _.assert( _.routineIs( routine ), () => 'Expects routine {-o.routine-}, but got ' + routine );
    
      /* */
    
      let resultRoutine = vectorizeArray;
    
      if( _.numberIs( select ) )
      {
    
        if( !vectorizingArray && !vectorizingMapVals && !vectorizingMapKeys )
        resultRoutine = routine;
        else if( fieldFilter )
        resultRoutine = vectorizeWithFilters;
        else if( vectorizingMapKeys )
        {
          // _.assert( !vectorizingMapVals, '{-o.vectorizingMapKeys-} and {-o.vectorizingMapVals-} should not be enabled at the same time' );
    
          if( vectorizingMapVals )
          {
            _.assert( select === 1, 'Only single argument is allowed if {-o.vectorizingMapKeys-} and {-o.vectorizingMapVals-} are enabled.' );
            resultRoutine = vectorizeMapWithKeysOrArray;
          }
          else
          {
            resultRoutine = vectorizeKeysOrArray;
          }
    
        }
        else if( !vectorizingArray || vectorizingMapVals )
        resultRoutine = vectorizeMapOrArray;
        else if( multiply === multiplyNo )
        resultRoutine = vectorizeArray;
        else
        resultRoutine = vectorizeArrayMultiplying;
    
      }
      else
      {
        _.assert( multiply === multiplyNo );
        if( routine.head )
        {
          pre = routine.head;
          routine = routine.body;
        }
        if( fieldFilter )
        {
          _.assert( 0, 'not implemented' );
        }
        else if( vectorizingArray || !vectorizingMapVals )
        {
          if( _.strIs( select ) )
          resultRoutine = vectorizeForOptionsMap;
          else
          resultRoutine = vectorizeForOptionsMapForKeys;
        }
        else _.assert( 0, 'not implemented' );
      }
    
      /* */
    
      // if( vectorizingContainerAdapter )
      // {
      //   let vectorizeRoutine = resultRoutine;
      //   resultRoutine = function vectorizeContainerAdapters()
      //   {
      //     let args = originalsFromAdaptersInplace( arguments );
      //   }
      // }
    
      /* */
    
      resultRoutine.vectorized = o;
    
      /* */
    
      _.routineExtend( resultRoutine, routine );
      return resultRoutine;
    
    /*
      vectorizeWithFilters : multiply + array/map vectorizing + filter
      vectorizeArray : array vectorizing
      vectorizeArrayMultiplying :  multiply + array vectorizing
      vectorizeMapOrArray :  multiply +  array/map vectorizing
    */
    
      /* - */
    
      function routineNormalize( routine )
      {
    
        if( _.strIs( routine ) )
        {
          return function methodCall()
          {
            _.assert( _.routineIs( this[ routine ] ), () => 'Context ' + _.toStrShort( this ) + ' does not have routine ' + routine );
            return this[ routine ].apply( this, arguments );
          }
        }
        else if( _.arrayLike( routine ) )
        {
          _.assert( routine.length === 2 );
          return function methodCall()
          {
            let c = this[ routine[ 0 ] ];
            _.assert( _.routineIs( c[ routine[ 1 ] ] ), () => 'Context ' + _.toStrShort( c ) + ' does not have routine ' + routine );
            return c[ routine[ 1 ] ].apply( c, arguments );
          }
        }
    
        return routine;
      }
    
      /* - */
    
      function multiplyNo( args )
      {
        return args;
      }
    
      /* - */
    
      function multiplyReally( args )
      {
        let length;
        let keys;
    
        args = [ ... args ];
    
        if( selectAll )
        select = args.length;
    
        _.assert( args.length === select, () => 'Expects ' + select + ' arguments, but got ' + args.length );
    
        for( let d = 0 ; d < select ; d++ )
        {
          if( vectorizingArray && _.arrayLike( args[ d ] ) )
          {
            length = args[ d ].length;
            break;
          }
          else if( vectorizingArray && _.setLike( args[ d ] ) )
          {
            length = args[ d ].size;
            break;
          }
          else if( vectorizingContainerAdapter && _.containerAdapter.is( args[ d ] ) )
          {
            length = args[ d ].length;
            break;
          }
          else if( vectorizingMapVals && _.mapLike( args[ d ] ) )
          {
            keys = _.mapOwnKeys( args[ d ] );
            break;
          }
        }
    
        if( length !== undefined )
        {
          for( let d = 0 ; d < select ; d++ )
          {
            if( vectorizingMapVals )
            _.assert( !_.mapIs( args[ d ] ), () => 'Arguments should have only arrays or only maps, but not both. Incorrect argument : ' + args[ d ] );
            else if( vectorizingMapKeys && _.mapIs( args[ d ] ) )
            continue;
            args[ d ] = _.multiple( args[ d ], length );
          }
    
        }
        else if( keys !== undefined )
        {
          for( let d = 0 ; d < select ; d++ )
          if( _.mapIs( args[ d ] ) )
          {
            _.assert( _.arraySetIdentical( _.mapOwnKeys( args[ d ] ), keys ), () => 'Maps should have same keys : ' + keys );
          }
          else
          {
            if( vectorizingArray )
            _.assert( !_.arrayLike( args[ d ] ), () => 'Arguments should have only arrays or only maps, but not both. Incorrect argument : ' + args[ d ] );
            let arg = Object.create( null );
            _.objectSetWithKeys( arg, keys, args[ d ] );
            args[ d ] = arg;
          }
        }
    
        return args;
      }
    
      /* - */
    
      function vectorizeArray()
      {
        if( bypassingEmpty && !arguments.length )
        return [];
    
        let args = arguments;
        // args = _.originalsFromAdaptersInplace( args );
        let src = args[ 0 ];
    
        if( _.arrayLike( src ) )
        {
          let args2 = [ ... args ]; // Dmytro : if args[ 1 ] and next elements is not primitive, then vectorized routine can affects on this elements and array args
          let result = [];
          for( let r = 0 ; r < src.length ; r++ )
          {
            args2[ 0 ] = src[ r ];
            result[ r ] = routine.apply( this, args2 );
          }
          return result;
        }
        else if( _.setLike( src ) ) /* qqq : cover please */
        {
          let args2 = [ ... args ];
          let result = new Set;
          for( let e of src )
          {
            args2[ 0 ] = e;
            result.add( routine.apply( this, args2 ) );
          }
          return result;
        }
        else if( vectorizingContainerAdapter && _.containerAdapter.is( src ) )
        {
          let args2 = [ ... args ];
          let result = src.filter( ( e ) =>
          {
            args2[ 0 ] = e;
            return routine.apply( this, args2 );
          });
          if( unwrapingContainerAdapter )
          return result.original;
          else
          return result;
        }
    
        return routine.apply( this, args );
      }
    
      /* - */
    
      function vectorizeArrayMultiplying()
      {
        if( bypassingEmpty && !arguments.length )
        return [];
    
        // let args = multiply( _.originalsFromAdaptersInplace( arguments ) );
        let args = multiply( arguments );
        let src = args[ 0 ];
        // src = _.originalOfAdapter( src );
    
        if( _.arrayLike( src ) )
        {
          let args2 = [ ... args ];
          let result = [];
          for( let r = 0 ; r < src.length ; r++ )
          {
            for( let m = 0 ; m < select ; m++ )
            args2[ m ] = args[ m ][ r ];
            result[ r ] = routine.apply( this, args2 );
          }
          return result;
        }
    
        return routine.apply( this, args );
      }
    
      /* - */
    
      function vectorizeForOptionsMap( srcMap )
      {
        if( bypassingEmpty && !arguments.length )
        return [];
    
        let src = srcMap[ select ];
        // let args = _.originalsFromAdaptersInplace( [ ... arguments ] );
        let args = [ ... arguments ];
        _.assert( arguments.length === 1, 'Expects single argument' );
    
        if( _.arrayLike( src ) )
        {
          if( pre )
          {
            args = pre( routine, args );
            _.assert( _.arrayLikeResizable( args ) );
          }
          let result = [];
          for( let r = 0 ; r < src.length ; r++ )
          {
            args[ 0 ] = _.mapExtend( null, srcMap );
            args[ 0 ][ select ] = src[ r ];
            result[ r ] = routine.apply( this, args );
          }
          return result;
        }
        else if( _.setLike( src ) ) /* qqq : cover */
        {
          debugger;
          if( pre )
          {
            args = pre( routine, args );
            _.assert( _.arrayLikeResizable( args ) );
          }
          let result = new Set;
          for( let e of src )
          {
            args[ 0 ] = _.mapExtend( null, srcMap );
            args[ 0 ][ select ] = e;
            result.add( routine.apply( this, args ) );
          }
          return result;
        }
        else if( vectorizingContainerAdapter && _.containerAdapter.is( src ) ) /* qqq : cover */
        {
          debugger;
          if( pre )
          {
            args = pre( routine, args );
            _.assert( _.arrayLikeResizable( args ) );
          }
          result = src.filter( ( e ) =>
          {
            args[ 0 ] = _.mapExtend( null, srcMap );
            args[ 0 ][ select ] = e;
            return routine.apply( this, args );
          });
          if( unwrapingContainerAdapter )
          return result.original;
          else
          return result;
        }
    
        return routine.apply( this, arguments );
      }
    
      /* - */
    
      function vectorizeForOptionsMapForKeys()
      {
        let result = [];
    
        if( bypassingEmpty && !arguments.length )
        return result;
    
        for( let i = 0; i < o.select.length; i++ )
        {
          select = o.select[ i ];
          result[ i ] = vectorizeForOptionsMap.apply( this, arguments );
        }
        return result;
      }
    
      /* - */
    
      function vectorizeMapOrArray()
      {
        if( bypassingEmpty && !arguments.length )
        return [];
    
        // let args = multiply( _.originalsFromAdaptersInplace( arguments ) );
        let args = multiply( arguments );
        let src = args[ 0 ];
    
        if( vectorizingArray && _.arrayLike( src ) )
        {
          let args2 = [ ... args ];
          let result = [];
          for( let r = 0 ; r < src.length ; r++ )
          {
            for( let m = 0 ; m < select ; m++ )
            args2[ m ] = args[ m ][ r ];
            result[ r ] = routine.apply( this, args2 );
          }
          return result;
        }
        else if( vectorizingMapVals && _.mapIs( src ) )
        {
          let args2 = [ ... args ];
          let result = Object.create( null );
          for( let r in src )
          {
            for( let m = 0 ; m < select ; m++ )
            args2[ m ] = args[ m ][ r ];
    
            result[ r ] = routine.apply( this, args2 );
          }
          return result;
        }
    
        return routine.apply( this, arguments );
      }
    
      /* - */
    
      function vectorizeMapWithKeysOrArray()
      {
        if( bypassingEmpty && !arguments.length )
        return [];
    
        // let args = multiply( _.originalsFromAdaptersInplace( arguments ) );
        let args = multiply( arguments );
        let srcs = args[ 0 ];
    
        _.assert( args.length === select, () => 'Expects ' + select + ' arguments but got : ' + args.length );
    
        if( vectorizingMapKeys && vectorizingMapVals &&_.mapIs( srcs ) )
        {
          let result = Object.create( null );
          for( let s in srcs )
          {
            let val = routine.call( this, srcs[ s ] );
            let key = routine.call( this, s );
            result[ key ] = val;
          }
          return result;
        }
        else if( vectorizingArray && _.arrayLike( srcs ) )
        {
          let result = [];
          for( let s = 0 ; s < srcs.length ; s++ )
          result[ s ] = routine.call( this, srcs[ s ] );
          return result;
        }
    
        return routine.apply( this, arguments );
      }
    
      /* - */
    
      function vectorizeWithFilters( src )
      {
    
        _.assert( 0, 'not tested' ); /* qqq : cover please */
        _.assert( arguments.length === 1, 'Expects single argument' );
    
        // let args = multiply( _.originalsFromAdaptersInplace( arguments ) );
        let args = multiply( arguments );
    
        if( vectorizingArray && _.arrayLike( src ) )
        {
          args = [ ... args ];
          let result = [];
          throw _.err( 'not tested' ); /* cover please */
          for( let r = 0 ; r < src.length ; r++ )
          {
            if( fieldFilter( src[ r ], r, src ) )
            {
              args[ 0 ] = src[ r ];
              result.push( routine.apply( this, args ) );
            }
            else if( bypassingFilteredOut )
            {
              result.push( src[ r ] );
            }
          }
          return result;
        }
        else if( vectorizingMapVals && _.mapIs( src ) )
        {
          args = [ ... args ];
          let result = Object.create( null );
          throw _.err( 'not tested' ); /* qqq : cover please */
          for( let r in src )
          {
            if( fieldFilter( src[ r ], r, src ) )
            {
              args[ 0 ] = src[ r ];
              result[ r ] = routine.apply( this, args );
            }
            else if( bypassingFilteredOut )
            {
              result[ r ] = src[ r ];
            }
          }
          return result;
        }
    
        return routine.call( this, src );
      }
    
      /* - */
    
      function vectorizeKeysOrArray()
      {
        if( bypassingEmpty && !arguments.length )
        return [];
    
        // let args = multiply( _.originalsFromAdaptersInplace( arguments ) );
        let args = multiply( arguments );
        let src = args[ 0 ];
        let args2;
        let result;
        let map;
        let mapIndex;
        let arr;
    
        _.assert( args.length === select, () => 'Expects ' + select + ' arguments but got : ' + args.length );
    
        if( vectorizingMapKeys )
        {
          for( let d = 0; d < select; d++ )
          {
            if( vectorizingArray && _.arrayLike( args[ d ] ) )
            arr = args[ d ];
            else if( _.mapIs( args[ d ] ) )
            {
              _.assert( map === undefined, () => 'Arguments should have only single map. Incorrect argument : ' + args[ d ] );
              map = args[ d ];
              mapIndex = d;
            }
          }
        }
    
        if( map )
        {
          result = Object.create( null );
          args2 = [ ... args ];
    
          if( vectorizingArray && _.arrayLike( arr ) )
          {
            for( let i = 0; i < arr.length; i++ )
            {
              for( let m = 0 ; m < select ; m++ )
              args2[ m ] = args[ m ][ i ];
    
              for( let k in map )
              {
                args2[ mapIndex ] = k;
                let key = routine.apply( this, args2 );
                result[ key ] = map[ k ];
              }
            }
          }
          else
          {
            for( let k in map )
            {
              args2[ mapIndex ] = k;
              let key = routine.apply( this, args2 );
              result[ key ] = map[ k ];
            }
          }
    
          return result;
        }
        else if( vectorizingArray && _.arrayLike( src ) )
        {
          args2 = [ ... args ];
          result = [];
          for( let r = 0 ; r < src.length ; r++ )
          {
            for( let m = 0 ; m < select ; m++ )
            args2[ m ] = args[ m ][ r ];
            result[ r ] = routine.apply( this, args2 );
          }
          return result;
        }
    
        return routine.apply( this, arguments );
      }
    
    }
  
    //
  
  _vectorize_body.defaults = {
      "routine" : null, 
      "fieldFilter" : null, 
      "bypassingFilteredOut" : 1, 
      "bypassingEmpty" : 0, 
      "vectorizingArray" : 1, 
      "vectorizingMapVals" : 0, 
      "vectorizingMapKeys" : 0, 
      "vectorizingContainerAdapter" : 0, 
      "unwrapingContainerAdapter" : 0, 
      "select" : 1
    }
    ;
  _.vectorize = _.routineUnite( _vectorize_head, _vectorize_body );
  _.vectorize.defaults =
  {
    "routine" : null, 
    "fieldFilter" : null, 
    "bypassingFilteredOut" : 1, 
    "bypassingEmpty" : 0, 
    "vectorizingArray" : 1, 
    "vectorizingMapVals" : 0, 
    "vectorizingMapKeys" : 0, 
    "vectorizingContainerAdapter" : 0, 
    "unwrapingContainerAdapter" : 0, 
    "select" : 1
  };
  var vectorize = _.vectorize;

//

  _.strsAreAll = function strsAreAll( src )
  {
    _.assert( arguments.length === 1 );
  
    if( _.arrayLike( src ) )
    {
      for( let s = 0 ; s < src.length ; s++ )
      if( !_.strIs( src[ s ] ) )
      return false;
      return true;
    }
  
    return _.strIs( src );
  };
  var strsAreAll = _.strsAreAll;

//

  _.strReplaceAll = function strReplaceAll( src, ins, sub )
  {
    let o;
    let foundArray = [];
  
    if( arguments.length === 3 )
    {
      o = { src };
      o.dictionary = [ [ ins, sub ] ]
    }
    else if( arguments.length === 2 )
    {
      o = { src : arguments[ 0 ] , dictionary : arguments[ 1 ] };
    }
    else if( arguments.length === 1 )
    {
      o = arguments[ 0 ];
    }
    else
    {
      _.assert( 0 );
    }
  
    /* verify */
  
    _.routineOptions( strReplaceAll, o );
    _.assert( _.strIs( o.src ) );
    // _.assert( arguments.length === 1 || arguments.length === 2 || arguments.length === 3 ); // Dmytro : added to checking of arguments
  
    _._strReplaceMapPrepare( o );
  
    /* */
  
    let found = _.strFindAll( o.src, o.ins );
    let result = [];
    let index = 0;
  
    found.forEach( ( it ) =>
    {
      let sub = o.sub[ it.tokenId ];
      let unknown = o.src.substring( index, it.range[ 0 ] );
      if( unknown )
      if( o.onUnknown )
      unknown = o.onUnknown( unknown, it, o );
      if( unknown !== '' )
      result.push( unknown );
      if( _.routineIs( sub ) )
      sub = sub.call( o, it.match, it );
      // _.assert( _.strIs( sub ) );
      if( sub !== '' )
      result.push( sub );
      index = it.range[ 1 ];
    });
  
    result.push( o.src.substring( index, o.src.length ) );
  
    if( o.joining )
    result = result.join( '' )
  
    return result;
  }
  _.strReplaceAll.defaults =
  {
    "src" : null, 
    "dictionary" : null, 
    "ins" : null, 
    "sub" : null, 
    "joining" : 1, 
    "onUnknown" : null
  };
  var strReplaceAll = _.strReplaceAll;

//

  _.strFindAll = function strFindAll( src, ins )
  {
    let o;
  
    /* xxx : sync names with _.strLeft / _.strRight */
  
    if( arguments.length === 2 )
    {
      o = { src : arguments[ 0 ] , ins : arguments[ 1 ] };
    }
    else if( arguments.length === 1 )
    {
      o = arguments[ 0 ];
    }
  
    if( _.strIs( o.ins ) || _.regexpIs( o.ins ) )
    o.ins = [ o.ins ];
  
    /* */
  
    _.assert( arguments.length === 1 || arguments.length === 2 );
    _.assert( _.strIs( o.src ) );
    _.assert( _.arrayLike( o.ins ) || _.objectIs( o.ins ) );
    _.routineOptions( strFindAll, o );
  
    /* */
  
    let tokensSyntax = _.tokensSyntaxFrom( o.ins );
    let descriptorsArray = [];
    let execeds = [];
    let closests = [];
    let closestTokenId = -1;
    let closestIndex = o.src.length;
    let currentIndex = 0;
  
    /* */
  
    tokensSyntax.idToValue.forEach( ( ins, tokenId ) =>
    {
      // Dmytro : not optimal - double check
      _.assert( _.strIs( ins ) || _.regexpIs( ins ) );
  
      if( _.regexpIs( ins ) )
      _.assert( !ins.sticky );
  
      let found = find( o.src, ins, tokenId );
      closests[ tokenId ] = found;
      if( found < closestIndex )
      {
        closestIndex = found
        closestTokenId = tokenId;
      }
    });
  
    /* */
  
    while( closestIndex < o.src.length )
    {
  
      if( o.tokenizingUnknown && closestIndex > currentIndex )
      {
        descriptorFor( o.src, currentIndex, -1 );
      }
  
      descriptorFor( o.src, closestIndex, closestTokenId );
  
      closestIndex = o.src.length;
      closests.forEach( ( index, tokenId ) =>
      {
        if( index < currentIndex )
        index = closests[ tokenId ] = find( o.src, tokensSyntax.idToValue[ tokenId ], tokenId );
  
        _.assert( closests[ tokenId ] >= currentIndex );
  
        if( index < closestIndex )
        {
          closestIndex = index
          closestTokenId = tokenId;
        }
      });
  
      _.assert( closestIndex <= o.src.length );
    }
  
    if( o.tokenizingUnknown && closestIndex > currentIndex )
    {
      descriptorFor( o.src, currentIndex, -1 );
    }
  
    /* */
  
    return descriptorsArray;
  
    /* */
  
    function find( src, ins, tokenId )
    {
      let result;
  
      if( _.strIs( ins ) )
      {
        if( !ins.length )
        result = src.length;
        else
        result = findWithString( o.src, ins, tokenId );
      }
      else if( _.regexpIs( ins ) )
      {
        if( ins.source === '(?:)' ) // Dmytro : missed, it's regexp for empty string
        result = src.length;
        else
        result = findWithRegexp( o.src, ins, tokenId );
      }
      else _.assert( 0 );
  
      _.assert( result >= 0 );
      return result;
    }
  
    /* */
  
    function findWithString( src, ins )
    {
  
      if( !ins.length ) // Dmytro : duplicate from previous subroutine
      return src.length;
  
      let index = src.indexOf( ins, currentIndex );
  
      if( index < 0 )
      return src.length;
  
      return index;
    }
  
    /* */
  
    function findWithRegexp( src, ins, tokenId )
    {
      let execed;
      let result = src.length;
  
      if( currentIndex === 0 || ins.global )
      {
  
        do
        {
  
          execed = ins.exec( src );
          if( execed )
          result = execed.index;
          else
          result = src.length;
  
        }
        while( result < currentIndex );
  
      }
      else
      {
        execed = ins.exec( src.substring( currentIndex ) );
  
        if( execed )
        result = execed.index + currentIndex;
  
      }
  
      if( execed )
      execeds[ tokenId ] = execed;
  
      return result;
    }
  
    /* */
  
    function descriptorFor( src, index, tokenId )
    {
      let originalIns = tokensSyntax.idToValue[ tokenId ];
      let foundIns;
  
      if( tokenId === -1 )
      originalIns = src.substring( index, closestIndex );
  
      if( o.fast )
      {
        let it = [];
  
        if( _.strIs( originalIns ) )
        {
          foundIns = originalIns;
        }
        else
        {
          let execed = execeds[ tokenId ];
          _.assert( !!execed );
          foundIns = execed[ 0 ];
        }
  
        it[ 0 ] = index;
        it[ 1 ] = index + foundIns.length;
        it[ 2 ] = tokenId;
  
        descriptorsArray.push( it );
      }
      else
      {
        let it = Object.create( null );
        let groups;
  
        if( _.strIs( originalIns ) )
        {
          foundIns = originalIns;
          groups = [];
        }
        else
        {
          let execed = execeds[ tokenId ];
          _.assert( !!execed );
          foundIns = execed[ 0 ];
          groups = _.longSlice( execed, 1, execed.length );
        }
  
        it.match = foundIns;
        it.groups = groups;
        it.tokenId = tokenId;
        it.range = [ index, index + foundIns.length ];
        it.counter = o.counter;
        it.input = src;
  
        if( tokensSyntax.idToName && tokensSyntax.idToName[ tokenId ] )
        it.tokenName = tokensSyntax.idToName[ tokenId ];
  
        descriptorsArray.push( it );
      }
  
      _.assert( _.strIs( foundIns ) );
      if( foundIns.length > 0 )
      currentIndex = index + foundIns.length;
      else
      currentIndex = index + 1;
  
      o.counter += 1;
    }
  
  }
  _.strFindAll.defaults =
  {
    "src" : null, 
    "ins" : null, 
    "fast" : 0, 
    "counter" : 0, 
    "tokenizingUnknown" : 0
  };
  var strFindAll = _.strFindAll;

//

  _.tokensSyntaxFrom = function tokensSyntaxFrom( ins )
  {
  
    if( ins instanceof _.TokensSyntax )
    return ins
  
    let result = TokensSyntax();
  
    if( _.strIs( ins ) || _.regexpIs( ins ) )
    ins = [ ins ];
  
    /* */
  
    _.assert( arguments.length === 1 );
    _.assert( _.arrayLike( ins ) || _.objectIs( ins ) );
  
    /* */
  
    /*
    qqq2 : ins could be also array _.strFindAll( 'some string2', { a : 'some', b : [ 'string1', 'string2' ] } ) cover extension please | Dmytro : covered routines tokensSyntaxFrom and strFindAll
    */
  
    result.idToValue = ins;
    if( _.mapIs( ins ) )
    {
      result.idToValue = [];
      result.idToName = [];
      let i = 0;
      for( var name in ins )
      {
        let element = ins[ name ];
        if( _.longIs( element ) )
        {
          let alternative = result.alternatives[ name ] = result.alternatives[ name ] || [];
          for( let e = 0 ; e < element.length ; e++ )
          {
            let name2 = name + '_' + element[ e ];
            result.idToValue[ i ] = ins[ name ][ e ]; // Dmytro : better to use local variable 'let element'. Also, maybe, needs check type of element - regexp or string.
            result.idToName[ i ] = name2;
            result.nameToId[ name2 ] = i;
            alternative.push( name2 );
            i += 1;
          }
        }
        else
        {
          result.idToValue[ i ] = ins[ name ]; // Dmytro : better to use local variable 'let element'
          result.idToName[ i ] = name;
          result.nameToId[ name ] = i;
          i += 1;
        }
      }
    }
  
    return result;
  };
  var tokensSyntaxFrom = _.tokensSyntaxFrom;

//

  _._strReplaceMapPrepare = function _strReplaceMapPrepare( o )
  {
  
    /* verify */
  
    _.assertMapHasAll( o, _strReplaceMapPrepare.defaults );
    _.assert( arguments.length === 1 );
    _.assert( _.objectIs( o.dictionary ) || _.longIs( o.dictionary ) || o.dictionary === null );
    _.assert( ( _.longIs( o.ins ) && _.longIs( o.sub ) ) || ( o.ins === null && o.sub === null ) );
  
    /* pre */
  
    if( o.dictionary )
    {
  
      o.ins = [];
      o.sub = [];
  
      if( _.objectIs( o.dictionary ) )
      {
        let i = 0;
        for( let d in o.dictionary )
        {
          o.ins[ i ] = d;
          o.sub[ i ] = o.dictionary[ d ];
          i += 1;
        }
      }
      else
      {
        let i = 0;
        o.dictionary.forEach( ( d ) =>
        {
          let ins = d[ 0 ];
          let sub = d[ 1 ];
          _.assert( d.length === 2 );
          _.assert( !( _.arrayIs( ins ) ^ _.arrayIs( sub ) ) );
          if( _.arrayIs( ins ) )
          {
            _.assert( ins.length === sub.length )
            for( let n = 0 ; n < ins.length ; n++ )
            {
              o.ins[ i ] = ins[ n ];
              o.sub[ i ] = sub[ n ];
              i += 1;
            }
          }
          else
          {
            o.ins[ i ] = ins;
            o.sub[ i ] = sub;
            i += 1;
          }
        });
      }
  
      o.dictionary = null;
    }
  
    /* verify */
  
    _.assert( !o.dictionary );
    _.assert( o.ins.length === o.sub.length );
  
    if( Config.debug )
    {
      o.ins.forEach( ( ins ) => _.assert( _.strIs( ins ) || _.regexpIs( ins ) ), 'Expects String or RegExp' );
      o.sub.forEach( ( sub ) => _.assert( _.strIs( sub ) || _.routineIs( sub ) ), 'Expects String or Routine' );
    }
  
    return o;
  }
  _._strReplaceMapPrepare.defaults =
  { "dictionary" : null, "ins" : null, "sub" : null };
  var _strReplaceMapPrepare = _._strReplaceMapPrepare;

//

  _.assertMapHasAll = function assertMapHasAll( srcMap, all, msg )
  {
    if( Config.debug === false )
    return true;
    return _.sureMapHasAll.apply( this, arguments );
  };
  var assertMapHasAll = _.assertMapHasAll;

//

  _.sureMapHasAll = function sureMapHasAll( srcMap, all, msg )
  {
  
    _.assert( arguments.length === 2 || arguments.length === 3 || arguments.length === 4, 'Expects two, three or four arguments' );
  
    let but = Object.keys( _.mapBut( all, srcMap ) );
  
    if( but.length > 0 )
    {
      debugger;
      if( arguments.length === 2 )
      throw _._err
      ({
        args : [ `${ _.strType( srcMap ) } should have fields :`, _.strQuote( but ).join( ', ' ) ],
        level : 2,
      });
      else
      {
        let arr = [];
        for ( let i = 2; i < arguments.length; i++ )
        {
          if( _.routineIs( arguments[ i ] ) )
          arguments[ i ] = ( arguments[ i ] )();
          arr.push( arguments[ i ] );
        }
        throw _._err
        ({
          args : [ arr.join( ' ' ), _.strQuote( but ).join( ', ' ) ],
          level : 2,
        });
      }
  
      return false;
    }
  
    return true;
  };
  var sureMapHasAll = _.sureMapHasAll;

//

  _.longSlice = function longSlice( array, f, l )
  {
    _.assert( 1 <= arguments.length && arguments.length <= 3 );
    _.assert( f === undefined || _.numberIs( f ) );
    _.assert( l === undefined || _.numberIs( l ) );
  
    if( _.bufferTypedIs( array ) )
    return array.subarray( f, l );
    else if( _.arrayLikeResizable( array ) )
    return array.slice( f, l );
    else if( _.argumentsArrayIs( array ) )
    return Array.prototype.slice.call( array, f, l );
    else
    _.assert( 0 );
  
  };
  var longSlice = _.longSlice;

//

  _.arrayLikeResizable = function arrayLikeResizable( src )
  {
    if( Object.prototype.toString.call( src ) === '[object Array]' )
    return true;
    return false;
  };
  var arrayLikeResizable = _.arrayLikeResizable;

//

  _.regexpEscape = function regexpEscape( src )
  {
    _.assert( _.strIs( src ) );
    _.assert( arguments.length === 1, 'Expects single argument' );
    return src.replace( /([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1" );
  };
  var regexpEscape = _.regexpEscape;

//

  _.filter = function entityFilter( src, onEach )
  {
    let result;
  
    onEach = _._filter_functor( onEach, 1 );
  
    _.assert( arguments.length === 2 );
    // _.assert( _.objectLike( src ) || _.longIs( src ), () => 'Expects objectLike or longIs src, but got ' + _.strType( src ) );
    _.assert( _.routineIs( onEach ) );
    _.assert( src !== undefined, 'Expects src' );
  
    /* */
  
    if( _.longIs( src ) )
    {
  
      result = _.longMake( src, 0 );
      let s, d;
      for( s = 0, d = 0 ; s < src.length ; s++ )
      {
        let r = onEach.call( src, src[ s ], s, src );
        if( _.unrollIs( r ) )
        {
          _.arrayAppendArray( result, r );
          d += r.length;
        }
        else if( r !== undefined )
        {
          result[ d ] = r;
          d += 1;
        }
      }
      if( d < src.length )
      result = _.arraySlice( result, 0, d );
  
    }
    // else if( _.objectLike( src ) )
    else if( _.mapLike( src ) )
    {
  
      result = _.entityMakeUndefined( src );
      for( let s in src )
      {
        let r = onEach.call( src, src[ s ], s, src );
        if( r !== undefined )
        result[ s ] = r;
      }
  
    }
    else
    {
  
      result = onEach.call( null, src, null, null );
  
    }
  
    /* */
  
    return result;
  };
  var filter = _.filter;

//

  _._filter_functor = function _filter_functor( condition, levels )
  {
    let result;
  
    _.assert( arguments.length === 2, 'Expects exactly two arguments' );
    _.assert( _.routineIs( condition ) || _.objectIs( condition ) );
  
    if( _.objectIs( condition ) )
    {
      let template = condition;
      condition = function selector( e, k, src )
      {
        _.assert( arguments.length === 3 );
        if( e === template )
        return e;
        if( !_.objectLike( e ) )
        return;
        let satisfied = _.objectSatisfy
        ({
          template,
          src : e,
          levels
        });
        if( satisfied )
        return e;
      };
    }
  
    return condition;
  };
  var _filter_functor = _._filter_functor;

//

  _.entityMakeUndefined = function entityMakeUndefined( src, length )
  {
  
    _.assert( arguments.length === 1 || arguments.length === 2 );
  
    if( _.arrayIs( src ) )
    {
      return new Array( length !== undefined ? length : src.length );
    }
    else if( _.longIs( src ) )
    {
      return this.longMakeUndefined( src, length );
      // return this.longMake( src, length ); /* Dmytro : incorrect usage of routine */
    }
    else if( _.setIs( src ) )
    {
      return new src.constructor();
    }
    else if( _.hashMapIs( src ) )
    {
      return new src.constructor();
    }
    else if( _.mapLike( src ) )
    {
      return Object.create( null );
    }
    else if( src === _.null )
    {
      return null;
    }
    else if( src === _.undefined )
    {
      return undefined;
    }
    else if( _.primitiveIs( src ) )
    {
      return src;
    }
    else _.assert( 0, 'Not clear how to make a new object of ', _.strType( src ) );
  
  };
  var entityMakeUndefined = _.entityMakeUndefined;

//

  _.mapKeys = function mapKeys( srcMap, o )
  {
    let result;
    // let o = this === Self ? Object.create( null ) : this;
    /* aaa : review test routine for this and all routines which had been acception option in context. look in this file map* routines of such kind */
    /* Dmytro : all routines does not use options in context, file l5/fMap.s has routine mapInvert that uses options in context */
  
    _.assert( arguments.length === 1 || arguments.length === 2 );
    o = _.routineOptions( mapKeys, o );
    _.assert( !_.primitiveIs( srcMap ) );
  
    o.srcMap = srcMap;
  
    // if( o.enumerable )
    // result = _._mapEnumerableKeys( o.srcMap, o.own );
    // else
    result = _._mapKeys( o );
  
    return result;
  }
  _.mapKeys.defaults =
  { "own" : 0, "enumerable" : 1 };
  var mapKeys = _.mapKeys;

//


  
    var _globFilter_head = function globFilter_head( routine, args )
    {
      let result;
    
      _.assert( arguments.length === 2 );
      _.assert( args.length === 1 || args.length === 2 );
    
      let o = args[ 0 ];
      if( args[ 1 ] !== undefined )
      o = { src : args[ 0 ], selector : args[ 1 ] }
    
      o = _.routineOptions( routine, o );
    
      if( o.onEvaluate === null )
      o.onEvaluate = function byVal( e, k, src )
      {
        return e;
      }
    
      return o;
    }
  
    //
  
  
    var _globFilter_body = function globFilter_body( o )
    {
      let result;
    
      _.assert( arguments.length === 1 );
    
      if( this.isGlob( o.selector ) )
      {
        let regexp = this.globSplitsToRegexps( o.selector );
        result = _.filter( o.src, ( e, k ) =>
        {
          return regexp.test( o.onEvaluate( e, k, o.src ) ) ? e : undefined;
        });
      }
      else
      {
        result = _.filter( o.src, ( e, k ) =>
        {
          return o.onEvaluate( e, k, o.src ) === o.selector ? e : undefined;
        });
      }
    
      return result;
    }
  
    //
  
  _globFilter_body.defaults = { "src" : null, "selector" : null, "onEvaluate" : null }
    ;
  _.path.globFilterKeys = _.routineUnite( _globFilter_head, _globFilter_body );
  _.path.globFilterKeys.defaults =
  {
    "onEvaluate" : function byKey( e, k, src )
  {
    return _.arrayIs( src ) ? e : k;
  }, 
    "src" : null, 
    "selector" : null
  };
  var globFilterKeys = _.path.globFilterKeys;

//

  _.path.globSplitsToRegexps = 
  (function()
  {
    // debugger;
    let toVectorize = Object.create( null );
    toVectorize.routine = function globSplitToRegexp( glob )
    {
      _.assert( _.strIs( glob ) || _.regexpIs( glob ) );
      _.assert( arguments.length === 1 );
    
      if( _.regexpIs( glob ) )
      return glob;
    
      let str = this._globSplitToRegexpSource( glob );
      let result = new RegExp( '^' + str + '$' );
      return result;
    };
    var routine = toVectorize.routine;
  
  //
  toVectorize.vectorizingArray = 1;
  
  //
  toVectorize.vectorizingMapVals = 0;
  
  //
  toVectorize.vectorizingMapKeys = 1;
  
  //
  toVectorize.select = 1;
  
  //
  toVectorize.fieldFilter = null;
  
  //
  toVectorize.bypassingFilteredOut = 1;
  
  //
  toVectorize.bypassingEmpty = 0;
  
  //
  toVectorize.vectorizingContainerAdapter = 0;
  
  //
  toVectorize.unwrapingContainerAdapter = 0;
  
  //
  
    return _.vectorize( toVectorize );
  })();
        ;
  var globSplitsToRegexps = _.path.globSplitsToRegexps;

//

  _.path._globSplitToRegexpSource = (function functor()
  {
  
    let self;
    let _globRegexpSourceCache = Object.create( null )
  
    let _transformation0 =
    [
      [ /\[(.+?)\]/g, handlePass ], /* square brackets */
      [ /\.\./g, handlePass ], /* dual dot */
      [ /\./g, handlePass ], /* dot */
      [ /\(\)|\0/g, handlePass ], /* empty parentheses or zero */
      [ /([!?*@+]*)\((.*?(?:\|(.*?))*)\)/g, handlePass ], /* parentheses */
      [ /\*\*\*/g, handlePass, ], /* triple asterix */
      [ /\*\*/g, handlePass, ], /* dual asterix */
      [ /(\*)/g, handlePass ], /* single asterix */
      [ /(\?)/g, handlePass ], /* question mark */
    ]
  
    let _transformation1 =
    [
      [ /\[(.+?)\]/g, handleSquareBrackets ], /* square brackets */
      [ /\{(.*)\}/g, handleCurlyBrackets ], /* curly brackets */
    ]
  
    let _transformation2 =
    [
      [ /\.\./g, '\\.\\.' ], /* dual dot */
      [ /\./g, '\\.' ], /* dot */
      [ /\(\)|\0/g, '' ], /* empty parentheses or zero */
      [ /([!?*@+]?)\((.*?(?:\|(.*?))*)\)/g, hanleParentheses ], /* parentheses */
      // [ /\/\*\*/g, '(?:\/.*)?', ], /* slash + dual asterix */
      [ /\*\*\*/g, '(?:.*)', ], /* triple asterix */
      [ /\*\*/g, '.*', ], /* dual asterix */
      [ /(\*)/g, '[^\/]*' ], /* single asterix */
      [ /(\?)/g, '[^\/]' ], /* question mark */
    ]
  
    /* */
  
    _globSplitToRegexpSource.functor = functor;
    return _globSplitToRegexpSource;
  
    function _globSplitToRegexpSource( src )
    {
      self = this;
  
      _.assert( _.strIs( src ) );
      _.assert( arguments.length === 1, 'Expects single argument' );
      _.assert
      (
        !_.strHas( src, /(^|\/)\.\.(\/|$)/ ) || src === self._downStr,
        'glob should not has splits with ".." combined with something'
      );
  
      let result;
  
      result = _globRegexpSourceCache[ src ];
  
      if( result )
      return result;
  
      // if( self.isGlob( src ) )
      // debugger;
  
      result = transform( src );
  
      _globRegexpSourceCache[ src ] = result;
  
      return result;
    }
  
    /* */
  
    function transform( src )
    {
      let result = src;
  
      result = _.strReplaceAll
      ({
        src : result,
        dictionary : _transformation0,
        joining : 1,
        onUnknown : handleUnknown,
      });
  
      result = _.strReplaceAll( result, _transformation1 );
      result = _.strReplaceAll( result, _transformation2 );
  
      return result;
    }
  
    /* */
  
    function handleUnknown( src )
    {
      return _.regexpEscape( src );
    }
  
    /* */
  
    function handlePass( src )
    {
      return src;
    }
  
    /* */
  
    function handleCurlyBrackets( src, it )
    {
      debugger;
      throw _.err( 'Glob with curly brackets is not allowed ', src );
    }
  
    /* */
  
    function handleSquareBrackets( src, it )
    {
      let inside = it.groups[ 0 ];
      /* escape inner [] */
      inside = inside.replace( /[\[\]]/g, ( m ) => '\\' + m );
      /* replace ! -> ^ at the beginning */
      inside = inside.replace( /^!/g, '^' );
      if( inside[ 0 ] === '^' )
      inside = inside + '\/';
      return [ '[' + inside + ']' ];
    }
  
    /* */
  
    function hanleParentheses( src, it )
    {
  
      let inside = it.groups[ 1 ].split( '|' );
      let multiplicator = it.groups[ 0 ];
  
      multiplicator = _.strReverse( multiplicator );
      if( multiplicator === '*' )
      multiplicator += '?';
  
      _.assert( _.strCount( multiplicator, '!' ) === 0 || multiplicator === '!' );
      _.assert( _.strCount( multiplicator, '@' ) === 0 || multiplicator === '@' );
  
      // inside = inside.map( ( i ) => _.regexpEscape( i ) );
      inside = inside.map( ( i ) => self._globSplitToRegexpSource( i ) );
  
      let result = '(?:' + inside.join( '|' ) + ')';
      if( multiplicator === '@' )
      result = result;
      else if( multiplicator === '!' )
      result = '(?:(?!(?:' + result + '|\/' + ')).)*?';
      else
      result += multiplicator;
  
      /* (?:(?!(?:abc)).)+ */
  
      return result;
    }
  
    /* */
  
  })();;
  var _globSplitToRegexpSource = _.path._globSplitToRegexpSource;

//




  

let ToolsExtension =
{
  TokensSyntax,
}

Object.assign( _starter_, ToolsExtension );

let PathExtension =
{
}

Object.assign( _starter_.path, PathExtension );

;

/* */  /* end of globing */ })();


/* */  /* begin of bro */ ( function _bro_() {

  

  'use strict';

  let _global = _global_;
  let _starter_ = _global_._starter_;
  let _ = _starter_;
  let path = _starter_.path;
  let sourcesMap = _starter_.sourcesMap;

  if( _global._starter_ && _global._starter_._inited )
  return;

  //

  let FilesCache = Object.create( null );
  function _broFileReadAct( o )
  {
    let self = this;
    let Reqeust, request, total, result, error;

    _.assertRoutineOptions( _broFileReadAct, arguments );
    _.assert( arguments.length === 1, 'Expects single argument' );
    _.assert( _.strIs( o.filePath ), '_broFileReadAct :', 'Expects {-o.filePath-}' );

    if( FilesCache[ o.filePath ] )
    return FilesCache[ o.filePath ];

    /* advanced */

    o.advanced = _.routineOptions( _broFileReadAct, o.advanced, _broFileReadAct.advanced );
    o.advanced.method = o.advanced.method.toUpperCase();

    /* http request */

    if( typeof XMLHttpRequest !== 'undefined' )
    Reqeust = XMLHttpRequest;
    else if( typeof ActiveXObject !== 'undefined' )
    Reqeust = new ActiveXObject( 'Microsoft.XMLHTTP' );
    else
    {
      throw _.err( 'not implemented' );
    }

    /* set */

    request = o.request = new Reqeust();

    if( !o.sync )
    {
      if( o.encoding === 'buffer.bytes' )
      request.responseType = 'arraybuffer';
      else if( o.encoding === 'json' )
      request.responseType = 'json';
    }

    request.addEventListener( 'progress', handleProgress );
    request.addEventListener( 'load', handleEnd );
    request.addEventListener( 'error', handleErrorEvent );
    request.addEventListener( 'timeout', handleErrorEvent );
    request.addEventListener( 'readystatechange', handleState );
    request.open( o.advanced.method, o.filePath, !o.sync, o.advanced.user, o.advanced.password );
    /*request.setRequestHeader( 'Content-type', 'application/octet-stream' );*/

    handleBegin();

    try
    {
      if( o.advanced && o.advanced.send !== null )
      request.send( o.advanced.send );
      else
      request.send();
    }
    catch( err )
    {
      handleError( err );
    }

    _.assert( o.sync );
    if( o.sync )
    {
      if( error )
      {
        // debugger;
        throw _.err( error );
      }
      return result;
    }
    // else
    // return con;

    /* - */

    /* handler */

    function getData( response )
    {
      if( request.responseType === 'text' )
      return response.responseText || response.response;
      if( request.responseType === 'document' )
      return response.responseXML || response.response;
      return response.response;
    }

    /* begin */

    function handleBegin()
    {

      // debugger;
      // console.log( 'request.responseType', request.responseType );
      // if( !o.sync )
      // request.responseType = encoder.responseType;

    }

    /* end */

    function handleEnd( e )
    {

      if( o.ended )
      return;

      try
      {

        result = getData( request );
        o.ended = 1;

        if( !_.strBegins( o.filePath, '.resolve/' ) )
        FilesCache[ o.filePath ] = result;

        // con.take( result );
      }
      catch( err )
      {
        handleError( err );
      }

    }

    /* progress */

    function handleProgress( e )
    {
    }

    /* error */

    function handleError( err )
    {
      error = err;
      // error = _.err( err );
      o.ended = 1;
      // con.error( err );
    }

    /* error event */

    function handleErrorEvent( e )
    {
      let err = _.err( err, '\nNetwork error' );
      return handleError( err );
    }

    /* state */

    function handleState( e )
    {

      if( o.ended )
      return;

      if( this.readyState === 2 )
      {

      }
      else if( this.readyState === 3 )
      {

        let data = getData( this );
        if( !data ) return;
        if( !total ) total = this.getResponseHeader( 'Content-Length' );
        total = Number( total ) || 1;
        if( isNaN( total ) ) return;
        handleProgress( data.length / total, o );

      }
      else if( this.readyState === 4 )
      {

        if( o.ended )
        return;

        if( this.status === 200 )
        {
          handleEnd( e );
        }
        else if( this.status === 0 )
        {
        }
        else
        {
          handleError( '#' + this.status );
        }

      }

    }

  }

  var defaults = _broFileReadAct.defaults = Object.create( null );
  defaults.sync = 1;
  defaults.filePath = null;
  defaults.encoding = 'utf8';

  var advanced = _broFileReadAct.advanced = Object.create( null );
  advanced.send = null;
  advanced.method = 'GET';
  advanced.user = null;
  advanced.password = null;

  //

  function _broFileRead( o )
  {
    if( _.strIs( o ) )
    o = { filePath : o };
    _.routineOptions( _broFileRead, o );
    return _._broFileReadAct( o );
  }

  _broFileRead.defaults = Object.create( _broFileReadAct.defaults );

  //

  function _broSocketWrite( o )
  {
    let socket = _._sockets[ o.filePath ];

    if( !socket )
    {
      // console._original.log.call( console, `new socket ${o.filePath}` );
      socket = _._sockets[ o.filePath ] = new WebSocket( o.filePath );
      socket.que = [];
      socket.que.push( o.data );
      socket.onopen = function( e )
      {
        send();
        setTimeout( () => handleTime(), 1000 );
      };
    }
    else
    {
      socket.que.push( o.data );
      if( socket.readyState === WebSocket.OPEN )
      send();
    }

    function handleTime()
    {
      if( socket.que.length )
      {
        send();
        setTimeout( () => handleTime(), 1000 );
        return;
      }
      socket.close();
      delete _._sockets[ o.filePath ];
      Object.freeze( socket.que );
    }

    function send()
    {
      while( socket.que.length )
      {
        let data = socket.que[ 0 ];
        socket.que.splice( 0, 1 );
        socket.send( JSON.stringify( data ) );
      }
    }

  }
  _broSocketWrite.defaults =
  {
    filePath : null,
    data : null,
  }

  //

  function _broSourceFile( sourceFile, op )
  {
  }

  //

  function _broLog( o )
  {
    let starter = this;

    _._socketCounter += 1;
    o.id = _._socketCounter;
    if( !_._socketSubject )
    _._socketSubject = Date.now();
    o.subject = _._socketSubject;
    o.clientTime = Date.now();

    let response = starter._broSocketWrite
    ({
      filePath : 'ws://127.0.0.1:15000/.log/',
      data : o,
    });

    return;
  }

  _broLog.defaults =
  {
    methodName : null,
    args : null,
  }

  //

  function _broPathResolveRemote( filePath )
  {
    let starter = this;

    if( _.path.isGlob( filePath ) || _.path.isRelative( filePath ) )
    {
      filePath = starter._broFileRead
      ({
        filePath : '/.resolve/' + filePath,
        encoding : 'json',
      });
      try
      {
        filePath = JSON.parse( filePath );
      }
      catch( err )
      {
        debugger;
        console.error( filePath );
        throw _.err( err );
      }
      return filePath;
    }

    return filePath;
  }

  //

  function _sourceResolveAct( parentSource, basePath, filePath )
  {

    let resolvedFilePath = this._pathResolveLocal( parentSource, basePath, filePath );
    let isAbsolute = resolvedFilePath[ 0 ] === '/';

    try
    {
      if( !isAbsolute )
      throw 'not tested';
      if( !isAbsolute )
      resolvedFilePath = starter._broPathResolveRemote( joinedFilePath );
      return resolvedFilePath;
    }
    catch( err )
    {
      return null;
    }
  }

  //

  function _includeAct( parentSource, basePath, filePath )
  {
    let starter = this;
    let joinedFilePath = this._pathResolveLocal( parentSource, basePath, filePath );
    let resolvedFilePath = starter._broPathResolveRemote( joinedFilePath );

    if( _.arrayIs( resolvedFilePath ) )
    {
      if( resolvedFilePath !== joinedFilePath && !resolvedFilePath.length )
      {
        throw _.err( `No source file found for "${joinedFilePath}"` );
      }
      let result = [];
      for( let f = 0 ; f < resolvedFilePath.length ; f++ )
      {
        if( starter.exclude )
        {
          if( starter.exclude.test( resolvedFilePath[ f ] ) )
          continue;
        }
        let r = starter._sourceInclude( parentSource, basePath, resolvedFilePath[ f ] );
        if( r !== undefined )
        _.arrayAppendArrays( result, r );
        else
        result.push( r );
      }
      return result;
    }

    starter._includingSource = resolvedFilePath;

    try
    {
      if( typeof window === 'undefined' )
      {
        return this._broIncludeActInWorkerResolved( parentSource, resolvedFilePath );
      }
      else
      {
        return this._broIncludeResolved( parentSource, resolvedFilePath );
      }
      end();
    }
    catch( err )
    {
      err = _.err( err );
      end();
      debugger;
      throw err;
    }

    function end()
    {
      starter._includingSource = null;
    }

  }

  //

  function _broIncludeActInWorkerResolved( parentSource, resolvedFilePath )
  {
    let starter = this;
    let result;

    _.assert( typeof importScripts !== 'undefined' );

    importScripts( resolvedFilePath );

    let childSource = starter._sourceForPathGet( resolvedFilePath );
    result = starter._sourceIncludeCall( parentSource, childSource, resolvedFilePath );

    return result;
  }

  //

  function _broIncludeResolved( parentSource, resolvedFilePath )
  {
    let starter = this;

    let read = starter._broFileRead
    ({
      filePath : resolvedFilePath,
      sync : 1,
    });

    let ext = _.path.ext( resolvedFilePath );
    if( ext === 'css' || ext === 'less' )
    {
      let link = document.createElement( 'link' );
      link.href = resolvedFilePath;
      link.rel = 'stylesheet'
      link.type = 'text/' + ext
      document.head.appendChild( link );
    }
    else
    {
      // read = '//@ sourceURL=' + _realGlobal_.location.origin + '/' + resolvedFilePath + '\n' + read;
      read = read + '\n//@ sourceURL=' + _realGlobal_.location.origin + '/' + resolvedFilePath + '\n'
      read = read + '\n//# sourceURL=' + _realGlobal_.location.origin + '/' + resolvedFilePath + '\n'

      let script = document.createElement( 'script' );
      script.type = 'text/javascript';
      let scriptCode = document.createTextNode( read );
      script.appendChild( scriptCode );
      document.head.appendChild( script );

      let childSource = starter._sourceForPathGet( resolvedFilePath );
      let result = starter._sourceIncludeCall( parentSource, childSource, resolvedFilePath );

      return result;
    }

  }

  //

  function _sourceCodeModule()
  {
    let result = Object.create( null );

    accesor( '_cache', cacheGet, cacheSet );

    this.exports = result;

    function cacheGet()
    {
      return _starter_.sourcesMap;
    }

    function cacheSet( src )
    {
      return _starter_.sourcesMap = src;
    }

    function accesor( fieldName, onGet, onSet )
    {
      Object.defineProperty( result, fieldName,
      {
        enumerable : true,
        configurable : true,
        get : onGet,
        set : onSet,
      });
    }

  }

  //

  function _broConsoleRedirect( o )
  {
    let starter = this;
    let MethodsNames =
    [
      'log', 'debug', 'error', 'warn', 'info',
      // 'assert', 'clear', 'count', 'dir', 'dirxml',
      // 'group', 'groupCollapsed', 'groupEnd',
      // 'table', 'time', 'timeEnd', 'timeStamp', 'trace'
    ];

    _.routineOptions( _broConsoleRedirect, o );

    if( o.console === null )
    o.console = console;

    let original = o.console._original = o.console._original || Object.create( null );

    if( o.enable )
    {
      _.assert( _.lengthOf( original ) === 0 );

      for( let n = 0 ; n < MethodsNames.length ; n++ )
      {
        let name = MethodsNames[ n ];
        _.assert( _.routineIs( o.console[ name ] ) );
        original[ name ] = o.console[ name ];
        o.console[ name ] = starter._broConsoleMethodRedirect( o.console, name );
      }

    }
    else
    {
      _.assert( _.lengthOf( original ) !== 0 );

      for( let n = 0 ; n < MethodsNames.length ; n++ )
      {
        let name = MethodsNames[ n ];
        _.assert( _.routineIs( o.console[ name ] ) );
        _.assert( _.routineIs( original[ name ] ) );
        o.console[ name ] = original[ name ];
        delete original[ name ];
      }

    }

  }

  _broConsoleRedirect.defaults =
  {
    console : null,
    enable : 1,
  }

  //

  function _broConsoleMethodRedirect( console, methodName )
  {
    let starter = this;
    let original = console[ methodName ];
    _.assert( _.routineIs( original ) );

    let wrap =
    {
      [ methodName ] : function()
      {
        let args = [];
        for( let i = 0 ; i < arguments.length ; i++ )
        args[ i ] = _.toStr( arguments[ i ] );
        starter._broLog({ methodName, args });
        return original.apply( console, arguments );
      }
    }

    return wrap[ methodName ];
  }

  //

  function _SetupAct()
  {
    let starter = this;
    starter._sourceMake( 'module', '/', _sourceCodeModule );

    if( starter.redirectingConsole === null || starter.redirectingConsole )
    starter._broConsoleRedirect({ console });

  }

;
  

  let Extension =
  {

    //

    _broFileReadAct,
    _broFileRead,
    _broSocketWrite,

    _broSourceFile,
    _broLog,
    _broPathResolveRemote,
    _sourceResolveAct,

    _includeAct,
    _broIncludeActInWorkerResolved,
    _broIncludeResolved,

    _broConsoleRedirect,
    _broConsoleMethodRedirect,

    _SetupAct,
    _sourceCodeModule,

    // fields

    _socketCounter : 0,
    _socketSubject : null,
    _sockets : Object.create( null ),

  }

  Object.assign( _starter_, Extension );

;

/* */  /* end of bro */ })();


/* */  /* begin of starter */ ( function _starter_() {

  

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

  //

  function _sourceMake( filePath, dirPath, nakedCall )
  {
    let r = SourceFile({ filePath, dirPath, nakedCall });
    return r;
  }

  //

  function _sourceIncludeCall( parentSource, childSource, sourcePath )
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
        let filtered = _.mapKeys( _.path.globFilterKeys( starter.sourcesMap, resolvedFilePath ) );
        if( filtered.length )
        return starter._sourceInclude( parentSource, basePath, filtered );
      }
      else
      {
        let childSource = starter._sourceForInclude.apply( starter, arguments );
        if( childSource )
        return starter._sourceIncludeCall( parentSource, childSource, filePath );
      }

      return starter._includeAct( parentSource, basePath, filePath );
      // if( starter.interpreter === 'browser' )
      // return starter._includeAct( parentSource, basePath, filePath );
      // else
      // return starter._includeAct( parentSource, basePath, filePath );

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

    // xxx
    // if( starter.interpreter === 'browser' )
    // {
    //   return starter._sourceResolveAct( parentSource, basePath, filePath );
    // }
    // else
    // {
    //   return starter._sourceResolveAct( parentSource, basePath, filePath );
    // }

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
      _starter_.setup._setupUncaughtErrorHandler2();
      _starter_.setup._setupUncaughtErrorHandler9();
    }

    // if( _starter_.proceduring )
    // _starter_.Procedure.NativeWatchingEnable();

    this._SetupAct();

    // if( Config.interpreter === 'njs' )
    // this._njsSetup();
    // else
    // this._broSetup();

    this._inited = 1;
  }

;
  

  let Extension =
  {

    SourceFile,

    _sourceMake,
    _sourceIncludeCall,
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

;

/* */  /* end of starter */ })();


/* */  if( !_global_._libraryFilePath_ )
/* */  _global_._libraryFilePath_ = '/';
/* */  if( !_global_._libraryDirPath_ )
/* */  _global_._libraryDirPath_ = '/';
/* */  /* begin of file Index_js */ ( function Index_js() { function Index_js_naked() { console.log( 'Index.js:begin' );

debugger;
var dir = require( './dir/**/**.js' );

console.log( `` );
console.log( `dir.length : ${dir.length}` );
console.log( `dir[ 0 ] : ${dir[ 0 ]}` );
console.log( `dir[ 1 ] : ${dir[ 1 ]}` );
debugger;

console.log( `` );
console.log( `Index.js` );
if( typeof _filePath_ !== 'undefined' )
console.log( `_filePath_ : ${_filePath_}` );
if( typeof _dirPath_ !== 'undefined' )
console.log( `_dirPath_ : ${_dirPath_}` );
console.log( `__filename : ${__filename}` );
console.log( `__dirname : ${__dirname}` );
console.log( `module : ${typeof module}` );
console.log( `module.parent : ${typeof module.parent}` );
console.log( `exports : ${typeof exports}` );
console.log( `require : ${typeof require}` );
if( typeof include !== 'undefined' )
console.log( `include : ${typeof include}` );
if( typeof _starter_ !== 'undefined' )
console.log( `_starter_.interpreter : ${_starter_.interpreter}` );
console.log( `` );

console.log( 'Index.js:end' );

/* */    };
/* */  let _filePath_ = _starter_._pathResolveLocal( null, _libraryFilePath_, './Index.js' );
/* */  let _dirPath_ = _starter_._pathResolveLocal( null, _libraryFilePath_, '.' );
/* */  let __filename = _filePath_;
/* */  let __dirname = _dirPath_;
/* */  let module = _starter_._sourceMake( _filePath_, _dirPath_, Index_js_naked );
/* */  let exports = module.exports;
/* */  let require = module.include;
/* */  let include = module.include;

/* */  /* end of file Index_js */ })();

/* */  /* begin of file Dep1_js */ ( function Dep1_js() { function Dep1_js_naked() { console.log( 'Dep1.js:begin' );

console.log( `` );
console.log( `Dep1.js` );
if( typeof _filePath_ !== 'undefined' )
console.log( `_filePath_ : ${_filePath_}` );
if( typeof _dirPath_ !== 'undefined' )
console.log( `_dirPath_ : ${_dirPath_}` );
console.log( `__filename : ${__filename}` );
console.log( `__dirname : ${__dirname}` );
console.log( `module : ${typeof module}` );
console.log( `module.parent : ${typeof module.parent}` );
console.log( `exports : ${typeof exports}` );
console.log( `require : ${typeof require}` );
if( typeof include !== 'undefined' )
console.log( `include : ${typeof include}` );
if( typeof _starter_ !== 'undefined' )
console.log( `_starter_.interpreter : ${_starter_.interpreter}` );
console.log( `` );

module.exports = 'Dep1';

console.log( 'Dep1.js:end' );

/* */    };
/* */  let _filePath_ = _starter_._pathResolveLocal( null, _libraryFilePath_, './dir/Dep1.js' );
/* */  let _dirPath_ = _starter_._pathResolveLocal( null, _libraryFilePath_, './dir' );
/* */  let __filename = _filePath_;
/* */  let __dirname = _dirPath_;
/* */  let module = _starter_._sourceMake( _filePath_, _dirPath_, Dep1_js_naked );
/* */  let exports = module.exports;
/* */  let require = module.include;
/* */  let include = module.include;

/* */  /* end of file Dep1_js */ })();

/* */  /* begin of file Dep2_js */ ( function Dep2_js() { function Dep2_js_naked() { console.log( 'Dep2.js:begin' );

console.log( `` );
console.log( `Dep2.js` );
if( typeof _filePath_ !== 'undefined' )
console.log( `_filePath_ : ${_filePath_}` );
if( typeof _dirPath_ !== 'undefined' )
console.log( `_dirPath_ : ${_dirPath_}` );
console.log( `__filename : ${__filename}` );
console.log( `__dirname : ${__dirname}` );
console.log( `module : ${typeof module}` );
console.log( `module.parent : ${typeof module.parent}` );
console.log( `exports : ${typeof exports}` );
console.log( `require : ${typeof require}` );
if( typeof include !== 'undefined' )
console.log( `include : ${typeof include}` );
if( typeof _starter_ !== 'undefined' )
console.log( `_starter_.interpreter : ${_starter_.interpreter}` );
console.log( `` );

module.exports = 'Dep2';

console.log( 'Dep2.js:end' );

/* */    };
/* */  let _filePath_ = _starter_._pathResolveLocal( null, _libraryFilePath_, './dir/Dep2.js' );
/* */  let _dirPath_ = _starter_._pathResolveLocal( null, _libraryFilePath_, './dir' );
/* */  let __filename = _filePath_;
/* */  let __dirname = _dirPath_;
/* */  let module = _starter_._sourceMake( _filePath_, _dirPath_, Dep2_js_naked );
/* */  let exports = module.exports;
/* */  let require = module.include;
/* */  let include = module.include;

/* */  /* end of file Dep2_js */ })();

/* */  /* begin of file Dep3_s */ ( function Dep3_s() { function Dep3_s_naked() { console.log( 'Dep3.s:begin' );

console.log( `` );
console.log( `Dep3.s` );
if( typeof _filePath_ !== 'undefined' )
console.log( `_filePath_ : ${_filePath_}` );
if( typeof _dirPath_ !== 'undefined' )
console.log( `_dirPath_ : ${_dirPath_}` );
console.log( `__filename : ${__filename}` );
console.log( `__dirname : ${__dirname}` );
console.log( `module : ${typeof module}` );
console.log( `module.parent : ${typeof module.parent}` );
console.log( `exports : ${typeof exports}` );
console.log( `require : ${typeof require}` );
if( typeof include !== 'undefined' )
console.log( `include : ${typeof include}` );
if( typeof _starter_ !== 'undefined' )
console.log( `_starter_.interpreter : ${_starter_.interpreter}` );
console.log( `` );

module.exports = 'Dep2';

console.log( 'Dep3.s:end' );

/* */    };
/* */  let _filePath_ = _starter_._pathResolveLocal( null, _libraryFilePath_, './dir/Dep3.s' );
/* */  let _dirPath_ = _starter_._pathResolveLocal( null, _libraryFilePath_, './dir' );
/* */  let __filename = _filePath_;
/* */  let __dirname = _dirPath_;
/* */  let module = _starter_._sourceMake( _filePath_, _dirPath_, Dep3_s_naked );
/* */  let exports = module.exports;
/* */  let require = module.include;
/* */  let include = module.include;

/* */  /* end of file Dep3_s */ })();


/* */  _starter_._sourceInclude( null, _libraryFilePath_, './Index.js' );


/* */  /* end of library Out_js */ })()
