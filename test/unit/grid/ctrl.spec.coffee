describe 'syn.grids.<syn-grid />.ctrl', ->

  $ = require( 'jqlite' )
  Promise = require( 'bluebird' )
  GridCtrl = require( 'src/grid/ctrl' )
  GridHeadConfig = require( 'src/lib/head/config' )
  DomRowsBuilder = require( 'src/lib/dom/rows/builder' )
  GridDatasourceArray = require( 'src/lib/datasource/array' )

  instance = element = sandbox = fakeConfig = result = null

  beforeAll ->
    sandbox = sinon.sandbox.create()
    element = $( '<table></table>' )
    element.html( '<thead /><tbody />' )
    fakeConfig = head: 'fakeHeadConfig', data: [ { name: 'David' } ]
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
      sandbox.stub( DomRowsBuilder.prototype, 'setTarget' )
      sandbox.stub( GridDatasourceArray.prototype, 'data' )
      sandbox.stub( instance, 'setDatasource' )
      sandbox.stub( instance, 'update' )
      instance.init()

    afterAll ->
      sandbox.restore()

    it 'should config view and datasource', ->
      { HEADER_ELEMENT, BODY_ELEMENT } = instance
      DomRowsBuilder::setTarget.should.have.been.calledWith element.find( HEADER_ELEMENT )
      DomRowsBuilder::setTarget.should.have.been.calledWith element.find( BODY_ELEMENT )

    it 'should instantiate data source', ->
      GridDatasourceArray::data.should.have.been.calledWith fakeConfig.data
      instance.setDatasource.should.have.been.calledOnce
      instance.setDatasource.args[0][0].should.be.instanceOf GridDatasourceArray

    it 'should update the view', ->
      instance.update.should.have.been.calledOnce

  describe '#update', ->

    beforeAll ->
      promise = new Promise( ( resolve ) -> resolve( 'fakeData' ) )
      sandbox.stub( GridHeadConfig.prototype, 'keys' ).returns [ 'fakeKey' ]
      sandbox.stub( GridHeadConfig.prototype, 'labels' ).returns { name: 'fakeLabel' }
      sandbox.spy( GridDatasourceArray.prototype, 'keys' )
      sandbox.stub( GridDatasourceArray.prototype, 'get' ).returns promise
      sandbox.stub( DomRowsBuilder.prototype, 'setRows' )

      result = instance.init()

    afterAll ->
      sandbox.restore()

    it 'should get data from datasource', ->
      GridDatasourceArray::keys.should.have.been.calledWith [ 'fakeKey' ]
      GridDatasourceArray::get.should.have.been.calledOnce

    it 'should update views with the result', ( done ) ->
      result.then ->
        DomRowsBuilder::setRows.should.have.been.calledTwice
        DomRowsBuilder::setRows.should.have.been.calledWith 'fakeData'
        DomRowsBuilder::setRows.should.have.been.calledWith [ { name: 'fakeLabel' } ]
        done()

  describe '#destroy', ->

    beforeAll ->
      sandbox.stub( DomRowsBuilder.prototype, 'destroy' )
      instance.destroy()

    afterAll ->
      sandbox.restore()

    it 'should destroy both dom rows builders', ->
      DomRowsBuilder::destroy.should.have.been.calledTwice
