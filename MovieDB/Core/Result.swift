//
//  Result.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 20/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(String)
}
