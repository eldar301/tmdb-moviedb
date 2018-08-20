//
//  Review.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 19/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

struct Review {
    let id: String
    var author: String?
    var content: String?
    
    init(id: String) {
        self.id = id
    }
}
