###
 * GridHeadConfig
 * Processes raw grid config to serve info about head config
 * of the grid
 *
 * Example of use:
 *
 * ```coffeescript
 * headConfig = new GridHeadConfig()
 * headConfig.setConfig( {
 * 	name: label: 'Name',
 * 	surname: label: 'Surname', sort: true
 * 	} )
 *
 * console.log headConfig.labels()
 * #output: [ 'Name', 'Surname' ]
 * console.log headConfig.sortKeys()
 * #output: [ 'surname' ]
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
  setConfig: ( config ) ->
    @_config = _.clone( config )
    for key, head of @_config
      head.sort = false if _.isUndefined( head.sort )
    return this

  ###
   * Returns head keys
   * @returns {string[]}
  ###
  keys: ->
    return _.keys( @_config )

  ###
   * Returns keys which have sort option set to true
   * @return {string[]}
  ###
  sortKeys: ->
    keys = []
    for key, head of @_config
      keys.push( key ) if head.sort is true
    return keys

  ###
   * Returns head labels
   * @returns {string[]}
  ###
  labels: ->
    row = {}
    for key, obj of @_config
      row[key] = obj.label || ''
    return row



module.exports = GridHeadConfig
