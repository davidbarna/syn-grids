describe 'syn.grids.pagination.Ctrl', ->

  $ = require( 'jqlite' )
  Pagination = require( 'src/lib/pagination' )
  PaginationView = require( 'src/lib/pagination/view' )

  instance = element = result = sandbox = null

  beforeAll ->
    PaginationCtrl = require( 'src/lib/pagination/ctrl' )

    sandbox = sinon.sandbox.create()
    element = $( document.createElement( 'DIV' ) )
    instance = new PaginationCtrl( element )

  afterAll ->
    instance.destroy()
    sandbox.restore()

  describe '#init', ->

    beforeAll ->
      sandbox.spy( PaginationView.prototype, 'on' )
      instance.init()

    it 'should prepare pagination view', ->
      instance.element.find( 'button' ).length.should.equal 12
      PaginationView::on.should.have.been.calledWith PaginationView::CLICK


  describe '#setOptions', ->

    beforeAll ->
      sandbox.spy( Pagination.prototype, 'on' )
      instance.setOptions( fakeOption: 'fakeOptionsValue' )

    it 'should set pagination', ->
      instance.pagination.should.be.instanceOf Pagination
      Pagination::on.should.have.been.calledWith Pagination::CHANGE

  describe '#setCount', ->

    beforeAll ->
      sandbox.spy( Pagination.prototype, 'rowsCount' )
      instance.setCount( 7 )

    it 'should set pagination rows count', ->
      Pagination::rowsCount.should.have.been.calledWith 7

  describe '#getSkipped', ->

    beforeAll ->
      instance.pagination.current( 2 ).rowsPerPage( 7 ).rowsCount( 20 )

    it 'should return elements to skip according to current page', ->
      instance.getSkipped().should.equal 14

  describe '#getLimit', ->

    it 'should return results limit', ->
      instance.getLimit().should.equal 7

  describe '#destroy', ->

    beforeAll ->
      sandbox.spy( Pagination.prototype, 'removeListener' )
      sandbox.spy( PaginationView.prototype, 'removeListener' )
      instance.destroy()

    it 'should unregister all events', ->
      Pagination::removeListener.should.have.been.calledWith Pagination::CHANGE
      PaginationView::removeListener.should.have.been.calledWith PaginationView::CLICK

    it 'should remove all elements', ->
      instance.element.html().should.equal ''
