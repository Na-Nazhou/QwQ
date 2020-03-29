//
//  File.swift
//  QwQ
//
//  Created by Nazhou Na on 25/3/20.
//

extension Collection where T == Restaurant {
    var restaurants: Set<Restaurant> {
        elements
    }

    func update(into restaurant: Restaurant) -> RestaurantModification {
        let old = elements.remove(restaurant)
        assert(old != nil, "Update should only be called if restaurant already existed.")

        elements.insert(restaurant)

        return Collection<Restaurant>.findModificationBetween(old: old!, new: restaurant)
    }

    static func findModificationBetween(old: Restaurant, new: Restaurant) -> RestaurantModification {
        if old.isQueueOpen == new.isQueueOpen {
            return .changedProfileDetails
        }
        return .changedQueueStatus
    }
    
}
