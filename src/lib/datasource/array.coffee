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
   * @returns {this|Object[]}
  ###
  data: ( data ) ->
    return @_data if typeof data is 'undefined'
    @_data = data
    @_length = @_data.length
    return this

  ###
   * Returns total number of rows/items
   * @returns {Promise} Resolve with total number of rows
  ###
  count: ->
    new Promise ( resolve, reject ) =>
      resolve( @_length )
      return @_length

  ###
   * Returns data according to configured options
   * @returns {Promise}
  ###
  get: ->
    new Promise ( resolve, reject ) =>
      _data = _.clone( @_data )
      result = []
      keys = @keys() || _.keys( _data[0] )

      _data = sortBy( _data, @sort() )
      # Filter required keys
      startIdx = @skip()
      lastIdx = startIdx + @limit()
      while startIdx < lastIdx and !!_data[startIdx]
        obj = _data[startIdx]
        _obj = {}
        _obj[key] = obj[key] || '' for key in keys
        result.push( _obj )
        startIdx++

      resolve( result )

  ###
   * Sorts array data by several properties
   * @param  {array} data
   * @param  {Object} sort { name: true, surname: false }
   * @return {array} Sorted data
  ###
  sortBy = ( data, sort ) ->
    sortKeys = _.keys( sort )
    return data if sortKeys.length is 0

    sortValues = []
    for k, v of sort
      value = if v is true then 'asc' else 'desc'
      sortValues.push( value )

    return _.orderBy( data, sortKeys, sortValues )



module.exports = GridDatasourceArray
