//
//  RemoteServerMappingTest.swift
//  MovieDBTests
//
//  Created by Eldar Goloviznin on 19/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import XCTest
@testable import MovieDB

class RemoteServerMappingTest: XCTestCase {

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
    
    func testMappingToMovie() {
               
    }
    
    func testRemoteMovieDetailsProvider() {
        let networkHelper = NetworkHelperMock()
        networkHelper.mockString = try! String(contentsOfFile: Bundle(for: RemoteServerMappingTest.self).path(forResource: "movieDetailsMock", ofType: "json")!)
        
        let remoteMovieDetailsProvider = RemoteMovieDetailsProvider(networkHelper: networkHelper)
        remoteMovieDetailsProvider.details(forMovieID: 0) { result in
            switch result {
            case .success(let details):
                print(details)
                
            case .error(let description):
                print(description)
            }
        }
    }
    
    func testRemotePersonDetailsProvider() {
        let networkHelper = NetworkHelperMock()
        networkHelper.mockString = try! String(contentsOfFile: Bundle(for: RemoteServerMappingTest.self).path(forResource: "personDetailsMock", ofType: "json")!)
        
        let remoteMovieDetailsProvider = RemotePersonDetailsProvider(networkHelper: networkHelper)
        remoteMovieDetailsProvider.details(forPersonID: 0) { result in
            switch result {
            case .success(let details):
                print(details)
                
            case .error(let description):
                print(description)
            }
        }
    }

}
