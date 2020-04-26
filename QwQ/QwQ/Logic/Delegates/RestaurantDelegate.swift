/// Represents the protocol a presentation delegate of restaurant logic should conform to.
protocol RestaurantDelegate: AnyObject {

    /// Updates the restaurant presentation.
    func didUpdateRestaurant()
}
