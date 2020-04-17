//
//  Record.swift
//  QwQ
//
//  Created by Nazhou Na on 19/3/20.
//

import Foundation

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

    var missTime: Date? { get }
    var readmitTime: Date? { get }

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
}
