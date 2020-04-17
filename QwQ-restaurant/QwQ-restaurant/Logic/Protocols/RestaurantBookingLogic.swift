//
//  RestaurantBookingLogic.swift
//  QwQ-restaurant
//
//  Created by Nazhou Na on 17/4/20.
//

protocol RestaurantBookingLogic: BookingStorageSyncDelegate {

    // View Controllers
    var activitiesDelegate: ActivitiesDelegate? { get set }

    func admitCustomer(record: BookRecord, completion: @escaping () -> Void)
    func serveCustomer(record: BookRecord, completion: @escaping () -> Void)
    func rejectCustomer(record: BookRecord, completion: @escaping () -> Void)
}
