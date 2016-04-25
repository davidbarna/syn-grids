gridDirective =
  scope: {
    config: '&'
  }
  transclude: true
  template: require( './tpl' )
  controller: [ '$scope', '$element', '$transclude', ( scope, elem, trans ) ->
    GridCtrl = require( './ctrl' )
    ctrl = new GridCtrl( elem )
    require( 'syn-core' ).angularify( scope, ctrl )
    trans( ( clone ) ->
      if !!clone.html()
        config = JSON.parse( clone.html() )
      else
        config = scope.config()
      ctrl
        .setConfig( config )
        .init()
    )
  ]

module.exports = -> gridDirective
