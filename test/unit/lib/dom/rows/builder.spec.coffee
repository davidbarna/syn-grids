describe 'syn.grids.dom.rows.Builder', ->

  instance = rowsData = target = result = null

  beforeAll ->
    $ = require( 'jqlite' )
    DomRowsBuilder = require( 'src/lib/dom/rows/builder' )

    rowsData = [
      { name: 'David', surname: 'Smith' }
      { name: 'Mary', surname: 'Johnson' }
    ]
    target = document.createElement( 'UL' )
    instance = new DomRowsBuilder()
    instance.setTarget( $( target ) )

  describe '#setTags', ->

    beforeAll ->
      instance.setTags( 'LI', 'SPAN' )
      instance.setRows( rowsData )

    afterAll ->
      instance.setTags()

    it 'should change generated row and cell tags', ->
      target.innerHTML.should.contain '<li><span>David</span>'
      target.innerHTML.should.contain '<span>Johnson</span></li>'

  describe '#getRows', ->

    beforeAll ->
      result = instance.getRows( rowsData )

    it 'should generate DOM rows according to data', ->
      result.length.should.equal rowsData.length
      result[1].innerHTML.should.contain '<td>Mary</td><td>Johnson</td>'

  describe '#appendToTarget', ->

    beforeAll ->
      instance.destroy()
      instance.appendToTarget( instance.getRows( rowsData ) )

    it 'should add rows to target element', ->
      rows = target.getElementsByTagName( 'TR' )
      rows.length.should.equal rowsData.length
      rows[1].innerHTML.should.contain '<td>Mary</td><td>Johnson</td>'

    describe 'when called for the second time', ->

      beforeAll ->
        data = [ { name: 'Brad', surname: 'Brody' } ]
        instance.appendToTarget( instance.getRows( data ) )

      it 'should replace rows with new ones', ->
        rows = target.getElementsByTagName( 'TR' )
        rows.length.should.equal 1
        rows[0].innerHTML.should.contain '<td>Brad</td><td>Brody</td>'

  describe '#destroy', ->

    beforeAll ->
      instance.destroy()

    it 'should add rows to target element', ->
      target.innerHTML.should.equal ''
