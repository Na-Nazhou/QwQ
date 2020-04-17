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
        var data = [String: Any]()
        data[Constants.uidKey] = uid
        data[Constants.nameKey] = name
        data[Constants.emailKey] = email
        data[Constants.contactKey] = contact
        data[Constants.addressKey] = address
        data[Constants.menuKey] = menu
        data[Constants.maxGroupSizeKey] = maxGroupSize
        data[Constants.minGroupSizeKey] = minGroupSize
        data[Constants.advanceBookingLimitKey] = advanceBookingLimit

        if let queueOpenTime = queueOpenTime {
            data[Constants.queueOpenTimeKey] = queueOpenTime
        }
        if let queueCloseTime = queueCloseTime {
            data[Constants.queueCloseTimeKey] = queueCloseTime
        }
        if let autoOpenTime = autoOpenTime {
            data[Constants.autoOpenTimeKey] = autoOpenTime
        }
        if let autoCloseTime = autoCloseTime {
            data[Constants.autoCloseTimeKey] = autoCloseTime
        }
        return data
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
        let autoOpenTime = dictionary[Constants.autoOpenTimeKey] as? TimeInterval
        let autoCloseTime = dictionary[Constants.autoCloseTimeKey] as? TimeInterval

        self.init(uid: uid, name: name, email: email, contact: contact, address: address,
                  menu: menu, maxGroupSize: maxGroupSize, minGroupSize: minGroupSize,
                  advanceBookingLimit: advanceBookingLimit,
                  queueOpenTime: queueOpenTime, queueCloseTime: queueCloseTime,
                  autoOpenTime: autoOpenTime, autoCloseTime: autoCloseTime)
    }

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
