describe 'syn.grids.pagination.Updater', ->

  instance = pagination = result = sandbox = null
  paginationView = PaginationUpdater = null

  beforeAll ->
    Pagination = require( 'src/lib/pagination' )
    PaginationView = require( 'src/lib/pagination/view' )
    PaginationUpdater = require( 'src/lib/pagination/updater' )

    sandbox = sinon.sandbox.create()
    sandbox.spy( PaginationUpdater.prototype, 'updateButtons' )

    pagination = new Pagination().rowsCount( 200 ).rowsPerPage( 10 )
    paginationView = new PaginationView( pagination ).build( 3 )
    instance = paginationView.updater

  afterAll ->
    paginationView.destroy()
    instance.destroy()
    sandbox.restore()

  describe '#constructor', ->

    beforeAll ->
      pagination.emit( pagination.CHANGE, 'fakeParam' )

    it 'should register pagination.CHANGE event', ->
      PaginationUpdater::updateButtons.should.have.been.calledOnce

  describe '#getNavNumbers', ->

    it 'should maintain number of buttons', ->
      result = instance.getNavNumbers( 2, 20, 7 )
      result.should.deep.equal [0, 1, 2, 3, 4, 5, 6]

      result = instance.getNavNumbers( 8, 20, 7 )
      result.should.deep.equal [5, 6, 7, 8, 9, 10, 11]

      result = instance.getNavNumbers( 18, 20, 7 )
      result.should.deep.equal [14, 15, 16, 17, 18, 19, 20]

  describe '#updateButtons', ->

    beforeAll ->
      sandbox.stub( pagination, 'current' ).returns 2
      sandbox.stub( pagination, 'last' ).returns 10
      sandbox.stub( pagination, 'buttons' ).returns 5

    it 'should toggle active class on current page button', ->
      instance.updateButtons()
      paginationView.buttons[2].hasClass( instance.ACTIVE_CLASS ).should.equal true
      paginationView.prev.hasClass( instance.DISABLED_CLASS ).should.equal false
      paginationView.next.hasClass( instance.DISABLED_CLASS ).should.equal false

    it 'should toggle disable class on prev button', ->
      pagination.current.returns 0
      instance.updateButtons()
      paginationView.buttons[2].hasClass( instance.ACTIVE_CLASS ).should.equal false
      paginationView.prev.hasClass( instance.DISABLED_CLASS ).should.equal true
      paginationView.next.hasClass( instance.DISABLED_CLASS ).should.equal false

    it 'should toggle disable class on next button', ->
      pagination.current.returns 19
      instance.updateButtons()
      paginationView.buttons[2].hasClass( instance.ACTIVE_CLASS ).should.equal false
      paginationView.prev.hasClass( instance.DISABLED_CLASS ).should.equal false
      paginationView.next.hasClass( instance.DISABLED_CLASS ).should.equal true

  describe '#destroy', ->

    beforeAll ->
      PaginationUpdater::updateButtons.reset()
      instance.destroy()
      pagination.emit( pagination.CHANGE, 'fakeParam' )

    it 'should unregister pagination.CHANGE event', ->
      PaginationUpdater::updateButtons.should.not.have.been.called
