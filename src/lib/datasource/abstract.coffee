###
 * GridDatasourceAbstract
 * Base config functions needed for any grid data source
 * Each function sets an option that must addect get() output
###
class GridDatasourceAbstract

  ###*
   * Set the keys (property names) tha tare expected on get
   * @param  {string[]} keys Array of property names
   * @return {this|string[]} Returns keys if called without arguments
  ###
  keys: ( keys ) ->
    return @_keys if typeof keys is 'undefined'
    @_keys = keys
    return this

  ###
   * Function to implement on class extensions
   * @return {Promise} Must always return promise resolved by data
  ###
  get: ->
    throw new Error( '#get method no implemented in grid datasource' )



module.exports = GridDatasourceAbstract
