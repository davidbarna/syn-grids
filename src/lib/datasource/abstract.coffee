###
 * GridDatasourceAbstract
 * Base config functions needed for any grid data source
 * Each function sets an option that must addect get() output
###
class GridDatasourceAbstract

  constructor: ->
    @skip( 0 )
    @limit( Infinity )

  ###*
   * Get/Set keys (property names) tha tare expected on get
   * @param  {string[]} keys Array of property names
   * @return {this|string[]} Returns keys if called without arguments
  ###
  keys: ( keys ) ->
    return @_keys if typeof keys is 'undefined'
    @_keys = keys
    return this

  ###
   * Get/Set number of results returned from a query
   * @param  {number} limit
   * @return {this|number}
  ###
  limit: ( limit ) ->
    return @_limit if typeof limit is 'undefined'
    @_limit = limit
    return this

  ###
   * Get/Set number of items to skip
   * @param  {number} skip
   * @return {this|number}
  ###
  skip: ( skip ) ->
    return @_skip if typeof skip is 'undefined'
    @_skip = skip
    return this

  ###
   * Returns total number of rows/items
   * @return {Promise} Resolve with total number of rows
  ###
  count: ->
    throw new Error( '#count method no implemented in grid datasource' )

  ###
   * Function to implement on class extensions
   * @return {Promise} Must always return promise resolved by data
  ###
  get: ->
    throw new Error( '#get method no implemented in grid datasource' )



module.exports = GridDatasourceAbstract
