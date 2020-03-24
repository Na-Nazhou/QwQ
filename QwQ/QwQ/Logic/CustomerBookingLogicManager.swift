//
//  CustomerBookingLogicManager.swift
//  QwQ
//
//  Created by Nazhou Na on 19/3/20.
//

import Foundation

class CustomerBookingLogicManager: CustomerBookingLogic {

    // Storage
    var bookingStorage: CustomerBookingStorage

    // View controller
    weak var bookingDelegate: BookingDelegate?
    weak var activitiesDelegate: ActivitiesDelegate?

    var customer: Customer

    // TODO: change to record collection
    private var currentBookRecords = Set<BookRecord>()
    var activeBookRecords: [BookRecord] {
        Array(currentBookRecords)
    }

    private var bookingHistory = RecordCollection<BookRecord>()
    var pastBookRecords: [BookRecord] {
        bookingHistory.records
    }

    private init(customer: Customer, bookingStorage: CustomerBookingStorage) {
        self.customer = customer
        self.bookingStorage = bookingStorage

        fetchActiveBookRecords()
        fetchBookingHistory()
    }

    deinit {
        print("\n\tDEINITING\n")
        for record in currentBookRecords {
            bookingStorage.removeListener(for: record)
        }
    }

    func fetchActiveBookRecords() {
        bookingStorage.loadActiveBookRecords(customer: customer, completion: {
            guard let bookRecord = $0 else {
                return
            }

            self.currentBookRecords.insert(bookRecord)
            self.bookingStorage.registerListener(for: bookRecord)
            self.activitiesDelegate?.didUpdateActiveRecords()
        })
    }

    func fetchBookingHistory() {
        bookingStorage.loadBookHistory(customer: customer, completion: {
             guard $0 != nil else {
                 return
             }
             let didAddNew = self.bookingHistory.add($0!)
             if !didAddNew {
                 return
             }
             self.activitiesDelegate?.didUpdateHistoryRecords()
         })
        
    }

    func addBookRecord(to restaurant: Restaurant, at time: Date,
                       with groupSize: Int, babyChairQuantity: Int, wheelchairFriendly: Bool) {
        // Check conflicts
        var newRecord = BookRecord(restaurant: restaurant,
                                   customer: customer,
                                   time: time,
                                   groupSize: groupSize,
                                   babyChairQuantity: babyChairQuantity,
                                   wheelchairFriendly: wheelchairFriendly)

        bookingStorage.addBookRecord(newRecord: newRecord,
                                     completion: { self.didAddBookRecord(newRecord: &newRecord, id: $0)

        })
    }

    private func didAddBookRecord(newRecord: inout BookRecord, id: String) {
        newRecord.id = id
        currentBookRecords.insert(newRecord)

        bookingStorage.registerListener(for: newRecord)
        bookingDelegate?.didAddBookRecord()
    }

    func editBookRecord(oldRecord: BookRecord,
                        at time: Date,
                        with groupSize: Int,
                        babyChairQuantity: Int,
                        wheelchairFriendly: Bool) {
        // Check conflicts
        let newRecord = BookRecord(id: oldRecord.id,
                                   restaurant: oldRecord.restaurant,
                                   customer: customer,
                                   time: time,
                                   groupSize: groupSize,
                                   babyChairQuantity: babyChairQuantity,
                                   wheelchairFriendly: wheelchairFriendly)
        bookingStorage.updateBookRecord(oldRecord: oldRecord, newRecord: newRecord, completion: {
            self.bookingDelegate?.didUpdateBookRecord()
        })
    }

    func deleteBookRecord(_ record: BookRecord) {
        bookingStorage.deleteBookRecord(record: record, completion: {
            self.activitiesDelegate?.didDeleteRecord()
        })
    }

    func didUpdateBookRecord(_ record: BookRecord) {
        print("\nDid update book record\n")
        guard let oldRecord = activeBookRecords.first(where: { $0 == record }) else {
            return
        }
        let modification = record.changeType(from: oldRecord)
        switch modification {
        case .admit:
            // call some (activites) delegate to display admission status
            customerDidUpdateBookRecord(record: record) //tent.
            print("\ndetected admission\n")
        case .serve:
            addAsHistoryRecord(record)
            didDeleteBookRecord(record)
            print("\ndetected service\n")
        case .reject:
            addAsHistoryRecord(record)
            didDeleteBookRecord(record)
            print("\ndetected rejection\n")
        case .customerUpdate:
            customerDidUpdateBookRecord(record: record)
            print("\ndetected regular modif\n")
        case .none:
            assert(false, "Modification should be something")
        }
    }

    private func customerDidUpdateBookRecord(record: BookRecord) {
        currentBookRecords.remove(record)
        currentBookRecords.insert(record)
        activitiesDelegate?.didUpdateActiveRecords()
    }

    func didDeleteBookRecord(_ record: BookRecord) {
        bookingStorage.removeListener(for: record)
        currentBookRecords.remove(record)
        activitiesDelegate?.didUpdateActiveRecords()
    }

    private func addAsHistoryRecord(_ record: BookRecord) {
        if bookingHistory.add(record) {
            activitiesDelegate?.didUpdateHistoryRecords()
        }
    }
}

extension CustomerBookingLogicManager {
    private static var bookingLogic: CustomerBookingLogicManager?

    /// Returns shared customer booking logic manager for the logged in application. If it does not exist,
    /// a booking logic manager is initiailised with the given customer identity to share.
    static func shared(for customerIdentity: Customer? = nil,
                       with storage: CustomerBookingStorage? = nil) -> CustomerBookingLogicManager {
        if let logic = bookingLogic {
            return logic
        }

        assert(customerIdentity != nil,
               "Customer identity must be given non-nil to make the customer's booking logic manager.")
        assert(storage != nil,
               "Booking storage must be given non-nil")
        let logic = CustomerBookingLogicManager(customer: customerIdentity!, bookingStorage: storage!)
        logic.bookingStorage.logicDelegate = logic

        bookingLogic = logic
        return logic
    }

    static func deinitShared() {
        bookingLogic = nil
    }
}
