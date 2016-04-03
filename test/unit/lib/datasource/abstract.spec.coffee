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

  describe '#count', ->

    it 'should throw an error', ->
      ( -> instance.get() ).should.throw()

  describe '#get', ->

    it 'should throw an error', ->
      ( -> instance.get() ).should.throw()
