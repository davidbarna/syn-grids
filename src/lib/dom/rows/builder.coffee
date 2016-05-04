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
   * @param {Object[]} data Array of rows' data
   * @param {Array} keys Keys which cells should be created
   * @param {Object} options = {} Options for DomRowBuilder
  ###
  setRows: ( data, keys, options = {} ) ->
    @_rows = []
    @_cells = {}

    for idx, obj of data
      row = document.createElement( @_rowTag )

      for idx, key of keys
        options[key] ?= {}
        $cell = $( document.createElement( @_cellTag ) )
        $cell.addClass( 'syn-grid-cell--' + key )

        # Both glogal and specific options are applied
        @applyElementOptions( $cell, key, options, obj )
        @applyElementOptions( $cell, key, options[key], obj )

        # Cell is registered
        row.appendChild( $cell[0] )
        @_cells[key] ?= { elements: [] }
        @_cells[key].elements.push( $cell )

      @_rows.push( row )


    return this

  ###
   * Parses options and sets corresponding attributes on element
   * @param  {jqLite} element DOM Element onto apply options
   * @param  {string} key Cell key (label) of the element
   * @param  {Object} data = {} Datsa of current item
   * @param  {Object} opts Options to apply
   * @param  {array|null} opts.classes Css classes to add to element
   * @param  {string} opts.content Html content to add to the element
   * @param  {Object} opts.on List of events to bind
   * @param  {Function} opts.on.eventName Event callback
   * @param  {Function} opts.filter.eventName Filter function to modify view value
   * @return {undefined}
  ###
  applyElementOptions: ( element, key, opts = {}, data = {} ) ->
    element.addClass( opts.classes.join( ' ' ) ) if !!opts.classes

    # Cell content
    cellContent = data[key] || opts.content || ''
    if (opts.filter)
      cellContent = opts.filter(key, cellContent, data )
    element.html( cellContent )

    # Events
    if !!opts.on
      for eventName, handler of opts.on
        element.on( eventName, ( event ) -> handler( event, key, data ) )

    # Secondary buttons of the cell
    @applyButtonsOptions( element, key, opts.buttons )

    return

  ###
   * Modifies cells with new buttons sub elements
   * according con options.
   * @param {array} buttons Sub elements with config
  ###
  applyButtonsOptions: ( element, key, buttons ) ->
    return this if !buttons

    for optionName, optionAttrs of buttons
      optionButton = $( document.createElement( 'BUTTON' ) )
      optionAttrs.classes ?= []
      optionAttrs.classes.push( 'syn-grid-cell-option--' + optionName )
      @applyElementOptions( optionButton, key, optionAttrs )
      element.append( optionButton )

    return this

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
