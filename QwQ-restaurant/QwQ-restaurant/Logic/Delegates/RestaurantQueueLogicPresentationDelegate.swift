protocol RestaurantQueueLogicPresentationDelegate: AnyObject {
    func restaurantDidChangeQueueStatus(toIsOpen: Bool)

    func didAdmitCustomer()
    func didRejectCustomer()
    func didServeCustomer()

    func didUpdateQueue()
    func didUpdateWaitingList()
}
