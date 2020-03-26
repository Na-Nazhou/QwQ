protocol RestaurantQueueLogicPresentationDelegate: AnyObject {
    func restaurantDidChangeQueueStatus(toIsOpen: Bool)

    func didUpdateCurrentList()
    func didUpdateWaitingList()
    func didUpdateHistoryList()
}
