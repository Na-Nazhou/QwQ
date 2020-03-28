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
        if admitTime == nil {
            return .pendingAdmission
        } else if admitTime != nil && withdrawTime == nil && rejectTime == nil && serveTime == nil {
            return .admitted
        } else if withdrawTime != nil {
            return .withdrawn
        } else if rejectTime != nil {
            return .rejected
        } else if serveTime != nil {
            return .served
        }
        return .invalid
    }

    func changeType(from old: Record) -> RecordModification? {
        if self.id != old.id {
            // not valid comparison
            return nil
        }

        if old.status == .pendingAdmission && self.status == .admitted {
            return .admit
        }

        if old.status == .admitted && self.status == .served {
            return .serve
        }

        if old.status == .admitted && self.status == .rejected {
            return .reject
        }

        if old.status == .admitted && self.status == .withdrawn {
            return .withdraw
        }

        // TODO
        if old.status == self.status {
            return .customerUpdate
        }

        return nil
    }
}
