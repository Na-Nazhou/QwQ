//
//  CustomerHistoryLogic.swift
//  QwQ
//
//  Created by Nazhou Na on 22/3/20.
//

import Foundation

// TODO
protocol CustomerHistoryLogic: QueueStorageSyncDelegate, BookingStorageSyncDelegate {

    // Storage
    var queueStorage: CustomerQueueStorage { get set }
    var bookingStorage: CustomerBookingStorage { get set }

    // View Controllers
    var activitiesDelegate: ActivitiesDelegate? { get set }

    func fetchActiveRecords()

    func fetchHistoryRecords()
}
