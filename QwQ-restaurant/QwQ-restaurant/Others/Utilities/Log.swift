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

    static let closeQueue = OSLog(subsystem: subsystem, category: "handleQueue")
    static let openQueue = OSLog(subsystem: subsystem, category: "handleQueue")

    static let admitCustomer = OSLog(subsystem: subsystem, category: "handleCustomer")
    static let rejectCustomer = OSLog(subsystem: subsystem, category: "handleCustomer")
    static let serveCustomer = OSLog(subsystem: subsystem, category: "handleCustomer")
    static let missCustomer = OSLog(subsystem: subsystem, category: "handleCustomer")

    static let withdrawnByCustomer = OSLog(subsystem: subsystem, category: "handleCustomer")
    static let confirmedByCustomer = OSLog(subsystem: subsystem, category: "handleCustomer")
    static let regularModification = OSLog(subsystem: subsystem, category: "regularModification")

    static let newBookRecord = OSLog(subsystem: subsystem, category: "newRecord")
    static let newQueueRecord = OSLog(subsystem: subsystem, category: "newRecord")
    static let recordError = OSLog(subsystem: subsystem, category: "recordError")
    
    // MARK: Errors
    static let addQueueRecordError = OSLog(subsystem: subsystem, category: "QueueError")
    static let updateQueueRecordError = OSLog(subsystem: subsystem, category: "QueueError")
    static let queueRetrievalError = OSLog(subsystem: subsystem, category: "QueueError")
    static let createQueueRecordError = OSLog(subsystem: subsystem, category: "QueueError")

    static let addBookRecordError = OSLog(subsystem: subsystem, category: "BookError")
    static let updateBookRecordError = OSLog(subsystem: subsystem, category: "BookError")
    static let bookRetrievalError = OSLog(subsystem: subsystem, category: "BookError")
    static let createBookRecordError = OSLog(subsystem: subsystem, category: "BookError")

    static let restaurantRetrievalError = OSLog(subsystem: subsystem, category: "retaurantError")
    static let createRestaurantError = OSLog(subsystem: subsystem, category: "retaurantError")
    static let updateRestaurantError = OSLog(subsystem: subsystem, category: "retaurantError")

    static let cidError = OSLog(subsystem: subsystem, category: "customerError")
    static let createCustomerError = OSLog(subsystem: subsystem, category: "customerError")

    static let createStaffError = OSLog(subsystem: subsystem, category: "staffError")
    static let createRoleError = OSLog(subsystem: subsystem, category: "staffError")

    static let segueError = OSLog(subsystem: subsystem, category: "segueError")
    
    static let imagePickingError = OSLog(subsystem: subsystem, category: "imagePickingError")
}
