###
 * GridHeadConfig
 * Processes raw grid config to serve info about head config
 * of the grid
 *
 * Example of use:
 *
 * ```coffeescript
 * headConfig = new GridHeadConfig()
 * headConfig.setConfig( { name: label: 'Name', surname: label: 'Surname' } )
 *
 * console.log headConfig.labels()
 * #output: [ 'Name', 'Surname' ]
 * ```
###
_ = require( 'lodash' )

class GridHeadConfig

  constructor: ( config ) ->
    @setConfig( config ) if !!config

  ###
   * Sets grid head config node
   * @param {Object} @_config
  ###
  setConfig: ( @_config ) ->
    return this

  ###
   * Returns head keys
   * @returns {string[]}
  ###
  keys: ->
    return _.keys( @_config )

  ###
   * Returns head labels
   * @returns {string[]}
  ###
  labels: ->
    row = {}
    for key, obj of @_config
      row[key] = obj.label || ''



module.exports = GridHeadConfig
