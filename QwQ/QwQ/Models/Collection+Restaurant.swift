/// A collection of restaurants.
extension Collection where T == Restaurant {

    var restaurants: [Restaurant] {
        Array(elements).sorted(by: {
            $0.name < $1.name
        })
    }
}
