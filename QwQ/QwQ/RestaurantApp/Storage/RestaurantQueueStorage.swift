import Foundation
protocol RestaurantQueueStorage {

    // MARK: - Modifier
    func openQueue(of restaurant: Restaurant, at time: Date)
    func closeQueue(of restaurant: Restaurant, at time: Date)

    /// Adds record to the currently admitted list for managers to manage. Queue should still be active on customer's end.
    func admitCustomer(record: QueueRecord)
    /// Removes record from the active queue of restaurant.
    func removeCustomerFromQueue(record: QueueRecord)
    /// Removes record from the admitted list of customer and accepts customer.
    func serveCustomer(record: QueueRecord)
    /// Removes record from the admitted list of customer and rejects customer.
    func rejectCustomer(record: QueueRecord)

    // MARK: - Query
    func loadQueue(of restaurant: Restaurant)
}
