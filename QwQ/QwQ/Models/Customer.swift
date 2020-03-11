//
//  Customer.swift
//  QwQ
//
//  Created by Nazhou Na on 11/3/20.
//  Copyright © 2020 Appfish. All rights reserved.
//

class Customer: User {
    var id: String
    var name: String
    var email: String

    init(id: String, name: String, email: String) {
        self.id = id;
        self.name = name;
        self.email = email;
    }
}
