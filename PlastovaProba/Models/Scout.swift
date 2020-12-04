//
//  Scout.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 04.12.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import Foundation

// MARK: - Element
class Scout: Codable {
    let unit, area: String?
    let firstName, id, role: String?
    let age: Int?
    let avatarURL: String?
    let email, sex, lastName: String?

    enum CodingKeys: String, CodingKey {
        case unit, area, firstName, id, role, age
        case avatarURL = "avatarUrl"
        case email, sex, lastName
    }

    init(unit: String?, area: String?, firstName: String, id: String, role: String, age: Int, avatarURL: String?, email: String, sex: String, lastName: String) {
        self.unit = unit
        self.area = area
        self.firstName = firstName
        self.id = id
        self.role = role
        self.age = age
        self.avatarURL = avatarURL
        self.email = email
        self.sex = sex
        self.lastName = lastName
    }
}
