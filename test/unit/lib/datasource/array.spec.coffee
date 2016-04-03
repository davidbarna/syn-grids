describe 'syn.grids.datasource.Array', ->

  Promise = instance = result = originalData = null

  beforeAll ->
    originalData = [
      { name: 'David', surname: 'Smith', age: 14 , email: 'david@gmail.com' }
      { name: '', surname: 'Johnson', age: 23 , email: 'mary@gmail.com' }
      { name: 'Ted', surname: 'Carter', age: 24 , email: 'ted@gmail.com' }
    ]

    Promise = require( 'bluebird' )
    Datasource = require( 'src/lib/datasource/array' )
    instance = new Datasource()

  afterAll ->

  describe '#data', ->

    beforeAll ->
      instance.data( 'fakeData' )

    it 'should set/get array of data', ->
      instance.data().should.equal 'fakeData'


  describe '#count', ->

    beforeAll ->
      instance.data( originalData )
      result = instance.count()

    it 'should return a promise resolved by total of objects', ( done ) ->
      result.then ( length ) ->
        length.should.equal originalData.length
        done()

  describe '#get', ->

    beforeAll ->
      instance.keys( [ 'name', 'age' ] )
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

    describe 'results limits', ->

      beforeAll ->
        instance.keys( [ 'name', 'age' ] )

      it 'should return results according to limit', ( done ) ->
        instance.limit( 2 ).get().then ( data ) ->
          data.should.deep.equal [
            { name: 'David', age: 14 }
            { name: '', age: 23 }
          ]
          done()

      it 'should return results according to skip property', ( done ) ->
        instance.skip( 2 ).get().then ( data ) ->
          data.should.deep.equal [
            { name: 'Ted', age: 24 }
          ]
          done()
