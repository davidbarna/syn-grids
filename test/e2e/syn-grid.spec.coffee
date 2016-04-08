describe '<syn-grid />', ->

  grid = rows = header = headerCells = null

  switchToGrid = ( id ) ->
    grid = element( By.id( id ) )
    header = grid.all( By.css( 'thead tr' ) )
    headerCells = header.all( By.tagName( 'th' ) )
    rows = grid.all( By.css( 'tbody tr' ) )

  beforeAll ->
    browser.get( '/doc/demo/' )

  describe 'pagination', ->

    firstRowText = activeNum = nextButton = activeButton = null

    beforeAll ->
      switchToGrid( 'data-grid-2' )
      pagination = grid.all( By.tagName( 'nav' ) )
      nextButton = pagination.all( By.className( '--pagination-next' ) )
      activeButton = pagination.all( By.className( '--active' ) )

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

  describe 'sorting', ->

    firstRowText = null

    beforeAll ->

      switchToGrid( 'data-grid-3' )
      rows.get( 0 ).getText()
        .then ( text ) -> firstRowText = text

    describe 'when users clicks on none sorted column', ->

      beforeAll ->
        headerCells.get(0).click()

      it 'should order column asc', ->
        expect( rows.get( 0 ).getText() ).not.toEqual firstRowText
        expect( headerCells.get(0).getAttribute('class') ).toContain 'sort-asc'

    describe 'when users clicks on asc sorted column', ->

      beforeAll ->
        headerCells.get(0).click()

      it 'should order column asc', ->
        expect( headerCells.get(0).getAttribute('class') ).toContain 'sort-desc'

    describe 'when another column is sorted', ->

      beforeAll ->
        headerCells.get(1).click()

      it 'should order new column and unorder previous one', ->
        expect( headerCells.get(1).getAttribute('class') ).toContain 'sort-asc'
        expect( headerCells.get(0).getAttribute('class') ).not.toContain 'sort-desc'
        expect( headerCells.get(0).getAttribute('class') ).not.toContain 'sort-asc'
