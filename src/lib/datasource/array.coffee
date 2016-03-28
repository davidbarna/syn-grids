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
    return this

  ###
   * Returns data according to configured options
   * @return {Promise}
  ###
  get: ->
    new Promise ( resolve, reject ) =>
      data = []
      keys = @keys()
      return resolve( @_data ) if !keys

      # Filter required keys
      for obj in @_data
        _obj = {}
        _obj[key] = obj[key] || '' for key in keys
        data.push( _obj )

      resolve( data )


module.exports = GridDatasourceArray
