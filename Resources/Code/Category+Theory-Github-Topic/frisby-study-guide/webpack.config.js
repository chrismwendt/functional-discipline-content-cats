const path = require('path')
const webpack = require('webpack')

const config = {
  entry: ['./arc/index.js'],
  devtool: 'srouce-map',
  output: {
    path: __dirname + '/build',
    filename: 'bundle.js',
    libraryTarget: 'commonjs2'
  },
  context: __dirname + '/src',
  watch: true,
  module: {
    loaders: [
      { test: [/\.jsx?$/], loader: 'eslint-loader', exclude: /node_modules/ },
      {
        test: /\.js$/,
        exclude: /node_modules/,
        include: path.join(__dirname, 'src'),
        loaders: ['babel']
      }
    ]
  },
  resolve: {
    extensions: ['js', 'jsx', 'json', 'es6']
  }
}
module.exports = config
