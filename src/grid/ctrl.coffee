HeadConfig = require( '../lib/head/config' )
CellsConfig = require( '../lib/cells/config' )
DatasourceArray = require( '../lib/datasource/array' )
Pagination = require( '../lib/pagination/ctrl' )
RowBuilder = require( '../lib/dom/rows/builder' )
Header = require( '../lib/head/ctrl' )

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
    @_cells = new CellsConfig()
    @_datasource = new DatasourceArray()
    @_pagination = new Pagination( @element.find( @NAV_ELEMENT ) )
    @_rows = new RowBuilder( @element.find( @BODY_ELEMENT ) )
    @_header = new Header( @element.find( @HEADER_ELEMENT ), @_head, @_datasource )

  ###
   * Sets config of current grid
   * @param {Object} @_config
   * @param {Object} @_config.head - Head config
   * @param {Object[]} @_config.data - Data rows to display
  ###
  setConfig: ( @_config = {} ) ->
    @_head.setConfig( @_config.head ) if !!@_config.head
    @_cells.setConfig( @_config.cells ) if !!@_config.cells
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
    @_pagination
      .on( @_pagination.CHANGE, @updateRows )
      .init()
    @_datasource
      .multiSort( false )
      .data( @_config.data )
    @_header
      .on( @_header.SORT, @updateRows )
      .init()

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
        @_rows
          .setRows( data, @_cells.get() )
          .appendToTarget()

  ###
   * Destroys component and removes added DOM elements
   * @returns {GridCtrl} `this`
  ###
  destroy: ->
    @_pagination.removeListener( @_pagination.CHANGE, @updateRows )
    @_header.removeListener( @_header.SORT, @updateRows )

    @_pagination?.destroy()
    @_rows?.destroy()
    @_datasource?.destroy?()
    @_header?.destroy()

    return this


module.exports = GridCtrl
