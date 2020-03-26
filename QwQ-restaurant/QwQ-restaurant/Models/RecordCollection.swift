//
//  CustomerHistory.swift
//  QwQ
//
//  Created by Nazhou Na on 25/3/20.
//

class RecordCollection<T: Record & Hashable>: Collection<T> {

    var records: [T] {
        Array(elements)
    }

    func update(to rec: T) -> (didUpdate: Bool, old: T?) {
        //since QueueRecord is hashed only by its constants
        let old = elements.remove(rec)
        elements.insert(rec)
        if old == nil {
            assert(false, "Update should mean record already existed.")
            return (true, nil)
        }
        // TODO
        return (true, old)
    }
}
