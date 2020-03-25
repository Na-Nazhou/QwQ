class RestaurantCollection {
    private(set) var restaurants = Set<Restaurant>()

    var size: Int {
        restaurants.count
    }

    func add(_ restaurant: Restaurant) -> Bool {
        let (isNew, _) = restaurants.insert(restaurant)
        return isNew
    }

    func add(_ restaurant: [Restaurant]) -> Bool {
        let origSize = size
        restaurants = restaurants.union(Set(restaurant))
        return size > origSize
    }

    func remove(_ restaurant: Restaurant) -> Bool {
        let removed = restaurants.remove(restaurant)
        return removed != nil
    }

    func update(into restaurant: Restaurant) -> RestaurantModification {
        let old = restaurants.remove(restaurant)
        assert(old != nil, "Update should only be called if restaurant already existed.")

        restaurants.insert(restaurant)

        return RestaurantCollection.findModificationBetween(old: old!, new: restaurant)
    }

    static func findModificationBetween(old: Restaurant, new: Restaurant) -> RestaurantModification {
        if old.isQueueOpen == new.isQueueOpen {
            return .changedProfileDetails
        }
        return .changedQueueStatus
    }
    
    func reset() {
        restaurants.removeAll()
    }
}
