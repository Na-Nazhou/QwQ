import Foundation
import FirebaseFirestore

struct QueueRecord: Record {
    let id: String
    let restaurant: Restaurant
    let customer: Customer

    let groupSize: Int
    let babyChairQuantity: Int
    let wheelchairFriendly: Bool

    let startTime: Date

    let admitTime: Date?
    let serveTime: Date?
    let rejectTime: Date?

    var withdrawTime: Date?
    var confirmAdmissionTime: Date?

    let missTime: Date?
    let readmitTime: Date?
    let estimatedAdmitTime: Date?

    var dictionary: [String: Any] {
        var data = [String: Any]()
        data[Constants.customerKey] = customer.uid
        data[Constants.groupSizeKey] = groupSize
        data[Constants.babyChairQuantityKey] = babyChairQuantity
        data[Constants.wheelChairFriendlyKey] = wheelchairFriendly
        data[Constants.startTimeKey] = startTime
        data[Constants.restaurantKey] = restaurant.uid

        if let estimatedAdmitTime = estimatedAdmitTime {
            data[Constants.estimatedAdmitTimeKey] = estimatedAdmitTime
        }
        if let admitTime = admitTime {
            data[Constants.admitTimeKey] = admitTime
        }
        if let serveTime = serveTime {
            data[Constants.serveTimeKey] = serveTime
        }
        if let rejectTime = rejectTime {
            data[Constants.rejectTimeKey] = rejectTime
        }
        if let withdrawTime = withdrawTime {
            data[Constants.withdrawTimeKey] = withdrawTime
        }
        if let confirmAdmissionTime = confirmAdmissionTime {
            data[Constants.confirmAdmissionTimeKey] = confirmAdmissionTime
        }
        if let missTime = missTime {
            data[Constants.missTimeKey] = missTime
        }
        if let readmitTime = readmitTime {
            data[Constants.readmitTimeKey] = readmitTime
        }

        return data
    }

    init(restaurant: Restaurant, customer: Customer,
         groupSize: Int, babyChairQuantity: Int, wheelchairFriendly: Bool,
         startTime: Date) {
        self.init(id: UUID().uuidString, restaurant: restaurant, customer: customer,
                  groupSize: groupSize, babyChairQuantity: babyChairQuantity,
                  wheelchairFriendly: wheelchairFriendly,
                  startTime: startTime)
    }

    init(id: String, restaurant: Restaurant, customer: Customer,
         groupSize: Int, babyChairQuantity: Int, wheelchairFriendly: Bool,
         startTime: Date, admitTime: Date? = nil, serveTime: Date? = nil,
         rejectTime: Date? = nil, withdrawTime: Date? = nil,
         confirmAdmissionTime: Date? = nil, estimatedAdmitTime: Date? = nil,
         missTime: Date? = nil, readmitTime: Date? = nil) {
        self.id = id
        self.restaurant = restaurant
        self.customer = customer
        self.groupSize = groupSize
        self.babyChairQuantity = babyChairQuantity
        self.wheelchairFriendly = wheelchairFriendly
        self.startTime = startTime

        self.admitTime = admitTime
        self.serveTime = serveTime
        self.rejectTime = rejectTime
        self.withdrawTime = withdrawTime
        self.confirmAdmissionTime = confirmAdmissionTime
        self.missTime = missTime
        self.readmitTime = readmitTime
        self.estimatedAdmitTime = estimatedAdmitTime
    }

