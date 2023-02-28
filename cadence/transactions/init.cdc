import Events from "../contracts/Event.cdc"
import Xplorer from "../contracts/Xplorer.cdc" 

transaction {

  prepare(acct: AuthAccount) {
    let xplorer <- Xplorer.new()
    let newEvent <- Events.createEvent(id: 123123123, name: "Event1", price: "Chocolate")

    let eventLocations <- newEvent.getEventLocations()

    eventLocations.append(<- Events.createEventLocation(id: 123123, lat: 16.2840, lng: 206.0394)) 
    eventLocations.append(<- Events.createEventLocation(id: 123123, lat: 18.2840, lng: 210.0394))

    newEvent.setEventLocations(locations: <- eventLocations)

    xplorer.setEvents(<- newEvent)

    acct.save(<- xplorer, to:/storage/events)
    acct.link<&Events.Event>(/public/events, target: /storage/events)

  }
}
 