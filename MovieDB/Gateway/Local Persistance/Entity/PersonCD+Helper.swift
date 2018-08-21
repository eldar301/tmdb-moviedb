//
//  PersonCD+Helper.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 21/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

extension PersonCD {
    
    @nonobjc var person: Person {
        var person = Person(id: Int(self.id))
        
        person.name = self.name
        
        return person
    }
    
}
