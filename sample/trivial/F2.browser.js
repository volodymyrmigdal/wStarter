
console.log( `${__filename} start` )

function routine()
{
  console.log( `${__filename}::routine arguments:`, ... arguments )
}

module.exports = { routine }

console.log( `${__filename} end` )