    init?(dictionary: [String: Any], customer: Customer, restaurant: Restaurant, id: String) {
        guard let groupSize = dictionary[Constants.groupSizeKey] as? Int,
            let babyChairQuantity = dictionary[Constants.babyChairQuantityKey] as? Int,
            let wheelchairFriendly = dictionary[Constants.wheelChairFriendlyKey] as? Bool,
            let startTime = (dictionary[Constants.startTimeKey] as? Timestamp)?.dateValue() else {
                return nil
        }
        let admitTime = (dictionary[Constants.admitTimeKey] as? Timestamp)?.dateValue()
        let serveTime = (dictionary[Constants.serveTimeKey] as? Timestamp)?.dateValue()
        let rejectTime = (dictionary[Constants.rejectTimeKey] as? Timestamp)?.dateValue()
        let withdrawTime = (dictionary[Constants.withdrawTimeKey] as? Timestamp)?.dateValue()
        let confirmAdmissionTime = (dictionary[Constants.confirmAdmissionTimeKey] as? Timestamp)?.dateValue()
        let missTime = (dictionary[Constants.missTimeKey] as? Timestamp)?.dateValue()
        let readmitTime = (dictionary[Constants.readmitTimeKey] as? Timestamp)?.dateValue()
        let estimatedAdmitTime = (dictionary[Constants.estimatedAdmitTimeKey] as? Timestamp)?.dateValue()

        self.init(id: id, restaurant: restaurant, customer: customer,
                  groupSize: groupSize, babyChairQuantity: babyChairQuantity,
                  wheelchairFriendly: wheelchairFriendly,
                  startTime: startTime, admitTime: admitTime,
                  serveTime: serveTime, rejectTime: rejectTime, withdrawTime: withdrawTime,
                  confirmAdmissionTime: confirmAdmissionTime,
                  estimatedAdmitTime: estimatedAdmitTime,
                  missTime: missTime, readmitTime: readmitTime)
    }
}

extension QueueRecord: Hashable {
    static func == (lhs: QueueRecord, rhs: QueueRecord) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    func completelyIdentical(to other: QueueRecord) -> Bool {
        other == self
            && other.restaurant == restaurant
            && other.customer == customer
            && other.startTime == startTime
            && other.groupSize == groupSize
            && other.babyChairQuantity == babyChairQuantity
            && other.wheelchairFriendly == wheelchairFriendly
            && other.admitTime == admitTime
            && other.serveTime == serveTime
            && other.rejectTime == rejectTime
            && other.withdrawTime == withdrawTime
            && other.confirmAdmissionTime == confirmAdmissionTime
            && other.missTime == missTime
            && other.readmitTime == readmitTime
            && other.estimatedAdmitTime == estimatedAdmitTime
    }
}

extension QueueRecord {
    var status: RecordStatus {
        if withdrawTime != nil {
            return .withdrawn
        }
        if rejectTime != nil {
            return .rejected
        }
        if admitTime != nil && serveTime != nil {
            return .served
        }
        if admitTime != nil {
            if confirmAdmissionTime != nil {
                if missTime == nil {
                    return .confirmedAdmission
                }
                if readmitTime == nil {
                    if confirmAdmissionTime! < missTime! {
                        return .missedAndPending
                    }
                    return .invalid
                }
                if readmitTime! < missTime! {
                    return .invalid
                }
                if confirmAdmissionTime! < readmitTime! {
                    return .admitted
                }
                return .confirmedAdmission
            }
            if missTime != nil && readmitTime == nil {
                return .missedAndPending
            }
            return .admitted
        }
        if serveTime != nil {
            return .invalid
        }
        return .pendingAdmission
    }

    func getChangeType(from old: Record) -> RecordModification? {
        if self.id != old.id {
            // not valid comparison
            return nil
        }

        if old.status == self.status {
            return .customerUpdate
        }

        if status == .withdrawn {
            return .withdraw
        }

        if (old.status == .pendingAdmission && self.status == .admitted)
            || (old.status == .missedAndPending && self.status == .admitted) {
            return .admit
        }

        if self.status == .missedAndPending
            && (old.status == .admitted || old.status == .confirmedAdmission) {
            return .miss
        }

        if (old.status == .admitted || old.status == .pendingAdmission || old.status == .missedAndPending)
            && self.status == .confirmedAdmission {
            return .confirmAdmission
        }

        if (old.status != .rejected || old.status != .withdrawn)
            && self.status == .served {
            return .serve
        }

        if self.status == .rejected {
            return .reject
        }

        return nil
    }
}
