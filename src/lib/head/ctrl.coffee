EventsEmitter = require( 'events' )
RowBuilder = require( '../dom/rows/builder' )

###
 * # HeadCtrl
 * Creates grid's header row and sets events
 * to handle sorting and other header options.
###
class HeadCtrl extends EventsEmitter

  SORT: 'syn.grids.head.ctrl.change'
  ASC_CLASS: '--sort-asc'
  DESC_CLASS: '--sort-desc'

  ###
   * Updates header and launches a sort event
   * @param  {Event} event
   * @param  {string} key Header's key (name)
   * @return {undefined}
  ###
  _sortClickHandler: ( event, key ) =>
    event.stopPropagation()
    @datasource.sort( key )
    @update()
    @emit( @SORT, @datasource.sort())
    return

  ###
   * @constructor
   * @param  {jqLite} @element
   * @param  {GridHeadConfig} @config
   * @param  {GridDatasourceAbstract} @datasource
  ###
  constructor: ( @element, @config, @datasource ) ->
    @_view = new RowBuilder( @element )
    @_view.setTags( null, 'TH' )

  ###
   * Builds header cells with sort events handling
   * @return {HeadCtrl} `this`
  ###
  init: ->
    hasSortOption = false
    cellsOptions = buttons: {}

    for key in @config.sortKeys()
      hasSortOption = true
      cellsOptions.buttons[key] ?= {}
      cellsOptions.buttons[key].sort =
        content: require( '../../imgs/icon-sort.svg' )
        on: click: @_sortClickHandler

    cellsOptions.on = click: @_sortClickHandler if hasSortOption

    # DOM building
    @_view
      .setRows( [ @config.labels() ] )
      .applyCellOptions( cellsOptions )
    @update( @datasource.sort() )

    # After build, element is added to DOM
    @_view.appendToTarget()

    return this

  ###
   * Updates header cells according to current status
   * @return {HeadCtrl} `this`
  ###
  update: ->
    sort = @datasource.sort()
    for key in @config.keys()
      cells = @_view.getCells( key )

      # Sort classes update
      for cell in cells
        cell.toggleClass( @ASC_CLASS, sort[key] is true  )
        cell.toggleClass( @DESC_CLASS, sort[key] is false )

  ###
   * Destroys added DOM Elements
  ###
  destroy: ->
    @_view?.destroy()



module.exports = HeadCtrl
