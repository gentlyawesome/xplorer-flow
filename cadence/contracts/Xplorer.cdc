import Events from "./Event.cdc"

pub contract Xplorer {
    pub let publicPath : PublicPath
    pub let privatePath: StoragePath

    pub resource interface Public {
        pub fun getName(): String
        pub fun getEvents() : @[Events.Event]
        pub fun asReadonly() : Xplorer.ReadOnly
    }

    pub resource interface Owner {
        pub fun getName(): String

        pub fun setName(_ name: String) {
            pre {
                name.length <= 15: "Names must be under 15 characters long."
            }
        }

        pub fun setEvents(_ events: @Events.Event)
    }

    pub resource Base: Owner, Public {
        access(self) var name: String
        access(self) var events : @[Events.Event]

        init(){
            self.name = "Events"
            self.events <- []
        }

        pub fun getName() : String { return self.name }
        pub fun getEvents() : @[Events.Event] { 
            var others : @[Events.Event] <-[]
            self.events <-> others
            return <- others 
        }

        pub fun setName(_ name: String) { self.name = name }
        pub fun setEvents(_ events: @Events.Event) { self.events.append(<-events) }

        pub fun asReadonly() : Xplorer.ReadOnly {
            return Xplorer.ReadOnly(
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

    pub fun new(): @Xplorer.Base {
        return <- create Base()
    }

    pub fun read(_ address : Address) : Xplorer.ReadOnly? {
        if let events = getAccount(address).getCapability<&{Xplorer.Public}>(Xplorer.publicPath).borrow() {
            return events.asReadonly()
        } else {
            return nil
        }
    }


    init() {
        self.publicPath = /public/events
        self.privatePath = /storage/events

        self.account.save(<- self.new(), to: self.privatePath)
        self.account.link<&Base{Public}>(self.publicPath, target: self.privatePath)

        self.account.borrow<&Base{Owner}>(from: self.privatePath)?.setName("test")
    }
}
