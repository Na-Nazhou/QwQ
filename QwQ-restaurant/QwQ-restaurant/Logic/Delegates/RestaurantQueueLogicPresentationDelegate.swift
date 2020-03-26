protocol RestaurantQueueLogicPresentationDelegate: AnyObject {
    func restaurantDidChangeQueueStatus(toIsOpen: Bool)

    func didAdmitCustomer()
    func didRejectCustomer()
    func didServeCustomer()

    func didUpdateCurrentList()
    func didUpdateWaitingList()
    func didUpdateHistoryList()
}
