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

    var isHistoryRecord: Bool { get }
}
