//
//  APITest.swift
//  MovieDBTests
//
//  Created by Eldar Goloviznin on 19/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import XCTest
@testable import MovieDB

class SearchAPITest: XCTestCase {
    
    private let apiKey = "c10c04cb3d4049b358a035c060a8502c"
    private let baseURL = "https://api.themoviedb.org/3/"
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testSearchByTitle() {
        let title = "Iron Man"
        
        let region = NSLocale().localeIdentifier.replacingOccurrences(of: "_", with: "-")
        
        let expectedURL = baseURL + "search/movie?api_key=\(apiKey)&region=\(region)&include_adult=false&query=\(title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
        
        XCTAssertEqual(URLRequest(url: URL(string: expectedURL)!), MovieSearchAPI.search(title: title).urlRequest)
    }
    
    func testDetailedSearch() {
        let region = NSLocale().localeIdentifier.replacingOccurrences(of: "_", with: "-")
        
        let page = Int.random(in: 1 ... 500)
        
        let genres = [Genre.adventure]
        let convertedGenres = genres.map({ "\($0.rawValue)" }).joined(separator: ",")
        
        let ratingRange = (5.5, 10.0)
        let yearRange = (1900, 2018)
        
        let sortBy = SortBy.popularityDescending
        
        var expectedQueries = [URLQueryItem(name: "api_key", value: apiKey),
                               URLQueryItem(name: "region", value: region),
                               URLQueryItem(name: "include_adult", value: "false"),
                               URLQueryItem(name: "page", value: "\(page)"),
                               URLQueryItem(name: "with_genres", value: convertedGenres),
                               URLQueryItem(name: "vote_average.lte", value: "\(ratingRange.1)"),
                               URLQueryItem(name: "vote_average.gte", value: "\(ratingRange.0)"),
                               URLQueryItem(name: "release_date.lte", value: "\(yearRange.1)"),
                               URLQueryItem(name: "release_date.gte", value: "\(yearRange.0)"),
                               URLQueryItem(name: "sort_by", value: sortBy.rawValue)]
        
        var resolvedQueries = URLComponents(url:
            MovieSearchAPI.detailedSearch(page: page,
                                     genres: genres,
                                     ratingRange: ratingRange,
                                     yearRange: yearRange,
                                     sortBy: sortBy).urlRequest.url!, resolvingAgainstBaseURL: false)!
                                    .queryItems!
        
        expectedQueries.sort(by: { $0.name > $1.name })
        resolvedQueries.sort(by: { $0.name > $1.name })
        
        XCTAssertEqual(expectedQueries, resolvedQueries)
    }
    
}
