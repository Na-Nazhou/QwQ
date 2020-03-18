struct Restaurant: User {
    let uid: String
    let name: String
    let email: String
    let contact: String

    let address: String
    let menu: String

    var isOpen: Bool

    var dictionary: [String: Any] {
        [
            "uid": uid,
            "name": name,
            "email": email,
            "contact": contact,
            "address": address,
            "menu": menu,
            "isOpen": isOpen
        ]
    }

    init(uid: String, name: String, email: String, contact: String, address: String, menu: String, isOpen: Bool) {
        self.uid = uid
        self.name = name
        self.email = email
        self.contact = contact
        self.address = address
        self.menu = menu
        self.isOpen = isOpen
    }

    init?(dictionary: [String: Any]) {
        guard let uid = dictionary["uid"] as? String,
            let name = dictionary["name"] as? String,
            let email = dictionary["email"] as? String,
            let contact = dictionary["contact"] as? String,
            let address = dictionary["address"] as? String,
            let menu = dictionary["menu"] as? String,
            let isOpen = dictionary["isOpen"] as? Bool
        else {
                return nil
        }

        self.uid = uid
        self.name = name
        self.email = email
        self.contact = contact
        self.address = address
        self.menu = menu
        self.isOpen = isOpen
    }
}
