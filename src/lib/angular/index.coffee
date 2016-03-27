angular = require( 'angular-bsfy' )

module.exports =
  getModule: ->
    angular
      .module( 'syn.grids', [] )
      .directive( 'synGrid', require( '../../grid/ng-directive' ) )
