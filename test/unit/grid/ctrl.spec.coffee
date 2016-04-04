describe 'syn.grids.<syn-grid />.ctrl', ->

  $ = require( 'jqlite' )
  Promise = require( 'bluebird' )
  GridCtrl = require( 'src/grid/ctrl' )
  GridHeadConfig = require( 'src/lib/head/config' )
  Pagination = require( 'src/lib/pagination/ctrl' )
  DomRowsBuilder = require( 'src/lib/dom/rows/builder' )
  GridDatasourceArray = require( 'src/lib/datasource/array' )

  instance = element = sandbox = fakeConfig = result = null

  beforeAll ->
    sandbox = sinon.sandbox.create()
    element = $( '<table></table>' )
    element.html( '<thead /><tbody /><nav />' )
    fakeConfig =
      head: 'fakeHeadConfig',
      pagination:
        rowsPerPage: 5
        buttons: 5,
        startPage: 2
      data: [ { name: 'David' } ]
    instance = new GridCtrl( element )


  describe '#setConfig', ->

    beforeAll ->
      sandbox.stub( GridHeadConfig.prototype, 'setConfig' )
      instance.setConfig( fakeConfig )

    afterAll ->
      sandbox.restore()

    it 'should set head config', ->
      GridHeadConfig::setConfig.should.have.been.called
      GridHeadConfig::setConfig.should.have.been.calledWith fakeConfig.head

  describe '#init', ->

    beforeAll ->
      sandbox.spy( DomRowsBuilder.prototype, 'setTags' )
      sandbox.spy( DomRowsBuilder.prototype, 'setTarget' )
      sandbox.spy( Pagination.prototype, 'on' )
      sandbox.spy( Pagination.prototype, 'init' )
      sandbox.spy( GridDatasourceArray.prototype, 'data' )
      sandbox.stub( instance, 'setDatasource' )
      sandbox.stub( instance, 'updateRows' )
      result = instance.init()

    afterAll ->
      sandbox.restore()

    it 'should instantiate pagination', ->
      Pagination::on.should.have.been.calledWithExactly(
        Pagination::CHANGE, instance.updateRows
      )
      Pagination::init.should.have.been.calledOnce

    it 'should config view and datasource', ->
      { HEADER_ELEMENT, BODY_ELEMENT } = instance
      DomRowsBuilder::setTarget.should.have.been.calledWith element.find( HEADER_ELEMENT )
      DomRowsBuilder::setTarget.should.have.been.calledWith element.find( BODY_ELEMENT )

    it 'should instantiate data source', ->
      GridDatasourceArray::data.should.have.been.calledWith fakeConfig.data

    it 'should updateRows the view', ( done ) ->
      result.then ->
        instance.updateRows.should.have.been.calledOnce
        done()

  describe '#updateRows', ->

    beforeAll ->
      promise = new Promise( ( resolve ) -> resolve( 'fakeData' ) )
      sandbox.stub( GridHeadConfig.prototype, 'keys' ).returns [ 'fakeKey' ]
      sandbox.stub( GridHeadConfig.prototype, 'labels' ).returns { name: 'fakeLabel' }
      sandbox.spy( GridDatasourceArray.prototype, 'keys' )
      sandbox.spy( GridDatasourceArray.prototype, 'limit' )
      sandbox.spy( GridDatasourceArray.prototype, 'skip' )
      sandbox.stub( GridDatasourceArray.prototype, 'get' ).returns promise
      sandbox.stub( DomRowsBuilder.prototype, 'setRows' )

      result = instance.init()

    afterAll ->
      sandbox.restore()

    it 'should get data from datasource', ( done ) ->
      result.then ->
        GridDatasourceArray::keys.should.have.been.calledWith [ 'fakeKey' ]
        GridDatasourceArray::get.should.have.been.calledOnce
        done()

    it 'should updateRows views with the result', ( done ) ->
      result.then ->
        DomRowsBuilder::setRows.should.have.been.calledTwice
        DomRowsBuilder::setRows.should.have.been.calledWith 'fakeData'
        DomRowsBuilder::setRows.should.have.been.calledWith [ { name: 'fakeLabel' } ]
        done()

    it 'should set limit and skipped from pagination to datasource', ->
      opts = fakeConfig.pagination
      GridDatasourceArray::limit.args[1][0].should.equal opts.rowsPerPage
      GridDatasourceArray::skip.args[1][0].should.equal opts.rowsPerPage * opts.startPage

    describe 'when pagination is disabled', ->

      beforeAll ->
        GridDatasourceArray::limit.reset()
        GridDatasourceArray::skip.reset()
        instance._config.pagination = false

      it 'should not set limit of skip on datasource', ->
        GridDatasourceArray::limit.should.not.have.been.called
        GridDatasourceArray::skip.should.not.have.been.called

  describe '#destroy', ->

    beforeAll ->
      sandbox.stub( DomRowsBuilder.prototype, 'destroy' )
      sandbox.stub( Pagination.prototype, 'destroy' )
      instance.destroy()

    afterAll ->
      sandbox.restore()

    it 'should destroy both dom rows builders', ->
      DomRowsBuilder::destroy.should.have.been.calledTwice

    it 'should destroy pagination', ->
      Pagination::destroy.should.have.been.calledOnce
