//
//  Record.swift
//  QwQ
//
//  Created by Nazhou Na on 19/3/20.
//

import Foundation

protocol Record {
    var id: String { get set }
    var restaurant: Restaurant { get }
    var customer: Customer { get }

    var groupSize: Int { get }
    var babyChairQuantity: Int { get }
    var wheelchairFriendly: Bool { get }

    var admitTime: Date? { get }
    var serveTime: Date? { get }
    var rejectTime: Date? { get }
    var withdrawTime: Date? { get }
    var confirmAdmissionTime: Date? { get }
}

extension Record {
    var isHistoryRecord: Bool {
        status == .served || status == .rejected || status == .withdrawn
    }

    var isActiveRecord: Bool {
        !isHistoryRecord
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

    var status: RecordStatus {
        if withdrawTime != nil {
            return .withdrawn
        } else if admitTime != nil && rejectTime != nil {
            return .rejected
        } else if admitTime != nil && serveTime != nil {
            return .served
        } else if admitTime != nil && confirmAdmissionTime != nil {
            return .confirmedAdmission
        } else if admitTime != nil {
            return .admitted
        } else if admitTime == nil && rejectTime == nil && serveTime == nil {
            return .pendingAdmission
        }
        return .invalid
    }

    func changeType(from old: Record) -> RecordModification? {
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

        if old.status == .pendingAdmission && self.status == .admitted {
            return .admit
        }

        if (old.status == .admitted || old.status == .pendingAdmission) && self.status == .confirmedAdmission {
            return .confirmAdmission
        }

        if old.status == .confirmedAdmission && self.status == .served {
            return .serve
        }

        if (old.status == .admitted || old.status == .confirmedAdmission) && self.status == .rejected {
            return .reject
        }

        return nil
    }
}
