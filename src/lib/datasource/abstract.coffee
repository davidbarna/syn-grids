###
 * GridDatasourceAbstract
 * Base config functions needed for any grid data source
 * Each function sets an option that must addect get() output
###
_ = require( 'lodash' )

class GridDatasourceAbstract

  constructor: ->
    @_sort = {}
    @skip( 0 )
    @limit( Infinity )
    @multiSort( true )

  ###*
   * Get/Set keys (property names) tha tare expected on get
   * @param  {string[]} keys Array of property names
   * @returns {this|string[]} Returns keys if called without arguments
  ###
  keys: ( keys ) ->
    return @_keys if typeof keys is 'undefined'
    @_keys = keys
    return this

  ###
   * Get/Set number of results returned from a query
   * @param  {number} limit
   * @returns {this|number}
  ###
  limit: ( limit ) ->
    return @_limit if typeof limit is 'undefined'
    @_limit = limit
    return this

  ###
   * Get/Set number of items to skip
   * @param  {number} skip
   * @returns {this|number}
  ###
  skip: ( skip ) ->
    return @_skip if typeof skip is 'undefined'
    @_skip = skip
    return this

  ###
   * Adds sorting properties
   * Sort value is toggled is `ascending` param is not defined
   * @param  {string} key Name of the column to sort by
   * @param  {Boolean} ascending Ascending or Descending
   * @return {GridDatasourceAbstract|Object} `this` | { key1: true, key2: false}
  ###
  sort: ( key, ascending ) ->
    return @_sort if typeof key is 'undefined'
    if _.isNil( ascending )
      ascending = if !!@_sort[key] then !@_sort[key] else true
    @_sort = {} if !@multiSort()
    @_sort[key] = ascending
    return this

  ###
   * Removes sorting property
   * @param  {string} key Name of the column to stop sorting by
   * @return {GridDatasourceAbstract} `this`
  ###
  unsort: ( key ) ->
    delete @_sort[key]
    return this

  ###
   * Gets/Sets multisort option
   * If set to true, sort option is unique so data can be sorted
   * only by one key, not more than one by default.
   * @param  {[type]} multiSort [description]
   * @return {[type]}           [description]
  ###
  multiSort: ( multiSort ) ->
    return @_multiSort if typeof multiSort is 'undefined'
    @_multiSort = multiSort
    return this

  ###
   * Returns total number of rows/items
   * @returns {Promise} Resolve with total number of rows
  ###
  count: ->
    throw new Error( '#count method no implemented in grid datasource' )

  ###
   * Function to implement on class extensions
   * @returns {Promise} Must always return promise resolved by data
  ###
  get: ->
    throw new Error( '#get method no implemented in grid datasource' )



module.exports = GridDatasourceAbstract
