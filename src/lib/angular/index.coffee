angular = require( 'angular-bsfy' )

module.exports =
  getModule: ->
    angular
      .module( 'syn.grids', [] )
      .run ->
        console.log 'angular module initialized'
