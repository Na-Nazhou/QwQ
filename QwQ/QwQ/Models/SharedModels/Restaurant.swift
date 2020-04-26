import FirebaseFirestore
import Foundation

/// A restaurant, which is identified by his `uid` for equality and hash.
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
    
    /// Time to open from start of the day.
    let autoOpenTime: TimeInterval?
    /// Time to close from start of the day.
    let autoCloseTime: TimeInterval?

    var isAutoOpenCloseEnabled: Bool {
        autoOpenTime != nil && autoCloseTime != nil
    }

    var operatingHours: String {
        if let openTime = autoOpenTime, let closeTime = autoCloseTime {
            return "\(Date.getFormattedTime(openTime)) - \(Date.getFormattedTime(closeTime))"
        } else {
            return ""
        }
    }
    
    // recorded times from previous sessions
    var queueOpenTime: Date? {
        queueOpenTimestamp?.dateValue()
    }
    var queueCloseTime: Date? {
        queueCloseTimestamp?.dateValue()
    }

    let queueOpenTimestamp: Timestamp?
    let queueCloseTimestamp: Timestamp?

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
    
    /// Constructs a restaurant.
    init(uid: String, name: String, email: String, contact: String, address: String, menu: String,
         maxGroupSize: Int, minGroupSize: Int, advanceBookingLimit: Int,
         queueOpenTime: Date?, queueCloseTime: Date?,
         autoOpenTime: TimeInterval?, autoCloseTime: TimeInterval?) {
        self.uid = uid
        self.name = name
        self.email = email
        self.contact = contact
        self.address = address
        self.menu = menu
        self.queueOpenTimestamp = queueOpenTime == nil ? nil
            : Timestamp(date: queueOpenTime!)
        self.queueCloseTimestamp = queueCloseTime == nil ? nil
            : Timestamp(date: queueCloseTime!)
        self.autoOpenTime = autoOpenTime
        self.autoCloseTime = autoCloseTime
        self.maxGroupSize = maxGroupSize
        self.minGroupSize = minGroupSize
        self.advanceBookingLimit = advanceBookingLimit
    }
}

extension Restaurant {
    /// Coding keys to encode and decode a restaurant.
    enum CodingKeys: String, CodingKey {
        case uid
        case name
        case email
        case contact
        case address
        case menu
        case queueOpenTimestamp = "queueOpenTime"
        case queueCloseTimestamp = "queueCloseTime"
        case autoOpenTime
        case autoCloseTime
        case maxGroupSize
        case minGroupSize
        case advanceBookingLimit
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
