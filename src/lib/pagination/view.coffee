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

  ###
   * Emits a "page change" event
   * @param  {Event} event
   * @return {undefined}
  ###
  _buttonClickHandler: ( event ) =>
    page = event.target.getAttribute( 'page' )
    @emit( @CLICK, page ) unless !page

  ###
   * On "<" or ">", it simulates a click on prev or next button
   * @param  {Event} event
   * @return {undefined}
  ###
  _keyPressHandler: ( event ) =>
    @prev?.trigger( 'click' ).focus() if event.keyCode is 37
    @next?.trigger( 'click' ).focus() if event.keyCode is 39

  ###
   * @constructor
   * @param  {DOM Element} @target jqLiteinstance
   * @param  {Pagination} @pagination Pagination instance
  ###
  constructor: ( @target, @pagination ) ->
    @element = $( document.createElement( 'SPAN' ) )
    @buttons = []
    @prev = @next = null
    @updater = new PaginationUpdater( @pagination, this )
    @element.on( 'keydown', @_keyPressHandler )

    @length( @pagination.buttons() )

  ###
   * Define length of nav bar
   * @param  {number} length Number of buttons
   * @return {this}
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
   * @return {this}
  ###
  build: ( length ) ->
    buttonsNum = length - 1
    @prev ?= @createButton( '<' )

    for idx in [0..buttonsNum]
      @buttons[idx] ?= @createButton()

    # Surplus buttons are destroyed
    idx = length
    while !!@buttons[idx]
      @destroyButton( @buttons[idx] )
      idx++
    @buttons = @buttons.slice( 0, length )

    @next ?= @createButton( '>' )

    return this

  ###
   * Creates a new DOM element for a buttons with click event handler
   * @param  {string} text = '.' Text of the button
   * @return {DOM Element} jqLite instance
  ###
  createButton: ( text = '.' ) ->
    button = $( document.createElement( @TAGNAME ) )
      .html( text )
      .on( 'click', @_buttonClickHandler )
    @element.append( button )
    return button

  ###
   * Removes listeners and button from DOM
   * @param  {DOM Element} button jqLite instance
   * @return {this}
  ###
  destroyButton: ( button ) ->
    button
      .remove()
      .off( 'click', @_buttonClickHandler )
    return this

  ###
   * Removes all added DOM elements and events
   * @return {this}
  ###
  destroy: ->
    @element.off( 'keydown', @_keyPressHandler )
    @destroyButton( @prev )
    @destroyButton( @next )
    @destroyButton( button ) for button in @buttons
    return this



module.exports = GridPaginationView
