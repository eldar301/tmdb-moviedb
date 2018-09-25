//
//  DetailedMovieSearchViewController.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 03/09/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import UIKit

class DetailedMovieSearchViewController: UITableViewController {
    
    var presenter: DetailedMovieSeachPresenter!
    
    fileprivate var movies: [Movie] = []
    
    fileprivate var cachedCellHeights: [IndexPath: CGFloat] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.view = self
        presenter.request()
        
        self.navigationItem.largeTitleDisplayMode = .never
        
        self.extendedLayoutIncludesOpaqueBars = false
        
        let specifyButton = UIBarButtonItem()
        specifyButton.title = "Specify"
        specifyButton.target = self
        specifyButton.action = #selector(showDetailedSearchSettings)
        self.navigationItem.rightBarButtonItem = specifyButton
        
        self.tableView.register(MovieCell.self, forCellReuseIdentifier: "MovieCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = presenter.title
    }
    
    override func loadView() {
        self.tableView = UITableView()
        self.tableView.separatorColor = .clear
        self.tableView.backgroundColor = UIColor(red: 18.0 / 255.0,
                                                 green: 27.0 / 255.0,
                                                 blue: 36.0 / 255.0,
                                                 alpha: 1.0)
    }
    
    @objc func showDetailedSearchSettings() {
        presenter.showDetailedSearchSettings()
    }
    
}

extension DetailedMovieSearchViewController: MoviesExploreView {
    
    func updateWithNewMovies(movies: [Movie]) {
        self.cachedCellHeights.removeAll()
        self.movies = movies
        self.tableView.reloadData()
        
        if !movies.isEmpty {
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    func updateWithAdditionalMovies(movies: [Movie]) {
        let addRange = (self.movies.count ..< movies.count)
        self.movies = movies
        self.tableView.beginUpdates()
        self.tableView.insertSections(IndexSet(integersIn: addRange), with: .none)
        self.tableView.endUpdates()
    }
    
    func showError(description: String) {
        print(description)
    }
    
}

extension DetailedMovieSearchViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = movies[indexPath.section]
        
        cell.selectionStyle = .none
        
        cell.configure(withMovie: movie)
        
        return cell
    }
    
}

extension DetailedMovieSearchViewController {
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cachedCellHeights[indexPath] ?? 200.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.showDetails(movie: movies[indexPath.section])
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cachedCellHeights[indexPath] = cell.bounds.height
        if indexPath.section + 4 >= movies.count {
            presenter.requestNext()
        }
    }
    
}
