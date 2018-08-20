//
//  PersonRS.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 19/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation
import ObjectMapper

struct PersonRS {
    var id: Int!
    var name: String?
    var profilePath: String?
    var gender: Int?
    var biography: String?
    var placeOfBirth: String?
    var birthday: Date?
    var deathday: Date?
    var movies: [MovieRS]?
    
    init?(map: Map) {
        guard map.JSON["id"] != nil else {
            return
        }
    }
}

extension PersonRS: Mappable {
    
    mutating func mapping(map: Map) {
        id               <- map["id"]
        name             <- map["name"]
        profilePath      <- map["profile_path"]
        gender           <- map["gender"]
        biography        <- map["biography"]
        placeOfBirth     <- map["place_of_birth"]
        birthday         <- (map["birthday"], TransformToDateFromYYYYMMDD())
        deathday         <- (map["deathday"], TransformToDateFromYYYYMMDD())
        movies           <- map["combined_credits.cast"]        
    }
    
}

extension PersonRS {
    
    var person: Person {
        let gender = APIHelper.gender(forID: self.gender)
        
        let person = Person(id: self.id)
        
        person.name = self.name
        person.profileImageURL = API.url(forPath: self.profilePath)
        person.gender = gender
        person.biography = self.biography
        person.placeOfBirth = self.placeOfBirth
        person.birthday = self.birthday
        person.deathday = self.deathday
        person.movies = self.movies?.compactMap({ $0.movie })
        
        return person
    }
    
}
