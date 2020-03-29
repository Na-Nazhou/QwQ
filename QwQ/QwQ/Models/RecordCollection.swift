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
}
