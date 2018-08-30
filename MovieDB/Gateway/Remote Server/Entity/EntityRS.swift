//
//  EntityRS.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 30/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation
import ObjectMapper

protocol EntityRS: Mappable {
    associatedtype Entity
    var entity: Entity { get }
}

