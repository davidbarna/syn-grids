describe 'syn.grids.Pagination', ->

  instance = null

  beforeAll ->
    Pagination = require( 'src/lib/pagination' )
    instance = new Pagination()
    sinon.stub( instance, '_emitChange' )

  afterAll ->
    instance._emitChange.restore()

  describe '#options', ->

    describe 'when no option is given', ->

      beforeAll ->
        instance.options()

      it 'should set defaults', ->
        instance.buttons().should.equal instance.DEFAULTS.buttons
        instance.rowsPerPage().should.equal instance.DEFAULTS.rowsPerPage
        instance.current().should.equal instance.DEFAULTS.startPage


    describe 'when option are given', ->

      beforeAll ->
        instance.options(
          buttons: 7
          rowsPerPage: 8
          startPage: 3
        )

      it 'should set defaults', ->
        instance.buttons().should.equal 7
        instance.rowsPerPage().should.equal 8
        instance.current().should.equal 3

  describe '#buttons', ->

    beforeAll ->
      instance.buttons( '6' )

    it 'should set/get buttons property', ->
      instance.buttons().should.equal 6

  describe '#rowsCount', ->

    beforeAll ->
      instance._emitChange.reset()
      instance.rowsCount( '25' )

    it 'should set/get rowsCount property', ->
      instance.rowsCount().should.equal 25

    it 'should emit a change event', ->
      instance._emitChange.should.have.been.calledOnce

  describe '#rowsPerPage', ->

    beforeAll ->
      instance._emitChange.reset()
      instance.rowsPerPage( '3' )

    it 'should set/get rowsPerPage property', ->
      instance.rowsPerPage().should.equal 3

    it 'should emit a change event', ->
      instance._emitChange.should.have.been.calledOnce

  describe '#current', ->

    beforeAll ->
      instance._emitChange.reset()
      instance.current( '2' )

    it 'should set/get current property', ->
      instance.current().should.equal 2

    it 'should emit a change event', ->
      instance._emitChange.should.have.been.calledOnce

    describe 'when given value is current() value', ->

      it 'should emit a change event', ->
        instance._emitChange.reset()
        instance.current( '2' )
        instance._emitChange.should.not.have.been.called

  describe '#last', ->

    it 'should return last page number', ->
      instance.rowsPerPage( 7 )
      instance.rowsCount( 6 ).last().should.equal 0
      instance.rowsCount( 140 ).last().should.equal 19
      instance.rowsCount( 141 ).last().should.equal 20

  describe '#hasPrev', ->

    it 'should return if there is a previous page', ->
      instance.current( 0 ).hasPrev().should.equal false
      instance.current( 1 ).hasPrev().should.equal true

  describe '#hasNext', ->

    it 'should return if there is a next page', ->
      instance.current( instance.last() ).hasNext().should.equal false
      instance.current( instance.last() - 1 ).hasNext().should.equal true

  describe '#next', ->

    it 'should return next page number', ->
      instance.current( instance.last() - 1 )
      instance.next().should.equal instance.last()
      instance.current( instance.last() )
      instance.next().should.equal instance.last()

  describe '#prev', ->

    it 'should return previous page number', ->
      instance.current( instance.last()  )
      instance.prev().should.equal instance.last() - 1
      instance.current( 0 )
      instance.prev().should.equal 0
