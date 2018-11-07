//
//  PersonDetailsProvider.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 19/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

typealias PersonDetails = (person: Person, movies: [Movie])

protocol PersonDetailsProvider {
    func details(forPersonID: Int, completion: @escaping (Result<PersonDetails>) -> ())
}
