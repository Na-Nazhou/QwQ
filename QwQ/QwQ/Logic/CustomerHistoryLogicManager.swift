////
////  CustomerHistoryLogicManager.swift
////  QwQ
////
////  Created by Nazhou Na on 23/3/20.
////
//
//class CustomerHistoryLogicManager: CustomerHistoryLogic {
//
//    // Storage
//    var queueStorage: CustomerQueueStorage
//    var bookingStorage: CustomerBookingStorage
//
//    // View controller
//    weak var activitiesDelegate: ActivitiesDelegate?
//
//    var customer: Customer
//
//    private init(customer: Customer, queueStorage: CustomerQueueStorage, bookingStorage: CustomerBookingStorage) {
//        self.customer = customer
//        self.queueStorage = queueStorage
//        self.bookingStorage = bookingStorage
//    }
//
//    func fetchActiveRecords() {
//    }
//
//    func fetchHistoryRecords() {
//    }
//}
//
//extension CustomerHistoryLogicManager {
//    private static var historyLogic: CustomerHistoryLogicManager?
//
//    /// Returns shared customer booking logic manager for the logged in application. If it does not exist,
//    /// a booking logic manager is initiailised with the given customer identity to share.
//    static func shared(for customerIdentity: Customer? = nil,
//                       queueStorage: CustomerQueueStorage? = nil,
//                       bookingStorage: CustomerBookingStorage? = nil) -> CustomerHistoryLogicManager {
//        if let logic = historyLogic {
//            return logic
//        }
//
//        assert(customerIdentity != nil,
//               "Customer identity must be given non-nil to make the customer's booking logic manager.")
//        assert(queueStorage != nil, "Queue storage must be given non-nil")
//        assert(bookingStorage != nil, "Booking storage must be given non-nil")
//        let logic = CustomerHistoryLogicManager(customer: customerIdentity!,
//                                                queueStorage: queueStorage!,
//                                                bookingStorage: bookingStorage!)
//
//        historyLogic = logic
//        return logic
//    }
//
//    static func deinitShared() {
//        historyLogic = nil
//    }
//}
