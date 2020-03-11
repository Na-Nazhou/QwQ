//
//  RestaurantQueue.swift
//  QwQ
//
//  Created by Nazhou Na on 11/3/20.
//  Copyright © 2020 Appfish. All rights reserved.
//

import Foundation

struct RestaurantQueue {

    var restaurant: Restaurant
    var queue = [QueueRecord]()

    var openTime: Date?
    var closeTime: Date?
}
