//
//  API.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 19/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

struct APIHelper {
    
    struct BackdropSize {
        static let w300 = "w300"
        static let w780 = "w780"
        static let w1280 = "w1280"
        static let original = "original"
    }
    
    struct PosterSize {
        static let w92 = "w92"
        static let w154 = "w154"
        static let w185 = "w185"
        static let w342 = "w342"
        static let w500 = "w500"
        static let w780 = "w780"
        static let original = "original"
    }
    
    struct ProfileSize {
        static let w45 = "w45"
        static let w185 = "w185"
        static let h632 = "h632"
        static let original = "original"
    }
    
    static func id(forGenre genre: Genre) -> Int {
        switch genre {
        case .action:         return 28
        case .adventure:      return 12
        case .animation:      return 16
        case .comedy:         return 35
        case .crime:          return 80
        case .documentary:    return 99
        case .drama:          return 18
        case .family:         return 10751
        case .fantasy:        return 14
        case .history:        return 36
        case .horror:         return 27
        case .music:          return 10402
        case .mystery:        return 9648
        case .romance:        return 10749
        case .scienceFiction: return 878
        case .tvMovie:        return 10770
        case .thriller:       return 53
        case .war:            return 10752
        case .western:        return 37
        }
    }
    
    static func genre(forID id: Int) -> Genre? {
        switch id {
        case 28:        return .action
        case 12:        return .adventure
        case 16:        return .animation
        case 35:        return .comedy
        case 80:        return .crime
        case 99:        return .documentary
        case 18:        return .drama
        case 10751:     return .family
        case 14:        return .fantasy
        case 36:        return .history
        case 27:        return .horror
        case 10402:     return .music
        case 9648:      return .mystery
        case 10749:     return .romance
        case 878:       return .scienceFiction
        case 10770:     return .tvMovie
        case 53:        return .thriller
        case 10752:     return .war
        case 37:        return .western
            
        default: return nil
        }
    }
    
    static func gender(forID id: Int?) -> Gender? {
        switch id {
        case 0: return .male
        case 1: return .female
        default: return nil
        }
    }
    
    static func url(forYoutubeKey key: String?) -> URL? {
        guard let key = key else {
            return nil
        }
        
        return URL(string: "https://www.youtube.com/watch?v=\(key)")
    }
    
    static func url(forEndpoint endpoint: String, queries: [String: String]) -> URL {
        let region = NSLocale().localeIdentifier.replacingOccurrences(of: "_", with: "-")
        let includeAdult = "false"
        
        var configurator = URLComponents(string: API.baseURL + endpoint)!
        
        configurator.queryItems = [URLQueryItem(name: "api_key", value: API.apiKey),
                                   URLQueryItem(name: "region", value: region),
                                   URLQueryItem(name: "include_adult", value: includeAdult)]
        
        for query in queries {
            configurator.queryItems?.append(URLQueryItem(name: query.key, value: query.value))
        }
        
        return configurator.url!
    }
    
    static func url(forPath path: String?, withSize size: String) -> URL? {
        guard let path = path else {
            return nil
        }
        return URL(string: API.imageBaseURL + "/\(size)\(path)")!
    }
    
}

struct API {
    
    fileprivate static let apiKey = "c10c04cb3d4049b358a035c060a8502c"
    fileprivate static let baseURL = "https://api.themoviedb.org/3/"
    
    fileprivate static let imageBaseURL = "https://image.tmdb.org/t/p"
    
}
