###
 * DomRowsBuilder
 * Builds a row>cells DOM structure and updates it.
 *
 * Example of use:
 *
 * ```coffeescript
 * rows = new DomRowsBuilder()
 * rows
 * 	.setTags( 'TR', 'TH')
 * 	.setTarget( $( '#my-table thead' ) )
 * 	.setRows( [ { name: 'Name', surname: 'Surname'} ] )
 * ```
###

$ = require( 'jqlite' )

class DomRowsBuilder

  # Default row tag name
  ROW_TAGNAME: 'TR'

  # Default cell tag name
  CELL_TAGNAME: 'TD'

  ###
   * @constructor
  ###
  constructor: ( element ) ->
    @_rows = null
    @setTags( @ROW_TAGNAME, @CELL_TAGNAME )
    @setTarget( element ) if !!element

  ###
   * Set DOM tag names to use
   * @param {string} @_rowTag  = @ROW_TAGNAME  Rows' tag name
   * @param {string} @_cellTag = @CELL_TAGNAME Cells' tag name
  ###
  setTags: ( @_rowTag = @ROW_TAGNAME, @_cellTag = @CELL_TAGNAME ) ->
    return this

  ###
   * Set target onto adding and removing rows.
   * @param {DOM element} target Instance of jQuery or jqLite
  ###
  setTarget: ( target ) ->
    @_target = target
    @_targetParent = @_target.parent()
    return this

  ###
   * Create rows and add them to DOM target
   * @param {Object[]} data
  ###
  setRows: ( data ) ->
    @_rows = []
    @_cells = {}

    for idx, obj of data
      row = document.createElement( @_rowTag )
      for key, value of obj
        className = 'syn-grid-cell--' + key
        cell = document.createElement( @_cellTag )
        cell.classList.add( className )
        cell.innerHTML = value
        row.appendChild( cell )
        @_cells[key] ?= { elements: [] }
        @_cells[key].elements.push( $( cell ) )
      @_rows.push( row )

    return this

  ###
   * Modifies cells with new buttons sub elements
   * according con options
   * @param {Object} options See properties in @applyElementOptions
   * @param {array} options.buttons Sub elements with config
  ###
  applyCellOptions: ( options ) ->
    return this if !@_cells
    
    for key, opts of options.buttons
      continue if !@_cells[key]

      for cell in @_cells[key].elements
        @applyElementOptions( cell, key, options )

        for optionName, optionAttrs of opts
          optionButton = $( document.createElement( 'BUTTON' ) )
          optionAttrs.classes ?= []
          optionAttrs.classes.push( 'syn-grid-cell-option--' + optionName )
          @applyElementOptions( optionButton, key, optionAttrs )
          cell.append( optionButton )

    return this

  ###
   * Parses options and sets corresponding attributes on element
   * @param  {jqLite} element DOM Element onto apply options
   * @param  {string} key Cell key (label) of the element
   * @param  {Object} opts Options to apply
   * @param  {array|null} opts.classes Css classes to add to element
   * @param  {string} opts.content Html content to add to the element
   * @param  {Object} opts.on List of events to bind
   * @param  {Function} opts.on.eventName Event callback
   * @return {undefined}
  ###
  applyElementOptions: ( element, key, opts ) ->
    element.addClass( opts.classes.join( ' ' ) ) if !!opts.classes
    element.html( opts.content )

    return if !opts.on
    for eventName, handler of opts.on
      element.on( eventName, ( event ) -> handler( event, key ) )

  ###
   * Returns DOM cell elements corresponding to a certain key
   * @param  {string} key
   * @return {jqLite[]} Array of jqLite instances
  ###
  getCells: ( key ) ->
    return [] if !@_cells[key]
    return @_cells[key].elements

  ###
   * Adds given DOM Elements to target element
   * @param  {DOM Element[]} rows Array of DOM elements
   * @returns {DomRowsBuilder} `this`
  ###
  appendToTarget: ->
    @_target.remove().html( '' )
    @_target.append( $( @_rows ) )
    @_targetParent.append( @_target )
    return this

  ###
   * Removes all added rows
   * @returns {DomRowsBuilder} `this`
  ###
  destroy: ->
    $( @_rows ).remove()
    @_rows = @_cells = null
    return this



module.exports = DomRowsBuilder
