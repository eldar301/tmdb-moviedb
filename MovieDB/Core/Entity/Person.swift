//
//  Person.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 19/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

enum Gender: String {
    case male = "Male"
    case female = "Female"
    
    var localizedString: String {
        return NSLocalizedString(self.rawValue, comment: "Person.Gender")
    }
}

struct Person {
    let id: Int
    var name: String?
    var profileImageURL: URL?
    var gender: Gender?
    var biography: String?
    var placeOfBirth: String?
    var birthday: Date?
    var deathday: Date?
    
    init(id: Int) {
        self.id = id
    }
}
