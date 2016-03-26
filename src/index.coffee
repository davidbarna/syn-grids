require( 'jade/runtime' )

window.syn ?= {}
window.syn.grids ?=
  angular: require( './lib/angular' )

module.exports = window.syn.grids
