//
//  Log.swift
//  Peggle
//
//  Created by Tan Su Yee on 29/3/20.
//  Copyright © 2020 Appfish. All rights reserved.
//

import os.log
import Foundation

private let subsystem = Bundle.main.bundleIdentifier!

struct Log {
    static let deinitLogic = OSLog(subsystem: subsystem, category: "deinitLogic")

    static let entityError = OSLog(subsystem: subsystem, category: "Entity de/serialization error")

    static let closeQueue = OSLog(subsystem: subsystem, category: "handleQueue")
    static let openQueue = OSLog(subsystem: subsystem, category: "handleQueue")

    static let admitCustomer = OSLog(subsystem: subsystem, category: "handleCustomer")
    static let rejectCustomer = OSLog(subsystem: subsystem, category: "handleCustomer")
    static let serveCustomer = OSLog(subsystem: subsystem, category: "handleCustomer")
    static let missCustomer = OSLog(subsystem: subsystem, category: "handleCustomer")
    static let readmitCustomer = OSLog(subsystem: subsystem, category: "handleCustomer")

    static let withdrawnByCustomer = OSLog(subsystem: subsystem, category: "handleCustomer")
    static let confirmedByCustomer = OSLog(subsystem: subsystem, category: "handleCustomer")
    static let regularModification = OSLog(subsystem: subsystem, category: "regularModification")
    static let notAModification = OSLog(subsystem: subsystem, category: "notAModification")

    static let newBookRecord = OSLog(subsystem: subsystem, category: "newRecord")
    static let newQueueRecord = OSLog(subsystem: subsystem, category: "newRecord")
    
    // MARK: FBError
    static let unexpectedDiffError = OSLog(subsystem: subsystem, category: "FBError")
    static let addQueueRecordError = OSLog(subsystem: subsystem, category: "FBError")
    static let updateQueueRecordError = OSLog(subsystem: subsystem, category: "FBError")
    static let queueRetrievalError = OSLog(subsystem: subsystem, category: "FBError")
    static let createQueueRecordError = OSLog(subsystem: subsystem, category: "FBError")

    static let addBookRecordError = OSLog(subsystem: subsystem, category: "FBError")
    static let updateBookRecordError = OSLog(subsystem: subsystem, category: "FBError")
    static let bookRetrievalError = OSLog(subsystem: subsystem, category: "FBError")
    static let createBookRecordError = OSLog(subsystem: subsystem, category: "FBError")

    static let restaurantRetrievalError = OSLog(subsystem: subsystem, category: "FBError")
    static let createRestaurantError = OSLog(subsystem: subsystem, category: "FBError")

    static let ridError = OSLog(subsystem: subsystem, category: "FBError")
    
    // MARK: Notification logs
    static let scheduleSuccess = OSLog(subsystem: subsystem, category: "LocalNotifications")
    static let scheduleError = OSLog(subsystem: subsystem, category: "LocalNotifications")
    static let requestPermissionsFail = OSLog(subsystem: subsystem, category: "LocalNotifications")
    static let redirectToSettings = OSLog(subsystem: subsystem, category: "LocalNotifications")
    static let withdrawNotif = OSLog(subsystem: subsystem, category: "NotificationWithdrawal")
    
    // MARK: Logic for notification
    static let bookNotifError = OSLog(subsystem: subsystem, category: "BookNotifications")
    static let queueNotifError = OSLog(subsystem: subsystem, category: "QueueNotifications")
    static let bookNotifScheduled = OSLog(subsystem: subsystem, category: "BookNotifications")
    static let queueNotifScheduled = OSLog(subsystem: subsystem, category: "QueueNotifications")
}
