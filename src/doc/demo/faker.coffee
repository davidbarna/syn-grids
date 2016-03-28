faker = require( 'faker' )

###
 * Server to generate data for data grid demos
 * @type {Object}
###
gridDataFaker =

  ###
   * Creates user cards
   * @param  {number} length Number of cards to create
   * @return {Array}
  ###
  users: ( length ) ->
    data = []
    while length > 0
      user =
        avatar: faker.image.avatar()
        name: faker.name.firstName()
        lastName: faker.name.lastName()
        address: faker.address.streetAddress()
        email: faker.internet.email().toLowerCase()
        position: faker.name.title()
        dateOfBirth: faker.date.past()
      data.push( user )
      length--

    return data

module.exports = gridDataFaker
