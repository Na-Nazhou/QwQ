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

    var isValidRestaurant: Bool {
        !address.isEmpty && !menu.isEmpty
    }

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
            Constants.uidKey: uid,
            Constants.nameKey: name,
            Constants.emailKey: email,
            Constants.contactKey: contact,
            Constants.addressKey: address,
            Constants.menuKey: menu,
            Constants.isRestaurantOpenKey: isRestaurantOpen,
            Constants.queueOpenTimeKey: queueOpenTime as Any,
            Constants.queueCloseTimeKey: queueCloseTime as Any
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
        guard let uid = dictionary[Constants.uidKey] as? String,
            let name = dictionary[Constants.nameKey] as? String,
            let email = dictionary[Constants.emailKey] as? String,
            let contact = dictionary[Constants.contactKey] as? String,
            let address = dictionary[Constants.addressKey] as? String,
            let menu = dictionary[Constants.menuKey] as? String,
            let isRestaurantOpen = dictionary[Constants.isRestaurantOpenKey] as? Bool
            else {
                return nil
        }

        let queueOpenTime = (dictionary[Constants.queueOpenTimeKey] as? Timestamp)?.dateValue()
        let queueCloseTime = (dictionary[Constants.queueCloseTimeKey] as? Timestamp)?.dateValue()
        
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
