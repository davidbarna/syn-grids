describe 'syn.grids.head.Config', ->

  instance = null

  beforeAll ->
    Config = require( 'src/lib/head/config' )
    instance = new Config( {
      name: { label: 'Name' },
      lastName: { label: 'Last Name' },
    } )

  describe '#keys', ->

    it 'should return keys from config', ->
      instance.keys().should.deep.equal [ 'name', 'lastName' ]

  describe '#labels', ->

    it 'should return head cells labels', ->
      instance.labels().should.deep.equal [ 'Name', 'Last Name' ]
