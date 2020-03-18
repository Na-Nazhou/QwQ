//
//  Record.swift
//  QwQ
//
//  Created by Nazhou Na on 19/3/20.
//

import Foundation

protocol Record {
    var id: String { get set }
    var restaurant: Restaurant { get }
    var customer: Customer { get }

    var groupSize: Int { get set }
    var babyChairQuantity: Int { get set }
    var wheelchairFriendly: Bool { get set }

    var admitTime: Date? { get set }
    var rejectTime: Date? { get set }

    var isHistoryRecord: Bool { get }
}
