import FirebaseFirestore
import Foundation

struct Restaurant: User {
    let uid: String
    let name: String
    let email: String
    let contact: String

    let address: String
    let menu: String

    var isRestaurantOpen: Bool

    //previous recorded times
    var queueOpenTime: Date?
    var queueCloseTime: Date?

    var isQueueOpen: Bool {
        guard let queueOpenTime = queueOpenTime else {
            return false
        }
        let isOpen = queueCloseTime == nil
            || queueOpenTime > queueCloseTime!
        if isOpen {
            assert(Date() > queueOpenTime, "Current date should be after open time to be open!")
        }
        return isOpen
    }

    var dictionary: [String: Any] {
        [
            "uid": uid,
            "name": name,
            "email": email,
            "contact": contact,
            "address": address,
            "menu": menu,
            "isRestaurantOpen": isRestaurantOpen,
            "queueOpenTime": queueOpenTime as Any,
            "queueCloseTime": queueCloseTime as Any
        ]
    }

    init(uid: String, name: String, email: String, contact: String, address: String, menu: String,
         isRestaurantOpen: Bool, queueOpenTime: Date? = nil, queueCloseTime: Date? = nil) {
        self.uid = uid
        self.name = name
        self.email = email
        self.contact = contact
        self.address = address
        self.menu = menu
        self.isRestaurantOpen = isRestaurantOpen
        self.queueOpenTime = queueOpenTime
        self.queueCloseTime = queueCloseTime
    }

    init?(dictionary: [String: Any]) {
        guard let uid = dictionary["uid"] as? String,
            let name = dictionary["name"] as? String,
            let email = dictionary["email"] as? String,
            let contact = dictionary["contact"] as? String,
            let address = dictionary["address"] as? String,
            let menu = dictionary["menu"] as? String,
            let isRestaurantOpen = dictionary["isRestaurantOpen"] as? Bool
        else {
                return nil
        }

        let queueOpenTime = (dictionary["queueOpenTime"] as? Timestamp)?.dateValue()
        let queueCloseTime = (dictionary["queueCloseTime"] as? Timestamp)?.dateValue()

        self.init(uid: uid, name: name, email: email, contact: contact, address: address,
                  menu: menu, isRestaurantOpen: isRestaurantOpen, queueOpenTime: queueOpenTime,
                  queueCloseTime: queueCloseTime)
    }
}

extension Restaurant {
    static func == (lhs: Restaurant, rhs: Restaurant) -> Bool {
        lhs.uid == rhs.uid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
}
