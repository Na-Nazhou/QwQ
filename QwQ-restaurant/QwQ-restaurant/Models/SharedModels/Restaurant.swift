import FirebaseFirestore
import Foundation

struct Restaurant: User {

    static let defaultMinGroupSize = 1
    static let defaultMaxGroupSize = 100
    static let defaultAdvanceBookingLimit = 2

    let uid: String
    let name: String
    let email: String
    let contact: String

    let address: String
    let menu: String

    let defaultRole: String

    let minGroupSize: Int
    let maxGroupSize: Int
    let advanceBookingLimit: Int

    let autoOpenTime: TimeInterval?
    let autoCloseTime: TimeInterval?

    var isAutoOpenCloseEnabled: Bool {
        autoOpenTime != nil && autoCloseTime != nil
    }

    var nextAutoOpenTime: Date {
        if let openTime = autoOpenTime {
            var timeInterval: TimeInterval = 0
            let todayOpenTime = Date.getStartOfDay(of: Date()).addingTimeInterval(openTime)
            if todayOpenTime < Date() {
                timeInterval = Date.day
            }
            return todayOpenTime.addingTimeInterval(timeInterval)
        } else {
            return Calendar.current.date(bySettingHour: 10, minute: 0, second: 0,
                                         of: Date.getStartOfDay(of: Date()))!
        }
    }

    var nextAutoCloseTime: Date {
        if let closeTime = autoCloseTime {
            var timeInterval: TimeInterval = 0
            let todayCloseTime = Date.getStartOfDay(of: Date()).addingTimeInterval(closeTime)
            if todayCloseTime < Date() {
                timeInterval = Date.day
            }
            return todayCloseTime.addingTimeInterval(timeInterval)
        } else {
            return Calendar.current.date(bySettingHour: 21, minute: 30, second: 0, of: nextAutoOpenTime)!
        }
    }

    var operatingHours: String {
        if let openTime = autoOpenTime, let closeTime = autoCloseTime {
            return "\(Date.getFormattedTime(openTime)) - \(Date.getFormattedTime(closeTime))"
        } else {
            return ""
        }
    }

    //previous recorded times
    var queueOpenTime: Date? {
        queueOpenTimestamp?.dateValue()
    }
    var queueCloseTime: Date? {
        queueCloseTimestamp?.dateValue()
    }

    var queueOpenTimestamp: Timestamp?
    var queueCloseTimestamp: Timestamp?

    mutating func openQueue(at time: Date) {
        queueOpenTimestamp = Timestamp(date: time)
    }
    mutating func closeQueue(at time: Date) {
        queueCloseTimestamp = Timestamp(date: time)
    }

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

    init(uid: String, name: String, email: String, contact: String, address: String, menu: String,
         defaultRole: String, maxGroupSize: Int, minGroupSize: Int, advanceBookingLimit: Int,
         queueOpenTime: Date? = nil, queueCloseTime: Date? = nil,
         autoOpenTime: TimeInterval? = nil, autoCloseTime: TimeInterval? = nil) {
        self.uid = uid
        self.name = name
        self.email = email
        self.contact = contact
        self.address = address
        self.menu = menu
        self.defaultRole = defaultRole
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
    enum CodingKeys: String, CodingKey {
        case uid
        case name
        case email
        case contact
        case address
        case menu
        case defaultRole
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
