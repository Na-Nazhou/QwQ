//
//  Customer.swift
//  QwQ
//
//  Created by Nazhou Na on 11/3/20.
//  Copyright © 2020 Appfish. All rights reserved.
//

struct Customer: User {
    let name: String
    let email: String

    init(name: String, email: String) {
        self.name = name;
        self.email = email;
    }
}
