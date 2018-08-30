//
//  PagedProvider
//  MovieDB
//
//  Created by Eldar Goloviznin on 20/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON

class PagedProvider<T: EntityRS> {
    
    fileprivate let networkHelper: NetworkHelper
    
    fileprivate let apiEndpoint: PaginationSearchAPI
    
    init(apiEndpoint: PaginationSearchAPI, networkHelper: NetworkHelper) {
        self.apiEndpoint = apiEndpoint
        self.networkHelper = networkHelper
    }
    
    fileprivate var currentPage: Int = 0
    fileprivate var requestedPage: Int?
    fileprivate var totalPages: Int?
    
    fileprivate var results: [T.Entity] = []
    
    func fetchNext(completition: @escaping (Result<[T.Entity]>) -> ()) {
        if let requestedPage = self.requestedPage {
            guard currentPage == requestedPage else {
                print("Attempt to get next page, when previous one is not loaded yet")
                return
            }
        }
        
        if let totalPages = self.totalPages {
            guard currentPage < totalPages else {
                print("Attempt to get next page, but reached the end")
                return
            }
        }
        
        requestedPage = currentPage + 1
        
        let nextRequest = apiEndpoint.urlRequest(page: requestedPage!)
        
        networkHelper.jsonTask(request: nextRequest) { [weak self] result in
            guard self != nil else {
                return
            }
            
            switch result {
            case .success(let json):
                self?.update(withJSON: json)
                
                let newValues = Mapper<T>()
                    .mapArray(JSONObject: json["results"].rawValue)!
                    .compactMap({ $0.entity })
                
                self?.results += newValues
                
                completition(.success(self!.results))
                
            case .error(let description):
                self?.resetRequest()
                
                completition(.error(description))
            }
        }
    }
    
    fileprivate func resetRequest() {
        print("Resetting requested page to current page state")
        requestedPage = currentPage
    }
    
    fileprivate func update(withJSON json: JSON) {
        print("Updating current page and total pages")
        currentPage = json["page"].int!
        totalPages = json["total_pages"].int!
    }
    
}
