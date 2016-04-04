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
  constructor: ->
    @setTags( @ROW_TAGNAME, @CELL_TAGNAME )

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
    @appendToTarget( @getRows( data ) )

  ###
   * Creates DOM rows base on given data
   * @param  {Object[]} data
   * @returns {DOM Element[]} Array of DOM elements
  ###
  getRows: ( data ) ->
    rows = []
    for obj in data
      row = document.createElement( @_rowTag )
      for key, value of obj
        cell = document.createElement( @_cellTag )
        cell.innerHTML = value
        row.appendChild( cell )
      rows.push( row )
    return rows

  ###
   * Adds given DOM Elements to target element
   * @param  {DOM Element[]} rows Array of DOM elements
   * @returns {DomRowsBuilder} `this`
  ###
  appendToTarget: ( rows ) ->
    @_rows = $( rows )

    @_target.remove().html( '' )
    @_target.append( @_rows )
    @_targetParent.append( @_target )
    return this

  ###
   * Removes all added rows
   * @returns {DomRowsBuilder} `this`
  ###
  destroy: ->
    @_rows?.remove()
    @_rows = null
    return this



module.exports = DomRowsBuilder
