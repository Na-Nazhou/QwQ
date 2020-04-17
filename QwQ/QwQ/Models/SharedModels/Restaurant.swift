import FirebaseFirestore
import Foundation

struct Restaurant: User {
    let uid: String
    let name: String
    let email: String
    let contact: String

    let address: String
    let menu: String

    let minGroupSize: Int
    let maxGroupSize: Int
    let advanceBookingLimit: Int

    let autoOpenTime: TimeInterval?
    let autoCloseTime: TimeInterval?

    //previous recorded times
    let queueOpenTime: Date?
    let queueCloseTime: Date?

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
            Constants.queueOpenTimeKey: queueOpenTime as Any,
            Constants.queueCloseTimeKey: queueCloseTime as Any,
            Constants.autoOpenTimeKey: autoOpenTime as Any,
            Constants.autoCloseTimeKey: autoCloseTime as Any,
            Constants.maxGroupSizeKey: maxGroupSize,
            Constants.minGroupSizeKey: minGroupSize,
            Constants.advanceBookingLimitKey: advanceBookingLimit
        ]
    }

    init?(dictionary: [String: Any]) {
        guard let uid = dictionary[Constants.uidKey] as? String,
            let name = dictionary[Constants.nameKey] as? String,
            let email = dictionary[Constants.emailKey] as? String,
            let contact = dictionary[Constants.contactKey] as? String,
            let address = dictionary[Constants.addressKey] as? String,
            let menu = dictionary[Constants.menuKey] as? String,
            let maxGroupSize = dictionary[Constants.maxGroupSizeKey] as? Int,
            let minGroupSize = dictionary[Constants.minGroupSizeKey] as? Int,
            let advanceBookingLimit = dictionary[Constants.advanceBookingLimitKey] as? Int
            else {
                return nil
        }

        let queueOpenTime = (dictionary[Constants.queueOpenTimeKey] as? Timestamp)?.dateValue()
        let queueCloseTime = (dictionary[Constants.queueCloseTimeKey] as? Timestamp)?.dateValue()
        let autoOpenTime = dictionary[Constants.autoOpenTimeKey] as? Double
        let autoCloseTime = dictionary[Constants.autoCloseTimeKey] as? Double

        self.init(uid: uid, name: name, email: email, contact: contact, address: address,
                  menu: menu, maxGroupSize: maxGroupSize, minGroupSize: minGroupSize,
                  advanceBookingLimit: advanceBookingLimit,
                  queueOpenTime: queueOpenTime, queueCloseTime: queueCloseTime,
                  autoOpenTime: autoOpenTime, autoCloseTime: autoCloseTime)
    }

    init(uid: String, name: String, email: String, contact: String, address: String, menu: String,
         maxGroupSize: Int, minGroupSize: Int, advanceBookingLimit: Int,
         queueOpenTime: Date? = nil, queueCloseTime: Date? = nil,
         autoOpenTime: TimeInterval? = nil, autoCloseTime: TimeInterval? = nil) {
        self.uid = uid
        self.name = name
        self.email = email
        self.contact = contact
        self.address = address
        self.menu = menu
        self.queueOpenTime = queueOpenTime
        self.queueCloseTime = queueCloseTime
        self.autoOpenTime = autoOpenTime
        self.autoCloseTime = autoCloseTime
        self.maxGroupSize = maxGroupSize
        self.minGroupSize = minGroupSize
        self.advanceBookingLimit = advanceBookingLimit
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
