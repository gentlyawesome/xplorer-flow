pub contract Events {

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

    pub fun createEventLocation(id : Int, lat: UFix64, lng: UFix64): @EventLocation {
        return <- create EventLocation(id : id, lat :lat, lng:lng)
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


}