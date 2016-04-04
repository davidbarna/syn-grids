describe 'syn.grids.pagination.View', ->

  $ = require( 'jqlite' )

  instance = element = pagination = result = null

  beforeAll ->
    Pagination = require( 'src/lib/pagination' )
    PaginationView = require( 'src/lib/pagination/view' )

    pagination = new Pagination()
    instance = new PaginationView( pagination )

  afterAll ->
    instance.destroy()

  describe '#constructor', ->

    beforeAll ->
      sinon.stub( instance, '_keyPressHandler' )

    afterAll ->
      instance._keyPressHandler.restore()

    it 'should register keypress events', ->
      instance.element.trigger( 'keydown' )
      instance._keyPressHandler.should.not.have.been.calledOnce

  describe '#length', ->

    beforeAll ->
      sinon.stub( instance, 'build' )
      instance.length( 7 )

    afterAll ->
      instance.build.restore()

    it 'should set/get length of buttons row', ->
      instance.length().should.equal 7

    it 'should rebuild the row', ->
      instance.build.should.have.been.calledWith 7

    describe 'when length is same as before', ->

      it 'should not rebuild the row', ->
        instance.build.reset()
        instance.build.should.not.have.been.called
        instance.length( 8 )
        instance.build.should.have.been.calledWith 8

  describe '#build', ->

    beforeAll ->
      instance.destroy()
      sinon.spy( instance, 'createButton' )
      sinon.spy( instance, 'destroyButton' )
      instance.build( 3 )

    afterAll ->
      instance.destroyButton.restore()
      instance.createButton.restore()

    it 'should build buttons according to length', ->
      instance.createButton.callCount.should.equal 5
      instance.element[0].getElementsByClassName( instance.PAGE_CLASS )
        .length.should.equal 3
      instance.element[0].getElementsByClassName( instance.PREV_CLASS )
        .length.should.equal 1
      instance.element[0].getElementsByClassName( instance.NEXT_CLASS )
        .length.should.equal 1

    describe 'when length is increased', ->

      beforeAll ->
        instance.createButton.reset()
        instance.build( 5 )

      it 'should create only new buttons', ->
        instance.destroyButton.callCount.should.equal 0
        instance.createButton.callCount.should.equal 2
        instance.element[0].getElementsByClassName( instance.PAGE_CLASS )
          .length.should.equal 5

    describe 'when length is decreased', ->

      beforeAll ->
        instance.createButton.reset()
        instance.build( 2 )

      it 'should create only new buttons', ->
        instance.destroyButton.callCount.should.equal 3
        instance.element[0].getElementsByClassName( instance.PAGE_CLASS )
          .length.should.equal 2

  describe '#createButton', ->

    beforeAll ->
      sinon.stub( instance, '_buttonClickHandler' )
      result = instance.createButton( 'testText', 'test-class' )

    afterAll ->
      instance._buttonClickHandler.restore()

    it 'should create button with given text and class', ->
      result.hasClass( 'test-class' ).should.equal true
      result.html().should.equal 'testText'

    it 'should register click event', ->
      result.trigger( 'click' )
      instance._buttonClickHandler.should.have.been.calledOnce

  describe '#destroyButton', ->

    beforeAll ->
      sinon.stub( instance, '_buttonClickHandler' )
      result = instance.createButton( 'testText', 'test-class' )
      $( document.body ).append( result )
      instance.destroyButton( result )

    afterAll ->
      instance._buttonClickHandler.restore()

    it 'should remove button from DOM', ->
      document.body.getElementsByClassName( 'test-class' ).length.should.equal 0

    it 'should register click event', ->
      result.trigger( 'click' )
      instance._buttonClickHandler.should.not.have.been.called

  describe '#destroy', ->

    beforeAll ->
      sinon.stub( instance, 'destroyButton' )
      sinon.stub( instance, '_keyPressHandler' )
      instance.build( 3 ).destroy()

    afterAll ->
      instance._keyPressHandler.restore()
      instance.destroyButton.restore()

    it 'should destroy all buttons', ->
      instance.destroyButton.callCount.should.equal 5
      instance.buttons.length.should.equal 0

    it 'should unregister keypress events', ->
      instance.element.trigger( 'keydown' )
      instance._keyPressHandler.should.not.have.been.called
