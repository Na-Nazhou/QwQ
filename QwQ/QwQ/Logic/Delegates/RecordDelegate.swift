//
//  QueueDelegate.swift
//  QwQ
//
//  Created by Nazhou Na on 16/3/20.
//

protocol RecordDelegate: AnyObject {

    func didAddRecord()

    func didAddRecords(_ newRecords: [Record])

    func didUpdateRecord()

    func didWithdrawRecord()
}

protocol QueueDelegate: RecordDelegate {

    func didFindRestaurantQueueClosed()
}

protocol BookingDelegate: RecordDelegate {

    func didFindExistingRecord()
}
