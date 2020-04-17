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

    func didFindRestaurantQueueClosed(for restaurant: Restaurant)

}

protocol BookingDelegate: RecordDelegate {

    func didFindExistingRecord(at restaurant: Restaurant)

    func didExceedAdvanceBookingLimit(at restaurant: Restaurant)

    func didExceedOperatingHours(at restaurant: Restaurant) 
}
