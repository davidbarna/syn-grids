describe '<syn-grid />', ->

  rows = nextButton = activeButton = null

  beforeAll ->
    browser.get( '/doc/demo/' )
      .then ->
        grid = element( By.id( 'data-grid-2' ) )
        rows = grid.all( By.tagName( 'tr' ) )
        pagination = grid.all( By.tagName( 'nav' ) )

        nextButton = pagination.all( By.className( '--pagination-next' ) )
        activeButton = pagination.all( By.className( '--active' ) )

  describe 'pagination', ->

    firstRowText = activeNum = null

    describe 'when users clicks on NEXT button', ->

      beforeAll ->
        rows.get( 0 ).getText()
          .then ( text ) ->
            firstRowText = text
            return activeButton.get( 0 ).getText()
          .then ( text ) ->
            activeNum = Number( text )
            nextButton.click()

      it 'should go to next page', ->
        expect( rows.get( 0 ).getText() ).not.toEqual firstRowText
        expect( activeButton.get( 0 ).getText() ).toEqual String( activeNum + 1 )

    describe 'when users clicks ARROW LEFT key', ->

      beforeAll ->
        browser.actions().sendKeys( protractor.Key.ARROW_LEFT ).perform()

      it 'should go to previous page', ->
        expect( rows.get( 0 ).getText() ).toEqual firstRowText
        expect( activeButton.get( 0 ).getText() ).toEqual String( activeNum )
