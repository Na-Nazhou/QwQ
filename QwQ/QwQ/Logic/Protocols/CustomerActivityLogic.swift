//
//  CustomerActivityLogic.swift
//  QwQ
//
//  Created by Nazhou Na on 9/4/20.
//

protocol CustomerActivityLogic {

    func fetchActiveRecords() -> [Record]
    func fetchHistoryRecords() -> [Record]
}
