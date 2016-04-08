describe 'syn.grids.head.Config', ->

  RowsBuilder = require( 'src/lib/dom/rows/builder' )

  instance = sandbox = datasource = null

  beforeAll ->
    originalData = [
      { name: 'David', surname: 'Smith', age: 14 , email: 'david@gmail.com' }
      { name: '', surname: 'Johnson', age: 23 , email: 'mary@gmail.com' }
      { name: 'Ted', surname: 'Carter', age: 24 , email: 'ted@gmail.com' }
    ]
    headConfig = {
      name: { label: 'Name', sort: true },
      surname: { label: 'Last Name' },
      email: { label: 'E-mail', sort: true }
    }
    Config = require( 'src/lib/head/config' )
    config = new Config( headConfig )

    Datasource = require( 'src/lib/datasource/array' )
    datasource = new Datasource().data( originalData )

    Ctrl = require( 'src/lib/head/ctrl' )
    $ = require( 'jqlite' )

    sandbox = sinon.sandbox.create()
    element = $( document.createElement( 'DIV' ) )
    instance = new Ctrl( element, config, datasource )

  afterAll ->
    sandbox.restore()
    instance.destroy()


  describe '#init', ->

    beforeAll ->
      sandbox.spy( RowsBuilder.prototype, 'setRows' )
      sandbox.spy( RowsBuilder.prototype, 'applyCellOptions' )
      sandbox.spy( instance, 'update' )
      instance.init()

    it 'should set view', ->
      RowsBuilder::setRows.should.have.been.calledOnce
      RowsBuilder::setRows.args[0][0][0].should.deep.equal(
        { name: 'Name', surname: 'Last Name', email: 'E-mail' }
      )

    it 'should set sort options', ->
      opts = RowsBuilder::applyCellOptions.args[0][0]
      RowsBuilder::applyCellOptions.should.have.been.calledOnce
      opts.buttons.name.sort.should.exist
      opts.buttons.name.sort.on.click.should.exist
      opts.buttons.name.sort.on.click.should.equal instance._sortClickHandler
      opts.buttons.email.sort.should.exist
      opts.on.click.should.exist
      opts.on.click.should.equal instance._sortClickHandler

      expect( opts.buttons.surname ).to.be.undefined

    it 'should update view with current options', ->
      instance.update.should.have.been.called

  describe '#update', ->

    beforeAll ->
      datasource
        .sort( 'name', true )
        .sort( 'email', false )
      instance.update()

    it 'should update classes on elements according to sort status', ->
      cell = instance._view.getCells( 'name' )[0]
      cell.hasClass( instance.ASC_CLASS ).should.equal true
      cell = instance._view.getCells( 'email' )[0]
      cell.hasClass( instance.DESC_CLASS ).should.equal true

      datasource.unsort( 'email' )
      instance.update()
      cell = instance._view.getCells( 'email' )[0]
      cell.hasClass( instance.DESC_CLASS ).should.equal false
      cell.hasClass( instance.ASC_CLASS ).should.equal false

  describe '#destroy', ->

    beforeAll ->
      sandbox.spy( RowsBuilder.prototype, 'destroy' )
      instance.destroy()

    it 'should destroy view', ->
      RowsBuilder::destroy.should.have.been.calledOnce
