$ = require( 'jqlite' )
EventsEmitter = require( 'events' )
Pagination = require( './index' )
PaginationUpdater = require( './updater' )

###
 * # GridPaginationView
 * Builds a view for a Pagination instance.
 *
 * Buttons are created and then updated on every
 * Pagination::CHANGE event.
 *
 * Keypress events are listenned to so the user
 * can navigate through pagination with the keyboard.
###
class GridPaginationView extends EventsEmitter

  TAGNAME: 'BUTTON'

  CLICK: 'syn.grid.pagination.view.click'

  PAGE_CLASS: '--pagination-page'
  PREV_CLASS: '--pagination-prev'
  NEXT_CLASS: '--pagination-next'
  KEYS:
    ARROW_LEFT: 37
    ARROW_RIGHT: 39

  ###
   * Emits a "page change" event
   * @param  {Event} event
   * @returns {undefined}
  ###
  _buttonClickHandler: ( event ) =>
    page = event.target.getAttribute( 'page' )
    @emit( @CLICK, page ) unless !page

  ###
   * On "<" or ">", it simulates a click on prev or next button
   * @param  {Event} event
   * @returns {undefined}
  ###
  _keyPressHandler: ( event ) =>
    @prev?.trigger( 'click' ).focus() if event.keyCode is @KEYS.ARROW_LEFT
    @next?.trigger( 'click' ).focus() if event.keyCode is @KEYS.ARROW_RIGHT

  ###
   * @constructor
   * @param  {Pagination} @pagination Pagination instance
  ###
  constructor: ( @pagination ) ->
    @element = $( document.createElement( 'SPAN' ) )
    @buttons = []
    @prev = @next = null
    @updater = new PaginationUpdater( @pagination, this )
    @element.on( 'keydown', @_keyPressHandler )

    @length( @pagination.buttons() )

  ###
   * Defines/Gets length of nav bar
   * @param  {number} length Number of buttons
   * @returns {GridPaginationView} `this`
  ###
  length: ( length ) ->
    return @_length if typeof length is 'undefined'
    return if length is @_length
    @_length = length
    @build( @_length )
    return this

  ###
   * Builds elements/buttons of the bar
   * If length has increased of reduced, the bar
   * is updated dinamically.
   * @param  {number} length Number of buttons
   * @returns {GridPaginationView} `this`
  ###
  build: ( length ) ->
    buttonsNum = length - 1
    @prev ?= @createButton( '<', @PREV_CLASS )

    for idx in [0..buttonsNum]
      @buttons[idx] ?= @createButton( '-', @PAGE_CLASS )

    # Surplus buttons are destroyed
    idx = length
    while !!@buttons[idx]
      @destroyButton( @buttons[idx] )
      idx++
    @buttons = @buttons.slice( 0, length )

    @next ?= @createButton( '>', @NEXT_CLASS )

    return this

  ###
   * Creates a new DOM element for a buttons with click event handler
   * @param  {string} text Text of the button
   * @param  {string} cssClass = @PAGE_CLASS CSS class
   * @returns {DOM Element} jqLite instance
  ###
  createButton: ( text, cssClass ) ->
    button = $( document.createElement( @TAGNAME ) )
      .addClass( cssClass )
      .html( text )
      .on( 'click', @_buttonClickHandler )
    @element.append( button )
    return button

  ###
   * Removes listeners and button from DOM
   * @param  {DOM Element} button jqLite instance
   * @returns {GridPaginationView} `this`
  ###
  destroyButton: ( button ) ->
    button
      .remove()
      .off( 'click', @_buttonClickHandler )
    return this

  ###
   * Removes all added DOM elements and events
   * @returns {GridPaginationView} `this`
  ###
  destroy: ->
    @element.off( 'keydown', @_keyPressHandler )
    @destroyButton( @prev )
    @destroyButton( @next )
    @destroyButton( button ) for button in @buttons
    @buttons = []
    @prev = @next = null

    return this


module.exports = GridPaginationView
