describe 'syn.grids.head.Config', ->

  instance = null

  beforeAll ->
    Config = require( 'src/lib/head/config' )
    instance = new Config( {
      name: { label: 'Name', sort: true },
      lastName: { label: 'Last Name' },
      email: { label: 'E-mail', sort: true }
    } )

  describe '#setConfig', ->

    it 'should set defaults', ->
      instance._config.lastName.sort.should.equal false

  describe '#keys', ->

    it 'should return keys from config', ->
      instance.keys().should.deep.equal [ 'name', 'lastName', 'email' ]

  describe '#sortKeys', ->

    it 'should return sortable keys from config', ->
      instance.sortKeys().should.deep.equal [ 'name', 'email' ]

  describe '#labels', ->

    it 'should return head cells labels', ->
      instance.labels().should.deep.equal {
        name: 'Name', lastName: 'Last Name', email: 'E-mail'
      }
