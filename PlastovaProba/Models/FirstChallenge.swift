//
//  FirstChallenge.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 18.12.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import Foundation

// MARK: - FirstChallenge
class Challenge: Codable, NSCopying {

    var sections: [Section]?
    var identifier: String?

    init(sections: [Section]?, identifier: String?) {
        self.sections = sections
        self.identifier = identifier
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Challenge(sections: sections, identifier: identifier)
        return copy
    }
}

// MARK: - Section
class Section: Codable {
    var name, id: String?
    var topics: [Topic]?

    init(name: String?, id: String?, topics: [Topic]?) {
        self.name = name
        self.id = id
        self.topics = topics
    }
}

// MARK: - Topic
class Topic: Codable {
    var id, question: String?

    init(id: String?, question: String?) {
        self.id = id
        self.question = question
    }
}
