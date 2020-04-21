//
//  RestaurantQueueLogic.swift
//  QwQ-restaurant
//
//  Created by Nazhou Na on 17/4/20.
//

protocol RestaurantQueueLogic: QueueStorageSyncDelegate {

    // View Controllers
    var activitiesDelegate: ActivitiesDelegate? { get set }

    func admitCustomer(record: QueueRecord, completion: @escaping () -> Void)
    func serveCustomer(record: QueueRecord, completion: @escaping () -> Void)
    func rejectCustomer(record: QueueRecord, completion: @escaping () -> Void)
    func missCustomer(record: QueueRecord, completion: @escaping () -> Void)
}
