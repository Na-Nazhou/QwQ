/// A collection of hashable records.
class RecordCollection<T: Record & Hashable>: Collection<T> {

    var records: [T] {
        Array(elements)
    }
}
