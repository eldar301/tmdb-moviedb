//
//  ReviewCD+CoreDataProperties.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 21/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//
//

import Foundation
import CoreData


extension ReviewCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReviewCD> {
        return NSFetchRequest<ReviewCD>(entityName: "ReviewCD")
    }

    @NSManaged public var author: String?
    @NSManaged public var content: String?
    @NSManaged public var id: String?

}
