pub contract Event {
    pub let publicPath : PublicPath
    pub let privatePath: StoragePath

    pub resource interface Public {
        pub fun getId(): String
        pub fun getName(): String
        pub fun asReadonly() : Event.ReadOnly
    }

    pub resource interface Owner {
        pub fun getId(): String
        pub fun getName(): String

        pub fun setName(_ name: String) {
            pre {
                name.length <= 15: "Names must be under 15 characters long."
            }
        }
    }

    pub resource Base: Owner, Public {
        access(self) var id: String 
        access(self) var name: String

        init(){
            self.name = "Test Event"
            self.id = "123"
        }

        pub fun getName() : String { return self.name }
        pub fun getId() : String { return self.id }

        pub fun setName(_ name: String) { self.name = name }


        pub fun asReadonly() : Event.ReadOnly {
            return Event.ReadOnly(
                name : self.getName(),
                id: self.getId()
            )
        }

    }

    pub struct ReadOnly {
        pub let name : String
        pub let id : String

        init(name : String, id: String){
            self.name = name
            self.id = id
        }
    }

    pub fun new(): @Event.Base {
        return <- create Base()
    }

    pub fun read(_ address : Address, _ id : String) : Event.ReadOnly? {
        if let events = getAccount(address).getCapability<&{Event.Public}>(Event.publicPath).borrow() {
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
