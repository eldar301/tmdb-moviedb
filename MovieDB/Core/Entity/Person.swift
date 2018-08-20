//
//  Person.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 19/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

enum Gender {
    case male
    case female
}

class Person {
    let id: Int
    var name: String?
    var profileImageURL: URL?
    var gender: Gender?
    var biography: String?
    var placeOfBirth: String?
    var birthday: Date?
    var deathday: Date?
    var movies: [Movie]?
    
    init(id: Int) {
        self.id = id
    }
}
