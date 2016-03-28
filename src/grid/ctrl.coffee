###
 * GridCtrl
 * Displays data as grid.
 *
 *  Expects a config with the following structure:
 *
 * | Name                 | Type      | Description                  |
 * |----------------------|-----------|------------------------------|
 * | head                 | {Object}  | Config of grid's head        |
 * | head.foo             | {Object}  | Config options of the column |
 * | head.foo.label       | {String}  | Name of the column           |
 * | [data]               | {Object}  | Data rows to display         |
###
class GridCtrl

  $ = require( 'jqlite' )
  DomRowsBuilder = require( '../lib/dom/rows/builder' )
  GridHeadConfig = require( '../lib/head/config' )
  GridDatasourceArray = require( '../lib/datasource/array' )

  HEADER_ELEMENT: 'thead'
  BODY_ELEMENT: 'tbody'

  ###
   * @constructor
   * @param  {DOM Element} @element jqLite instance
  ###
  constructor: ( @element ) ->
    @_head = new GridHeadConfig()
    @_rowsView = new DomRowsBuilder()
    @_headView = new DomRowsBuilder()

  ###
   * Sets config of current grid
   * @param {Object @_config [description]
   * @param {Object} @_config.head - Head config
   * @param {Object[]} @_config.data - Data rows to display
  ###
  setConfig: ( @_config ) ->
    @_head.setConfig( @_config.head ) if !!@_config.head
    return this

  ###
   * Sets data source to use
   * @param {GridDatasourceAbstract} @_datasource
  ###
  setDatasource: ( @_datasource ) ->
    return this

  ###
   * Configs elements of DOM and datasource
   * @return {Promise}
  ###
  init: ->
    @_headView
      .setTags( null, 'TH' )
      .setTarget( @element.find( @HEADER_ELEMENT ) )
    @_rowsView
      .setTarget( @element.find( @BODY_ELEMENT ) )

    datasource = new GridDatasourceArray()
    datasource.data( @_config.data )
    @setDatasource( datasource )

    return @update()

  ###
   * Updates element with data rows
   * @return {Promise}
  ###
  update: ->
    @_datasource
      .keys( @_head.keys() )
      .get()
      .then ( data ) =>
        @_rowsView.setRows( data )
        @_headView.setRows( [ @_head.labels() ] )
        return data

  ###*
   * Destroys component and removes added DOM elements
   * @return {this}
  ###
  destroy: ->
    @_headView?.destroy()
    @_rowsView?.destroy()
    return this



module.exports = GridCtrl
