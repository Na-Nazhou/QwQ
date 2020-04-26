import Foundation

/// Represents the basic structure of all records. Each record has attendee information and time of actions performed.
/// Typically, a record can only be admitted then missed only once.
/// - Invariant: a valid record may only be served after it is admitted.
/// - Invariant: a valid record may only be confirmed admission after it is admitted.
/// - Invariant: a valid record may only be missed after it is admitted.
/// - Invariant: a valid record may only be readmitted after it is missed.
/// - Invariant: a valid record may only either be served, rejected or withdrawn.
protocol Record {
    var id: String { get }
    var restaurant: Restaurant { get }
    var customer: Customer { get }

    var groupSize: Int { get }
    var babyChairQuantity: Int { get }
    var wheelchairFriendly: Bool { get }

    var admitTime: Date? { get set }
    var serveTime: Date? { get set }
    var rejectTime: Date? { get set }

    var withdrawTime: Date? { get }
    var confirmAdmissionTime: Date? { get }

    var missTime: Date? { get set }
    var readmitTime: Date? { get set }

    var status: RecordStatus { get }
    func getChangeType(from old: Record) -> RecordModification?
}

extension Record {
    var isHistoryRecord: Bool {
        status == .served || status == .rejected || status == .withdrawn
    }

    var isActiveRecord: Bool {
        !isHistoryRecord && status != .invalid
    }

    var isAdmitted: Bool {
        status == .admitted
    }

    var isConfirmedAdmission: Bool {
        status == .confirmedAdmission
    }

    var isServed: Bool {
        status == .served
    }

    var isRejected: Bool {
        status == .rejected
    }

    var isWithdrawn: Bool {
        status == .withdrawn
    }

    var isPendingAdmission: Bool {
        status == .pendingAdmission
    }

    var isMissedAndPending: Bool {
        status == .missedAndPending
    }

    var wasOnceMissed: Bool {
        missTime != nil
    }
}
