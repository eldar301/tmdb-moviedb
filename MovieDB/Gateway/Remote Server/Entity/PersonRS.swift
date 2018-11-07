//
//  PersonRS.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 19/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation
import ObjectMapper

class PersonRS {
    var id: Int!
    var name: String?
    var profilePath: String?
    var gender: Int?
    var biography: String?
    var placeOfBirth: String?
    var birthday: Date?
    var deathday: Date?
    
    required init?(map: Map) {
        guard map.JSON["id"] != nil else {
            return nil
        }
    }
}

extension PersonRS: EntityRS {
    
    typealias Entity = Person
    
    func mapping(map: Map) {
        id               <- map["id"]
        name             <- map["name"]
        profilePath      <- map["profile_path"]
        gender           <- map["gender"]
        biography        <- map["biography"]
        placeOfBirth     <- map["place_of_birth"]
        birthday         <- (map["birthday"], TransformToDateFromYYYYMMDD())
        deathday         <- (map["deathday"], TransformToDateFromYYYYMMDD())
    }
    
    var entity: Person {
        let gender = APIHelper.gender(forID: self.gender)
        
        var person = Person(id: self.id)
        
        let profileImageURL = APIHelper.url(forPath: self.profilePath, withSize: APIHelper.ProfileSize.w185.rawValue)
        
        person.name = self.name
        person.profileImageURL = profileImageURL
        person.gender = gender
        person.biography = self.biography
        person.placeOfBirth = self.placeOfBirth
        person.birthday = self.birthday
        person.deathday = self.deathday
        
        return person
    }
    
}
