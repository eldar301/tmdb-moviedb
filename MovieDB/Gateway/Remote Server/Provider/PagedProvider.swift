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

protocol PagedDelegate: class {
    var nextRequest: URLRequest? { get }
}

class PagedProvider<T: Mappable> {
    
    fileprivate let networkHelper: NetworkHelper
    
    init(networkHelper: NetworkHelper) {
        self.networkHelper = networkHelper
    }

    var nextPage: Int {
        return currentPage + 1
    }
    
    weak var delegate: PagedDelegate?
    
    fileprivate var currentPage: Int = 0
    fileprivate var requestedPage: Int?
    fileprivate var totalPages: Int?
    
    func reset() {
        currentPage = 0
        requestedPage = nil
        totalPages = nil
    }
    
    func fetchNext(completition: @escaping (Result<[T]>) -> ()) {
        guard let nextRequest = delegate?.nextRequest else {
            return
        }
        
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
        
        networkHelper.jsonTask(request: nextRequest) { [weak self] result in
            switch result {
            case .success(let json):
                self?.update(withJSON: json)
                
                let values = Mapper<T>()
                    .mapArray(JSONObject: json["results"].rawValue)!
                
                completition(.success(values))
                
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
