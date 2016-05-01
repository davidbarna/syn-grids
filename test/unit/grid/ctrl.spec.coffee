describe 'syn.grids.<syn-grid />.ctrl', ->

  $ = require( 'jqlite' )
  Promise = require( 'bluebird' )
  GridCtrl = require( 'src/grid/ctrl' )
  GridHeadConfig = require( 'src/lib/head/config' )
  Pagination = require( 'src/lib/pagination/ctrl' )
  RowBuilder = require( 'src/lib/dom/rows/builder' )
  GridDatasourceArray = require( 'src/lib/datasource/array' )
  Header = require( 'src/lib/head/ctrl' )

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

  afterAll ->
    sandbox.restore()
    instance.destroy()

  describe '#constructor', ->

    beforeAll ->
      sandbox.spy( RowBuilder.prototype, 'setTarget' )
      instance = new GridCtrl( element )

    afterAll ->
      sandbox.restore()

    it 'should config body and header views', ->
      { HEADER_ELEMENT, BODY_ELEMENT } = instance
      RowBuilder::setTarget.should.have.been.calledWith element.find( HEADER_ELEMENT )
      RowBuilder::setTarget.should.have.been.calledWith element.find( BODY_ELEMENT )


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
      sandbox.spy( RowBuilder.prototype, 'setTags' )
      sandbox.spy( Pagination.prototype, 'on' )
      sandbox.spy( Pagination.prototype, 'init' )
      sandbox.spy( Header.prototype, 'on' )
      sandbox.stub( Header.prototype, 'init' )
      sandbox.spy( GridDatasourceArray.prototype, 'data' )
      sandbox.spy( GridDatasourceArray.prototype, 'multiSort' )
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

    it 'should instantiate pagination', ->
      Header::on.should.have.been.calledWithExactly(
        Header::SORT, instance.updateRows
      )
      Header::init.should.have.been.calledOnce

    it 'should instantiate and configure data source', ->
      GridDatasourceArray::data.should.have.been.calledWith fakeConfig.data
      GridDatasourceArray::multiSort.should.have.been.calledWith false

    it 'should update rows of the view', ( done ) ->
      result.then ->
        instance.updateRows.should.have.been.calledOnce
        done()

  describe '#updateRows', ->

    beforeAll ->
      promise = new Promise( ( resolve ) -> resolve( 'fakeData' ) )
      sandbox.stub( GridHeadConfig.prototype, 'keys' ).returns [ 'fakeKey' ]
      sandbox.stub( GridHeadConfig.prototype, 'get' ).returns { 'fakeKey': {} }
      sandbox.stub( GridHeadConfig.prototype, 'labels' ).returns { name: 'fakeLabel' }
      sandbox.spy( GridDatasourceArray.prototype, 'keys' )
      sandbox.spy( GridDatasourceArray.prototype, 'limit' )
      sandbox.spy( GridDatasourceArray.prototype, 'skip' )
      sandbox.stub( GridDatasourceArray.prototype, 'get' ).returns promise
      sandbox.spy( RowBuilder.prototype, 'setRows' )
      sandbox.stub( RowBuilder.prototype, 'appendToTarget' )

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
        RowBuilder::setRows.should.have.been.calledTwice
        RowBuilder::setRows.should.have.been.calledWith 'fakeData'
        RowBuilder::setRows.should.have.been.calledWith [ { name: 'fakeLabel' } ]
        RowBuilder::appendToTarget.should.have.been.calledTwice
        done()

    it 'should set limit and skipped from pagination to datasource', ->
      opts = fakeConfig.pagination
      GridDatasourceArray::limit.args[0][0].should.equal opts.rowsPerPage
      GridDatasourceArray::skip.args[0][0].should.equal opts.rowsPerPage * opts.startPage

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
      sandbox.stub( instance._pagination, 'removeListener' )
      sandbox.stub( instance._header, 'removeListener' )
      sandbox.stub( RowBuilder.prototype, 'destroy' )
      sandbox.stub( Pagination.prototype, 'destroy' )
      sandbox.stub( Header.prototype, 'destroy' )
      instance.destroy()

    afterAll ->
      sandbox.restore()

    it 'should unregister events', ->
      instance._pagination.removeListener.should.have.been.called
      instance._header.removeListener.should.have.been.called

    it 'should destroy both dom rows builders', ->
      RowBuilder::destroy.should.have.been.calledOnce

    it 'should destroy pagination', ->
      Pagination::destroy.should.have.been.calledOnce

    it 'should destroy header', ->
      Header::destroy.should.have.been.calledOnce
