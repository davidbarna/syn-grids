EventsEmitter = require( 'events' )

###
 * # PaginationCtrl
 * Creates a pagination element and controls it.
 *
 *
 * Expects a config with the following structure:
 *
 * | Name | Type | Description |
 * |------|------|-------------|
 * | buttons | {Number} | Number of page buttons to display ( default: 10 ) |
 * | rowsPerPage | {Number} | Rows to display per page. ( default: 20 ) |
 * | startPage | {Number} | First page to display ( default: 0 ) |
 *
 * ## Events
 *
 * | CONSTANT.argument  | Description |
 * |--------------------| -------------|
 * | CHANGE | When page number is changed by user |
 * | CHANGE.current  | New page number |
 * | CHANGE.last | Number of last page |
 *
 * **Example of use**
 *
 * ```coffeescript
 * pagination = new Pagination()
 * pagination
 *   .rowsCount( 205 )
 *   .rowsPerPage( 20 )
 *   .current( 2 )
 *
 * console.log pagination.last() # output: 20
 * ```
###
class Pagination extends EventsEmitter

  CHANGE: 'syn.grid.pagination.change'

  ###
   * Default options values
  ###
  DEFAULTS:
    buttons: 10
    rowsPerPage: 20
    startPage: 0

  ###
   * Emits Pagination.CHANGE event
   * Current page number and last page are passed as params.
   * @returns {Pagination} `this`
  ###
  _emitChange: ->
    @emit( @CHANGE, @_current, @last() )
    return this

  ###
   * @constructor
   * @param  {Object} options Pagination options
  ###
  constructor: ( options ) ->
    @_rowsCount = 0
    @options( options )

  ###
   * Sets all options with its defaults
   * @param {Object} opts
  ###
  options: ( opts = {} ) ->
    @buttons( opts.buttons || @DEFAULTS.buttons )
    @rowsPerPage( opts.rowsPerPage || @DEFAULTS.rowsPerPage )
    @current( opts.startPage || @DEFAULTS.startPage )
    return this

  ###
   * Set/Get number of buttons to display in navigation bar
   * @param  {number} num Number of buttons
   * @returns {number|this}
  ###
  buttons: ( num ) ->
    return @_buttons if typeof num is 'undefined'
    return if Number( num ) is @_buttons
    @_buttons = Number( num )
    @_emitChange()
    return this

  ###
   * Set/get rows total count
   * Needed to know number of possible pages.
   * @param  {Number} num Number of rows/items
   * @returns {number|this}
  ###
  rowsCount: ( num ) ->
    return @_rowsCount if typeof num is 'undefined'
    @_rowsCount = Number( num )
    @_emitChange()
    return this

  ###
   * Set/get number of rows per page.
   * Needed to know number of possible pages.
   * @param  {Number} num Number of rows/items per page
   * @returns {number|this}
  ###
  rowsPerPage: ( num ) ->
    return @_rowsPerPage if typeof num is 'undefined'
    @_rowsPerPage = Number( num )
    @_emitChange()
    return this

  ###
   * Set/Get current page number
   * Based on 0: third page would be number 2, not 3.
   * @param  {number} num Number of page to set
   * @returns {number|this}
  ###
  current: ( num ) ->
    return @_current if typeof num is 'undefined'

    # Do nothing if number is already current page
    num = Number( num )
    return if ( num is @_current )

    @_current = Number( num )
    @_emitChange()
    return this

  ###
   * Returns last page number.
   * Based on 0. If there is 20 pages, 19 will be returned
   * @returns {number}
  ###
  last: ->
    return Math.ceil( @_rowsCount / @_rowsPerPage ) - 1

  ###
   * Returns if there is a "previous" page to current
   * @returns {Boolean}
  ###
  hasPrev: ->
    @current() > 0

  ###
   * Returns if there is a "next" page to current
   * @returns {Boolean}
  ###
  hasNext: ->
    @current() < @last()

  ###
   * Returns next page number
   * @returns {number}
  ###
  next: ->
    return if @hasNext() then @_current + 1 else @last()

  ###
   * Returns previous page number
   * @returns {number}
  ###
  prev: ->
    return if @hasPrev() then @_current - 1 else 0



module.exports = Pagination
