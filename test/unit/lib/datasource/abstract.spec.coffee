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

  describe '#get', ->

    it 'should throw an error', ->
      ( -> instance.get() ).should.throw()
