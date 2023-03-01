pub contract Events {
    pub let publicPath : PublicPath
    pub let privatePath: StoragePath

    pub resource interface Public {
        pub fun getName(): String
        pub fun getEvents() : @[Event]
        pub fun asReadonly() : ReadOnly
    }

    pub resource interface Owner {
        pub fun getName(): String

        pub fun setName(_ name: String) {
            pre {
                name.length <= 15: "Names must be under 15 characters long."
            }
        }

        pub fun setEvents(_ events: @Event)
    }

    pub resource Base: Owner, Public {
        access(self) var name: String
        access(self) var events : @[Event]

        init(){
            self.name = "Events"
            self.events <- []
        }

        pub fun getName() : String { return self.name }
        pub fun getEvents() : @[Event] { 
            var others : @[Event] <-[]
            self.events <-> others
            return <- others 
        }

        pub fun setName(_ name: String) { self.name = name }
        pub fun setEvents(_ events: @Event) { self.events.append(<-events) }

        pub fun asReadonly() : ReadOnly {
            return ReadOnly(
                newName : self.getName()
            )
        }

        destroy () {
            destroy self.events
        }
    }

    pub struct ReadOnly {
        pub let name : String

        init(newName : String){
            self.name = newName
        }
    }

    
    pub resource EventLocation {
        pub let id : Int
        pub let lat: UFix64
        pub let lng: UFix64

        init(id: Int, lat: UFix64, lng: UFix64){
            self.id = id
            self.lat = lat
            self.lng = lng
        }     
    }   
    
    pub resource Event {
        pub let id : Int
        pub let name: String
        pub let price: String

        pub var locations: @[EventLocation]

        init(newId: Int, newName: String, newPrice: String){
            self.id = newId
            self.name = newName
            self.price = newPrice
            self.locations <- []
        }     

        pub fun getEventLocations():  @[EventLocation] {
            var other: @[EventLocation] <- []
            self.locations <-> other
            return <- other
        }

        pub fun setEventLocations(locations: @[EventLocation]){
            var other <- locations
            self.locations <-> other
            destroy  other
        }

        pub fun removeEventLocations(index: Int): @EventLocation?  {
            var removed <- self.locations.remove(at: index)
            return <- removed
        }

        destroy (){
            destroy self.locations
        }
    }

    pub fun createEvent(id: Int, name: String, price: String): @Event {
        return <- create Event(newId: id, newName: name, newPrice: price)
    }


    pub fun createEventLocation(id : Int, lat: UFix64, lng: UFix64): @EventLocation {
        return <- create EventLocation(id : id, lat :lat, lng:lng)
    }

    pub fun new(): @Base {
        return <- create Base()
    }

     pub fun read(_ address : Address) : @[Events.Event]{
        if let events = getAccount(address).getCapability<&{Public}>(self.publicPath).borrow() {
            return <- events.getEvents()
        } else {
            return <- []
        }
    }

     init() {
        self.publicPath = /public/events
        self.privatePath = /storage/events
    }

}