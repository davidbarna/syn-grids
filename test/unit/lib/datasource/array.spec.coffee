describe 'syn.grids.datasource.Array', ->

  Promise = instance = result = null

  beforeAll ->
    Promise = require( 'bluebird' )
    Datasource = require( 'src/lib/datasource/array' )
    instance = new Datasource()

  afterAll ->

  describe '#data', ->

    beforeAll ->
      instance.data( 'fakeData' )

    it 'should set/get array of data', ->
      instance.data().should.equal 'fakeData'

  describe '#get', ->

    originalData = null

    beforeAll ->
      originalData = [
        { name: 'David', surname: 'Smith', age: 14 , email: 'david@gmail.com' }
        { surname: 'Johnson', age: 23 , email: 'mary@gmail.com' }
        { name: 'Ted', surname: 'Carter', age: 24 , email: 'ted@gmail.com' }
      ]
      instance.data( originalData )

    describe 'when keys are set', ->

      beforeAll ->
        instance.keys( [ 'name', 'age' ] )
        result = instance.get()

      it 'should return all data with filtered keys', ( done ) ->
        result.then ( data ) ->
          data.should.deep.equal [
            { name: 'David', age: 14 }
            { name: '', age: 23 }
            { name: 'Ted', age: 24 }
          ]
          done()

    describe 'when keys are not set', ->

      beforeAll ->
        instance.keys( null )
        result = instance.get()

      it 'should return all data unfiltered by keys', ( done ) ->
        result.then ( data ) ->
          data.should.deep.equal originalData
          done()
