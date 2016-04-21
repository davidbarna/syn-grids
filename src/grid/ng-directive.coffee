gridDirective =
  scope: true
  transclude: true
  template: require( './tpl' )
  controller: [ '$scope', '$element', '$transclude', ( scope, elem, trans ) ->
    GridCtrl = require( './ctrl' )
    ctrl = new GridCtrl( elem )
    require( 'syn-core' ).angularify( scope, ctrl )
    trans( ( clone, scope ) ->
      config = JSON.parse( clone.html() )
      ctrl
        .setConfig( config )
        .init()
    )
  ]

module.exports = -> gridDirective
