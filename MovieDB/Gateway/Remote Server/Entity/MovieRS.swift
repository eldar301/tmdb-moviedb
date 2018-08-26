//
//  MovieRS.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 19/08/2018.
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

struct MovieRS {
    var id: Int!
    var title: String?
    var overview: String?
    var runtime: Int?
    var genres: [[String: Any]]?
    var releaseDate: Date?
    var posterPath: String?
    var backdropPath: String?
    var videos: [[String: Any]]?
    var budget: Int?
    var voteAverage: Double?
    var voteCount: Int?
    
    init?(map: Map) {
        guard map.JSON["id"] != nil else {
            return nil
        }
    }
    
}

extension MovieRS: Mappable {
    
    mutating func mapping(map: Map) {
        id              <- map["id"]
        title           <- map["title"]
        overview        <- map["overview"]
        runtime         <- map["runtime"]
        genres          <- map["genres"]
        releaseDate     <- (map["release_date"], TransformToDateFromYYYYMMDD())
        posterPath      <- map["poster_path"]
        backdropPath    <- map["backdrop_path"]
        videos          <- map["videos.results"]
        budget          <- map["budget"]
        voteAverage     <- map["vote_average"]
        voteCount       <- map["vote_count"]
    }
    
}

extension MovieRS {

    var movie: Movie {
        let convertedGenres = self.genres?.compactMap({ $0["id"] as? Int }).compactMap({ APIHelper.genre(forID: $0) })

        let posterURL = APIHelper.url(forPath: self.posterPath, withSize: APIHelper.PosterSize.w500)
        let backdropURL = APIHelper.url(forPath: self.backdropPath, withSize: APIHelper.BackdropSize.w780)
        
        var trailerURL: URL?
        if let videos = self.videos {
            for video in videos {
                if let type = video["type"] as? String, type == "Trailer" {
                    trailerURL = APIHelper.url(forYoutubeKey: video["key"] as? String)
                }
            }
        }
        
        let voteAverage = (self.voteAverage ?? 0.0) / 2.0
        
        var movie = Movie(id: self.id)
        
        movie.title = self.title
        movie.overview = self.overview
        movie.runtime = self.runtime
        movie.genres = convertedGenres
        movie.releaseDate = self.releaseDate
        movie.posterURL = posterURL
        movie.backdropURL = backdropURL
        movie.trailerURL = trailerURL
        movie.budget = self.budget
        movie.voteAverage = voteAverage
        movie.voteCount = self.voteCount
        
        return movie
    }

}
