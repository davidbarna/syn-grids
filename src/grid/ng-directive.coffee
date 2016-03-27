gridDirective =
  scope: true
  transclude: true
  template: require( './tpl' )
  controller: [ '$scope', '$element', ( scope, elem ) ->
    GridCtrl = require( './ctrl' )
    ctrl = new GridCtrl( elem )
    require( 'dev-tools' ).angularify( scope, ctrl )
    ctrl.init()
  ]

module.exports = -> gridDirective
