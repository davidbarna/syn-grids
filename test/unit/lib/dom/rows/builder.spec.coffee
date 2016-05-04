describe 'syn.grids.dom.rows.Builder', ->

  instance = dataKeys = rowsData = target = result = sandbox = null

  beforeAll ->
    $ = require( 'jqlite' )
    RowsBuilder = require( 'src/lib/dom/rows/builder' )
    sandbox = sinon.sandbox.create()
    dataKeys = [ 'name', 'surname' ]
    rowsData = [
      { name: 'David', surname: 'Smith' }
      { name: 'Mary', surname: 'Johnson' }
    ]
    target = document.createElement( 'UL' )
    instance = new RowsBuilder()
    instance.setTarget( $( target ) )

  afterAll ->
    sandbox.restore()
    instance.destroy()

  describe '#setRows & #setTags', ->
    opts = nameCell = surnameCell = null

    beforeAll ->
      opts = {
        on:
          click: sinon.stub()
        surname:
          on:
            click: sinon.stub()
      }
      instance
        .setTags( 'LI', 'SPAN' )
        .setRows( rowsData, dataKeys,  opts )
        .appendToTarget()

      nameCell = instance.getCells( 'name' )[0]
      surnameCell = instance.getCells( 'surname' )[0]

    afterAll ->
      instance.setTags()

    it 'should change generated row and cell tags', ->
      target.innerHTML.should.contain '>David</span><span'
      target.innerHTML.should.contain '>Johnson</span></li>'

    it 'should apply global and specific options', ->
      nameCell.trigger( 'click' )
      opts.on.click.should.have.been.calledOnce
      opts.surname.on.click.should.not.have.been.calledOnce

      surnameCell.trigger( 'click' )
      opts.on.click.should.have.been.calledTwice
      opts.surname.on.click.should.have.been.calledOnce

  describe '#appendToTarget', ->

    beforeAll ->
      instance.destroy()
      instance
          .setRows( rowsData, dataKeys )
          .appendToTarget()

    it 'should add rows to target element', ->
      rows = target.getElementsByTagName( 'TR' )
      rows.length.should.equal rowsData.length
      rows[1].innerHTML.should.contain '>Mary</'
      rows[1].innerHTML.should.contain '>Johnson</'

    describe 'when called for the second time', ->

      beforeAll ->
        data = [ { name: 'Brad', surname: 'Brody' } ]
        instance
          .setRows( data, dataKeys )
          .appendToTarget()

      it 'should replace rows with new ones', ->
        rows = target.getElementsByTagName( 'TR' )
        rows.length.should.equal 1
        rows[0].innerHTML.should.contain '>Brad</'
        rows[0].innerHTML.should.contain '>Brody</'

  describe '#applyElementOptions , #applyButtonsOptions', ->

    opts = nameCell = null

    beforeAll ->
      opts =
        name:
          on: click: sandbox.stub()
          filter: (key, value) ->
            return '<person>' + value + '</person>'
          buttons:
            sort:
              classes: [ 'test-class' ]
              content: 'SORT_BUTTON_CONTENT'
              on: keydown: sandbox.stub()


      nameCell = instance.getCells( 'name' )[0]
      instance.applyElementOptions(
        nameCell, 'name', opts.name, { name: 'Brad', surname: 'Brody' }
      )

    it 'should create defined buttons', ->
      nameCell.find( 'button' ).length.should.equal 1

    it 'should add defined classes', ->
      nameCell.find( 'button' ).hasClass( 'test-class' ).should.equal true
      nameCell.find( 'button' ).hasClass( 'syn-grid-cell-option--sort' ).should.equal true

    it 'should add defined content', ->
      nameCell.find( 'button' ).html().should.contain 'SORT_BUTTON_CONTENT'

    it 'should set defined events on button', ->
      nameCell.find( 'button' ).trigger( 'keydown' )
      opts.name.buttons.sort.on.keydown.should.have.been.calledOnce

    it 'should set events on main cell', ->
      nameCell.trigger( 'click' )
      opts.name.on.click.should.have.been.calledOnce

    it 'should apply filter', ->
      nameCell.html().should.contain '<person>Brad</person>'

  describe '#getCells', ->

    beforeAll ->
      result = instance.getCells( 'name' )

    it 'should return all cells corresponding to given key', ->
      result.length.should.equal 1
      result[0].html().should.contain 'Brad'

  describe '#destroy', ->

    beforeAll ->
      instance.destroy()

    it 'should add rows to target element', ->
      target.innerHTML.should.equal ''
