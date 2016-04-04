HeadConfig = require( '../lib/head/config' )
DatasourceArray = require( '../lib/datasource/array' )
Pagination = require( '../lib/pagination/ctrl' )
DomRowsBuilder = require( '../lib/dom/rows/builder' )

###
 * # GridCtrl
 * Displays data as grid.
 *
 * Expects a config with the following structure:
 *
 * | Name | Type | Description |
 * |------|------|-------------|
 * | head | {Object} | Config of grid's head |
 * | head.foo | {Object} | Config options of the column |
 * | head.foo.label | {String} | Name of the column |
 * | [pagination] | {Object} | Pagination config |
 * | [pagination].buttons | {Number} | Number of page buttons to display ( default: 10 ) |
 * | [pagination].rowsPerPage | {Number} | Rows to display per page. ( default: 20 ) |
 * | [pagination].startPage | {Number} | First page to display ( default: 0 ) |
 * | [data] | {Object[]} | Data rows to display |
 *
###
class GridCtrl

  HEADER_ELEMENT: 'thead'
  BODY_ELEMENT: 'tbody'
  NAV_ELEMENT: 'nav'

  ###
   * @constructor
   * @param  {DOM Element} @element jqLite instance
  ###
  constructor: ( @element ) ->
    @_head = new HeadConfig()
    @_pagination = new Pagination( @element.find( @NAV_ELEMENT ) )
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
    @_pagination.setOptions( @_config.pagination )
    return this

  ###
   * Sets data source to use
   * @param {GridDatasourceAbstract} @_datasource
  ###
  setDatasource: ( @_datasource ) ->
    return this

  ###
   * Configs elements of DOM and datasource
   * @returns {Promise}
  ###
  init: ->
    @_headView
      .setTarget( @element.find( @HEADER_ELEMENT ) )
      .setTags( null, 'TH' )
    @_rowsView
      .setTarget( @element.find( @BODY_ELEMENT ) )
    @_pagination
      .on( @_pagination.CHANGE, @updateRows )
      .init()
    @_datasource = new DatasourceArray()
      .data( @_config.data )

    # Count is obtain to config pagination
    @_datasource.count()
      .then ( count ) =>
        @_pagination.setCount( count )

  ###
   * Updates grid element with data rows
   * @returns {Promise}
  ###
  updateRows: =>
    if @_config.pagination isnt false
      @_datasource
        .limit( @_pagination.getLimit() )
        .skip( @_pagination.getSkipped() )

    @_datasource
      .keys( @_head.keys() )
      .get()
      .then ( data ) =>
        @_rowsView.setRows( data )
        @_headView.setRows( [ @_head.labels() ] )

  ###
   * Destroys component and removes added DOM elements
   * @returns {GridCtrl} `this`
  ###
  destroy: ->
    @_headView?.destroy()
    @_rowsView?.destroy()
    @_pagination?.destroy()
    return this



module.exports = GridCtrl
