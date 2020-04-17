//
//  CustomerActivityLogic.swift
//  QwQ
//
//  Created by Nazhou Na on 9/4/20.
//

protocol CustomerActivityLogic {

    // Models
    var activeRecords: [Record] { get }
    var historyRecords: [Record] { get }
}
