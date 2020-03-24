//
//  CustomerHistory.swift
//  QwQ
//
//  Created by Nazhou Na on 25/3/20.
//

class RecordHistory<T: Record & Hashable>: Collection<T> {

    var history: Set<T> {
        elements
    }
}
