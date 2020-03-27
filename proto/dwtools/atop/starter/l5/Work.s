( function _Work_s_() {

'use strict';

let Open;

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

  work.pathsForm();
  work.fileFind();
  work.servletOpen();

  if( work.opening )
  {
    work.applicationOpen();
  }

  return work;
}

//

function pathsForm()
{
  let work = this;
  let starter = work.starter;
  let fileProvider = starter.fileProvider;
  let path = starter.fileProvider.path;
  let logger = starter.logger;

  work.basePath = path.resolve( work.basePath || '.' );
  work.entryPath = path.resolve( work.basePath, work.entryPath );
  work.allowedPath = path.resolve( work.basePath, work.allowedPath );
  if( work.templatePath )
  work.templatePath = path.resolve( work.basePath, work.templatePath );

}

//

function fileFind()
{
  let work = this;
  let starter = work.starter;
  let fileProvider = starter.fileProvider;
  let path = starter.fileProvider.path;
  let logger = starter.logger;

  let filter = { filePath : work.entryPath, basePath : work.basePath };
  let found = _.fileProvider.filesFind
  ({
    filter,
    mode : 'distinct',
    mandatory : 0,
    withDirs : 0,
    withDefunct : 0,
  });

  if( !found.length )
  throw _.errBrief( `Found no ${work.entryPath}` );
  if( found.length !== 1 )
  throw _.errBrief( `Found ${found.length} of ${work.entryPath}, but expects single file.` );

  work.entryPath = found[ 0 ].absolute;

}

//

function servletOpen()
{
  let work = this;
  let starter = work.starter;

  _.assert( work.servlet === null );

  work.servlet = starter.httpOpen
  ({
    basePath : work.basePath,

    allowedPath : work.allowedPath,
    templatePath : work.templatePath,
    loggingApplication : work.loggingApplication,
    loggingConnection : work.loggingConnection,

  });

  work.entryShortUri = _.uri.join( work.servlet.openPathGet(), _.path.relative( work.basePath, work.entryPath ) );
  work.entryFullUri = _.uri.join( work.entryShortUri, '?entry:1' );

}

//

function applicationOpen()
{
  let work = this;
  let starter = work.starter;

  if( !Open )
  Open = require( 'open' );
  let opts = Object.create( null );
  if( work.headless )
  opts.app = [ 'chrome', '--headless', '--disable-gpu', '--remote-debugging-port=9222' ];

  _.Consequence.Try( () => Open( work.entryFullUri, opts ) )
  .finally( ( err, process ) =>
  {
    work.process = process;
    if( err )
    {
      err = _.err( err );
      if( !work.error )
      work.error = err;
      return logger.error( _.errOnce( err ) ) || null;
    }
    work.process.on( 'exit', () =>
    {
      // logger.log( work.process );
      // logger.log( `Finished ${_.ct.format( work.entryPath, 'path' )}` );
    });
    if( starter.verbosity >= 3 )
    {
      if( starter.verbosity >= 7 )
      logger.log( work.process );
      if( starter.verbosity >= 5 )
      logger.log( `Started ${_.ct.format( work.entryPath, 'path' )}` );
    }
    _.time.begin( 1000, () => process.kill( 'SIGTERM' ) /* xxx qqq : use _.process.terminate after fixing it */ );
    return process;
  });

}

// --
// relations
// --

let Composes =
{

  basePath : null,
  entryPath : null,
  allowedPath : null,
  templatePath : null,
  entryShortUri : null,
  entryFullUri : null,

  opening : 1,
  headless : 0,
  loggingApplication : 1,
  loggingConnection : 0,

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

  pathsForm,
  fileFind,
  servletOpen,
  applicationOpen,

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
