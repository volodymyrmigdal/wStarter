const webpack = require('webpack');
const path = require('path');
const nodeEnv = process.env.NODE_ENV;

let plugins = 
[
  new webpack.DefinePlugin
  ({
    'process.env': 
    {
      NODE_ENV: JSON.stringify( nodeEnv ),
    },
  }),
  new webpack.NamedModulesPlugin()
];

const entry = 
[
  'babel-polyfill',
  path.join( __dirname, '../server.js' )
]
module.exports = 
{
  mode: 'production',
  devtool: false,
  externals: [],
  name: 'server',
  plugins: plugins,
  target: 'node',
  entry: entry,
  output: 
  {
    publicPath: './',
    path: __dirname,
    filename: 'server-packed.js',
    libraryTarget: "commonjs2"
  },
  resolve: 
  {
    extensions: [ '.webpack-loader.js', '.web-loader.js', '.loader.js', '.js', '.jsx' ],
    modules: 
    [
      path.join( __dirname, '../node_modules' )
    ]
  },
  module: 
  {
    rules: 
    [
      {
        test: /\.(js|jsx)$/,
        loader: "babel-loader",
        options: 
        {
          babelrc: true
        }
      }
    ],
  },
  node: 
  {
    console: false,
    global: false,
    process: false,
    Buffer: false,
    __filename: false,
    __dirname: false,
  }
};