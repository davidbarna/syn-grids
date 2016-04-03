###
 * GridDatasourceArray
 * A datasource base on a plain array of objects
 *
 * Example of use:
 *
 * ```coffeescript
 * datasource = new GridDatasourceArray()
 * datasource
 * 	.data( [ { name: 'David', surname: 'Smith' } ] )
 * 	.keys( [ 'name' ] )
 * 	.get ( data ) ->
 * 		console.log data
 * ```
###

_ = require( 'lodash' )
Promise = require( 'bluebird' )
Abstract = require( './abstract' )

class GridDatasourceArray extends Abstract

  ###
   * Set/get array of objects
   * @param  {Object[]} data
   * @return {this|Object[]}
  ###
  data: ( data ) ->
    return @_data if typeof data is 'undefined'
    @_data = data
    @_length = @_data.length
    return this

  ###
   * Returns total number of rows/items
   * @return {Promise} Resolve with total number of rows
  ###
  count: ->
    new Promise ( resolve, reject ) =>
      resolve( @_length )
      return @_length

  ###
   * Returns data according to configured options
   * @return {Promise}
  ###
  get: ->
    new Promise ( resolve, reject ) =>
      data = []
      keys = @keys() || _.keys( @_data[0] )

      # Filter required keys
      startIdx = @skip()
      lastIdx = startIdx + @limit()
      while startIdx < lastIdx and !!@_data[startIdx]
        obj = @_data[startIdx]
        _obj = {}
        _obj[key] = obj[key] || '' for key in keys
        data.push( _obj )
        startIdx++

      resolve( data )


module.exports = GridDatasourceArray
