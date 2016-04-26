###
 * GridCellsConfig
 * Manages config of grids' cells
###
_ = require( 'lodash' )

class GridCellsConfig

  constructor: ( config ) ->
    @setConfig( config ) if !!config

  ###
   * Sets grid head config node
   * @param {Object} @_config
  ###
  setConfig: ( config ) ->
    @_config = _.clone( config )
    return this

  get: ->
    return @_config



module.exports = GridCellsConfig
