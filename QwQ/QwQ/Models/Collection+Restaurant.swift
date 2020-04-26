//
//  File.swift
//  QwQ
//
//  Created by Nazhou Na on 25/3/20.
//

extension Collection where T == Restaurant {
    var restaurants: [Restaurant] {
        Array(elements).sorted(by: {
            $0.name < $1.name
        })
    }
}
