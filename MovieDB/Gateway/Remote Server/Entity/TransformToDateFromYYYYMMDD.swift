//
//  TransformToDateFromYYYYMMDD.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 30/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation
import ObjectMapper

class TransformToDateFromYYYYMMDD: TransformType {
    
    typealias Object = Date
    typealias JSON = String
    
    func transformFromJSON(_ value: Any?) -> Date? {
        guard let stringDate = value as? String else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.date(from: stringDate)
    }
    
    func transformToJSON(_ value: Date?) -> String? {
        fatalError("Transform to JSON from Date not supported")
    }
    
}
