###
 * # GridPaginationUpdater
 * Responsible of tunning button elements according to
 * an instance of Pagination.
 *
 * It updates buttons with classes to allow styling by css.
###
class GridPaginationUpdater

  ACTIVE_CLASS: '--active'
  DISABLED_CLASS: '--disabled'

  ###
   * @constructor
   * @param  {Pagination} @pag Instance of Pagination
   * @param  {Object} @pagElements DOM Elements of pagination
   * @param  {jqLite[]} @pagElements.buttons Pages buttons
   * @param  {jqLite} @pagElements.prev Previous button element
   * @param  {jqLite} @pagElements.next Next button element
  ###
  constructor: ( @pag, @pagElements ) ->
    @pag.on( @pag.CHANGE, @updateButtons )

  ###
   * Returns an array of numbers representiing page buttons to display.
   * @param  {number} current Current page number
   * @param  {number} last    Last page number
   * @param  {number} length  Number of buttons to display
   * @returns {number[]} Example: [4,5,6,7,8]
  ###
  getNavNumbers: ( current, last, length ) ->
    padding = Math.ceil( length / 2 ) - 1

    start = current - padding
    end = current + padding

    end += -start if start < 0

    if end > last
      start -= end - last
      end = last

    start = 0 if start < 0

    return [start..end]

  ###
   * Updates page buttons on DOM changin texts of buttons.
  ###
  updateButtons: =>
    current = @pag.current()
    pages = @getNavNumbers( current, @pag.last(), @pag.buttons() )

    for key, button of @pagElements.buttons
      page = pages[key]
      if page isnt undefined
        button
          .css( 'display', '' )
          .attr( 'page', page )
          .toggleClass( @ACTIVE_CLASS, page is current )
          .html( page + 1 )
      else
        button
          .css( 'display', 'none' )

    @updatePrevButton()
    @updateNextButton()
    return this

  ###
   * Updates previous button
   * It's enabled or disabled depending on current page.
   * @returns {GridPaginationUpdater} `this`
  ###
  updatePrevButton: ->
    @pagElements.prev
      .toggleClass( @DISABLED_CLASS, !@pag.hasPrev() )
      .attr( 'page', @pag.prev() )
    return this

  ###
   * Updates previous button
   * It's enabled or disabled depending on current page.
   * @returns {GridPaginationUpdater} `this`
  ###
  updateNextButton: ->
    @pagElements.next
      .toggleClass( @DISABLED_CLASS, !@pag.hasNext() )
      .attr( 'page', @pag.next() )
    return this

  ###
   * removes events listeners
  ###
  destroy: ->
    @pag.removeListener( @pag.CHANGE, @updateButtons )



module.exports = GridPaginationUpdater
