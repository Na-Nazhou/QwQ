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
    
    // MARK: Logic
    static let deinitLogic = OSLog(subsystem: subsystem, category: "deinitLogic")

    static let entityError = OSLog(subsystem: subsystem, category: "Entity de/serialization error")

    static let closeQueue = OSLog(subsystem: subsystem, category: "handleQueue")
    static let openQueue = OSLog(subsystem: subsystem, category: "handleQueue")

    static let admitCustomer = OSLog(subsystem: subsystem, category: "handleCustomer")
    static let rejectCustomer = OSLog(subsystem: subsystem, category: "handleCustomer")
    static let serveCustomer = OSLog(subsystem: subsystem, category: "handleCustomer")
    static let missCustomer = OSLog(subsystem: subsystem, category: "handleCustomer")
    static let readmitCustomer = OSLog(subsystem: subsystem, category: "handleCustomer")
    static let inexistentCustomer = OSLog(subsystem: subsystem, category: "inexistentCustomer")
    
    static let withdrawnByCustomer = OSLog(subsystem: subsystem, category: "handleCustomer")
    static let confirmedByCustomer = OSLog(subsystem: subsystem, category: "handleCustomer")
    static let regularModification = OSLog(subsystem: subsystem, category: "regularModification")
    static let notAModification = OSLog(subsystem: subsystem, category: "notAModification")

    static let newBookRecord = OSLog(subsystem: subsystem, category: "newRecord")
    static let newQueueRecord = OSLog(subsystem: subsystem, category: "newRecord")
    
    // MARK: Errors
    static let addQueueRecordError = OSLog(subsystem: subsystem, category: "queueRecordError")
    static let updateQueueRecordError = OSLog(subsystem: subsystem, category: "queueRecordError")
    static let queueRetrievalError = OSLog(subsystem: subsystem, category: "queueRecordError")
    static let createQueueRecordError = OSLog(subsystem: subsystem, category: "queueRecordError")

    static let addBookRecordError = OSLog(subsystem: subsystem, category: "bookRecordError")
    static let updateBookRecordError = OSLog(subsystem: subsystem, category: "bookRecordError")
    static let bookRetrievalError = OSLog(subsystem: subsystem, category: "bookRecordError")
    static let createBookRecordError = OSLog(subsystem: subsystem, category: "bookRecordError")
    
    static let removeDbRecordError = OSLog(subsystem: subsystem, category: "dbRemoveRecordError")

    static let restaurantRetrievalError = OSLog(subsystem: subsystem, category: "restaurantError")
    static let createRestaurantError = OSLog(subsystem: subsystem, category: "restaurantError")
    static let ridError = OSLog(subsystem: subsystem, category: "restaurantError")
    
    static let decodeCustomerError = OSLog(subsystem: subsystem, category: "decodeCustomerError")
    
    static let bookNotifError = OSLog(subsystem: subsystem, category: "bookNotificationsError")
    static let queueNotifError = OSLog(subsystem: subsystem, category: "queueNotificationsError")
    
    static let segueError = OSLog(subsystem: subsystem, category: "segueError")
    
    static let selectionStateError = OSLog(subsystem: subsystem, category: "selectionStateError")
    
    static let imagePickingError = OSLog(subsystem: subsystem, category: "imagePickingError")
    
    // MARK: Notification logs
    static let scheduleSuccess = OSLog(subsystem: subsystem, category: "localNotifications")
    static let scheduleError = OSLog(subsystem: subsystem, category: "localNotifications")
    static let requestPermissionsFail = OSLog(subsystem: subsystem, category: "localNotifications")
    static let redirectToSettings = OSLog(subsystem: subsystem, category: "localNotifications")
    static let withdrawNotif = OSLog(subsystem: subsystem, category: "notificationWithdrawal")
    static let bookNotifScheduled = OSLog(subsystem: subsystem, category: "bookNotifications")
    static let queueNotifScheduled = OSLog(subsystem: subsystem, category: "queueNotifications")
}
