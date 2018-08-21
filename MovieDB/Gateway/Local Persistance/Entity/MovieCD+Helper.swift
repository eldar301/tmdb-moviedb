//
//  MovieCD+Helper.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 21/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

extension MovieCD {
    
    @nonobjc var movie: Movie {
        var movie = Movie(id: Int(self.id))
        
        movie.title = self.title
        movie.overview = self.overview
        movie.runtime = Int(self.runtime)
        movie.genres = self.genres?.compactMap({ Genre(rawValue: Int($0)) })
        movie.releaseDate = self.releaseDate as Date?
        movie.posterURL = self.posterURL
        movie.backdropURL = self.backdropURL
        movie.trailerURL = self.trailerURL
        movie.budget = Int(self.budget)
        movie.voteAverage = self.voteAverage
        movie.voteCount = Int(self.voteCount)
        movie.favorite = self.favorite
        
        movie.persons = self.casts!.allObjects.compactMap({ ($0 as? PersonCD)?.person })
        
        movie.reviews = self.reviews!.allObjects.compactMap({ ($0 as? ReviewCD)?.review })
        
        return movie
    }

}
