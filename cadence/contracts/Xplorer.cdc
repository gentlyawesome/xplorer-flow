pub contract Xplorer {

    pub resource EventLocation {
        pub let id : Int
        pub let lat: UFix64
        pub let lng: UFix64
        pub let price: String

        init(id: Int, lat: UFix64, lng: UFix64, price: String){
            self.id = id
            self.lat = lat
            self.lng = lng
            self.price = price
        }     
    }

    pub fun createEventLocation(id : Int, lat: UFix64, lng: UFix64, price: String): @EventLocation {
        return <- create EventLocation(id : id, lat :lat, lng:lng, price: price)
    }
    
    pub resource Event {
        pub let id : Int
        pub let name: String

        pub var locations: @[EventLocation]

        init(newId: Int, newName: String){
            self.id = newId
            self.name = newName
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

    pub fun createEvent(id: Int, name: String): @Event {
        return <- create Event(newId: id, newName: name)
    }


}
 