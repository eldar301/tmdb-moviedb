//
//  ReviewRS.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 19/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation
import ObjectMapper

struct ReviewRS {
    var id: String!
    var author: String?
    var content: String?
    
    init?(map: Map) {
        guard map.JSON["id"] != nil else {
            return nil
        }
    }
}

extension ReviewRS: EntityRS {
    
    typealias Entity = Review
    
    mutating func mapping(map: Map) {
        id      <- map["id"]
        author  <- map["author"]
        content <- map["content"]
    }
    
    var entity: Review {
        var review = Review(id: self.id)
        
        review.author = self.author
        review.content = self.content
        
        return review
    }
    
}
