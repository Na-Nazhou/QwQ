//
//  Restaurant.swift
//  QwQ
//
//  Created by Nazhou Na on 11/3/20.
//  Copyright © 2020 Appfish. All rights reserved.
//

struct Restaurant: User {
    let name: String
    let email: String

    let address: String
    let queue = [QueueRecord]()

    init(name: String, email: String, address: String) {
        self.name = name;
        self.email = email;
        self.address = address;
    }
}

