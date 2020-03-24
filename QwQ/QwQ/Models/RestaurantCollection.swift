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

    func update(_ restaurant: Restaurant) {
        restaurants.remove(restaurant)
        restaurants.insert(restaurant)
    }
    
    func reset() {
        restaurants.removeAll()
    }
}
