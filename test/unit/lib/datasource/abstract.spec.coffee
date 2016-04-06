describe 'syn.grids.datasource.Abstract', ->

  instance = null

  beforeAll ->
    Datasource = require( 'src/lib/datasource/abstract' )
    instance = new Datasource()

  describe '#keys', ->

    beforeAll ->
      instance.keys( [ 'key1', 'key3' ] )

    it 'should set/get array of keys', ->
      instance.keys().should.deep.equal [ 'key1', 'key3' ]

  describe '#limit', ->

    beforeAll ->
      instance.limit( 98 )

    it 'should set/get results limit', ->
      instance.limit().should.deep.equal 98

  describe '#skip', ->

    beforeAll ->
      instance.skip( 99 )

    it 'should set/get results to skip on any query', ->
      instance.skip().should.deep.equal 99

  describe '#sort', ->

    describe 'when called without value', ->

      it 'should toggle sort value', ->
        instance.sort( 'name' )
        instance.sort().should.deep.equal name: true
        instance.sort( 'name' )
        instance.sort().should.deep.equal name: false
        instance.sort( 'name' )
        instance.sort().should.deep.equal name: true

    describe 'when called with 2 different properties', ->

      it 'should maintain both sort values', ->
        instance.sort( 'surname', false )
        instance.sort().should.deep.equal name: true, surname: false
        instance.sort( 'surname' )
        instance.sort().should.deep.equal name: true, surname: true

    describe 'when multisort disabled', ->

      beforeAll ->
        instance.multiSort( false )

      afterAll ->
        instance.multiSort( true )

      it 'should maintain only one sort value at a time', ->
        instance
          .sort( 'name', true )
          .sort( 'email', false )
        instance.sort().should.deep.equal email: false

  describe '#unsort', ->

    beforeAll ->
      instance
        .sort( 'name', true )
        .sort( 'email', false )
        .unsort( 'email' )

    it 'should remove giben sort value', ->
      instance.sort().should.deep.equal name: true

  describe '#multiSort', ->

    beforeAll ->
      instance.multiSort( false )

    it 'should enable/disable multisort mode', ->
      instance.multiSort().should.deep.equal false

  describe '#count', ->

    it 'should throw an error', ->
      ( -> instance.get() ).should.throw()

  describe '#get', ->

    it 'should throw an error', ->
      ( -> instance.get() ).should.throw()
