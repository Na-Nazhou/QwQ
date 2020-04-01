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
    static let qLogicAddListener = OSLog(subsystem: subsystem, category: "qLogicAddListener")
    static let deinitLogic = OSLog(subsystem: subsystem, category: "deinitLogic")
    static let closeQueue = OSLog(subsystem: subsystem, category: "handleQueue")
    static let openQueue = OSLog(subsystem: subsystem, category: "handleQueue")
    static let admitCustomer = OSLog(subsystem: subsystem, category: "handleCustomer")
    static let rejectCustomer = OSLog(subsystem: subsystem, category: "handleCustomer")
    static let serveCustomer = OSLog(subsystem: subsystem, category: "handleCustomer")
    static let withdrawnByCustomer = OSLog(subsystem: subsystem, category: "handleCustomer")
    static let regularModification = OSLog(subsystem: subsystem, category: "regularModification")
    static let updateBookRecord = OSLog(subsystem: subsystem, category: "updateRecord")
    static let updateQueueRecord = OSLog(subsystem: subsystem, category: "updateRecord")
    static let newBookRecord = OSLog(subsystem: subsystem, category: "newRecord")
    
    // MARK: FBError
    static let addQueueRecordError = OSLog(subsystem: subsystem, category: "FBError")
    static let updateQueueRecordError = OSLog(subsystem: subsystem, category: "FBError")
    static let deleteQueueRecordError = OSLog(subsystem: subsystem, category: "FBError")
    static let activeQueueRetrievalError = OSLog(subsystem: subsystem, category: "FBError")
    static let queueRetrievalError = OSLog(subsystem: subsystem, category: "FBError")
    static let createQueueRecordError = OSLog(subsystem: subsystem, category: "FBError")
    static let addBookRecordError = OSLog(subsystem: subsystem, category: "FBError")
    static let updateBookRecordError = OSLog(subsystem: subsystem, category: "FBError")
    static let deleteBookRecordError = OSLog(subsystem: subsystem, category: "FBError")
    static let activeBookRetrievalError = OSLog(subsystem: subsystem, category: "FBError")
    static let bookRetrievalError = OSLog(subsystem: subsystem, category: "FBError")
    static let ridError = OSLog(subsystem: subsystem, category: "FBError")
    static let cidError = OSLog(subsystem: subsystem, category: "FBError")
    static let createBookRecordError = OSLog(subsystem: subsystem, category: "FBError")
}
