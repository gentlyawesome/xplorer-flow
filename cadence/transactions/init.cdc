import Events from "../contracts/Event.cdc"

transaction {

  prepare(acct: AuthAccount) {
    let events <- Events.new()
    let newEvent <- Events.createEvent(id: 123123123, name: "Event1", price: "Chocolate")

    let eventLocations <- [<- Events.createEventLocation(
          id: 1,
          lat: 16.389231,
          lng: 120.58796,
        ),<- Events.createEventLocation(
          id: 2,
          lat: 16.389391,
          lng: 120.587785,
        ),<- Events.createEventLocation(id:3,
          lat: 16.38932,
          lng: 120.58822,
        )

    ]

    newEvent.setEventLocations(locations: <- eventLocations)
    events.setEvents(<-newEvent)

    acct.save(<- events, to:Events.privatePath)
    acct.link<&Events.Base{Events.Public}>(Events.publicPath, target: Events.privatePath)
 
  }
}
 