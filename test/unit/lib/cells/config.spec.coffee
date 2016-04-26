describe 'syn.grids.cells.Config', ->

  instance = config = null

  beforeAll ->
    Config = require( 'src/lib/cells/config' )
    config = {
      whatever: 'whatever'
    }
    instance = new Config( config )

  describe '#setConfig', ->

    it 'should store config', ->
      instance._config.whatever.should.exist

  describe '#get', ->

    it 'should return keys from config', ->
      instance.get().should.deep.equal config
