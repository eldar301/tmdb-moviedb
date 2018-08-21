//
//  MovieCD+CoreDataProperties.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 21/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//
//

import Foundation
import CoreData


extension MovieCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieCD> {
        return NSFetchRequest<MovieCD>(entityName: "MovieCD")
    }

    @NSManaged public var backdropURL: URL?
    @NSManaged public var budget: Int32
    @NSManaged public var favorite: Bool
    @NSManaged public var genres: [Int32]?
    @NSManaged public var id: Int32
    @NSManaged public var overview: String?
    @NSManaged public var posterURL: URL?
    @NSManaged public var releaseDate: NSDate?
    @NSManaged public var runtime: Int32
    @NSManaged public var title: String?
    @NSManaged public var trailerURL: URL?
    @NSManaged public var voteAverage: Double
    @NSManaged public var voteCount: Int32
    @NSManaged public var casts: NSSet?
    @NSManaged public var reviews: NSSet?

}

// MARK: Generated accessors for casts
extension MovieCD {

    @objc(addCastsObject:)
    @NSManaged public func addToCasts(_ value: PersonCD)

    @objc(removeCastsObject:)
    @NSManaged public func removeFromCasts(_ value: PersonCD)

    @objc(addCasts:)
    @NSManaged public func addToCasts(_ values: NSSet)

    @objc(removeCasts:)
    @NSManaged public func removeFromCasts(_ values: NSSet)

}

// MARK: Generated accessors for reviews
extension MovieCD {

    @objc(addReviewsObject:)
    @NSManaged public func addToReviews(_ value: ReviewCD)

    @objc(removeReviewsObject:)
    @NSManaged public func removeFromReviews(_ value: ReviewCD)

    @objc(addReviews:)
    @NSManaged public func addToReviews(_ values: NSSet)

    @objc(removeReviews:)
    @NSManaged public func removeFromReviews(_ values: NSSet)

}
