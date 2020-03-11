//
//  QueueRecord.swift
//  QwQ
//
//  Created by Nazhou Na on 11/3/20.
//  Copyright © 2020 Appfish. All rights reserved.
//

import Foundation

struct QueueRecord {

    var customer: Customer
    var restaurant: Restaurant

    var groupSize: Int
    var babyCount: Int
    var wheelchairCount: Int

    var startTime: Date
    var serveTime: Date?
} 
