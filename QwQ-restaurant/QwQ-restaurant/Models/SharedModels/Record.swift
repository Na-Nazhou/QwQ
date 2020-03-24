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

    var admitTime: Date? { get }
    var serveTime: Date? { get }
    var rejectTime: Date? { get }
}

extension Record {

    var isHistoryRecord: Bool {
        status == .served || status == .rejected
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

    var isPendingAdmission: Bool {
        status == .pendingAdmission
    }

    var status: RecordStatus {
        if admitTime == nil {
            return .pendingAdmission
        } else if serveTime == nil && rejectTime == nil {
            return .admitted
        } else if serveTime != nil {
            return .served
        } else if rejectTime != nil {
            return .rejected
        }
        return .invalid
    }

    func changeType(from old: Record) -> RecordModificationType? {
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

        // TODO
        if old.status == self.status {
            return .customerUpdate
        }

        return nil
    }
}
