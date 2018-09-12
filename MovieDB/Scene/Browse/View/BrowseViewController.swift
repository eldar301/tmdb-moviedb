//
//  BrowseViewController.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 27/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import UIKit

class BrowseViewController: UITableViewController {
    
    var presenter: BrowsePresenter!
    
    //    fileprivate var requestedRandomMovieImageURL: URL?
    
    @IBOutlet weak var randomMovieImageView: UIImageView!
    
    @IBOutlet weak var randomMovieTitle: UILabel!
    
    @IBOutlet weak var randomMovieRatingView: RatingView!
    
    @IBOutlet weak var randomMovieYearLabel: UILabel!
    
    @IBOutlet weak var randomMovieOverview: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = BrowsePresenterDefault(router: Router(viewController: self), randomMovieProvider: RemoteRandomMovieProvider(moviesProvider: RemoteMoviesProvider(networkHelper: NetworkHelperDefault())))
        
        presenter.view = self
        presenter.refresh()
        
        randomMovieImageView.contentMode = .scaleAspectFill
        randomMovieImageView.clipsToBounds = true
        randomMovieImageView.layer.cornerRadius = 8.0
        
        randomMovieTitle.adjustsFontSizeToFitWidth = true
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.separatorColor = .black
        
        self.extendedLayoutIncludesOpaqueBars = true
        self.edgesForExtendedLayout = .top
        
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        (tableView.tableHeaderView as? UIControl)?.addTarget(self, action: #selector(showRandomMovieDetails), for: .touchUpInside)
        
        presenter.loadSearchResultsScene()
        
        self.definesPresentationContext = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationItem.hidesSearchBarWhenScrolling = true
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        // simple hack to remove search bar glitch when popping back from child view controller (for example movie details vc)
        self.navigationItem.searchController?.searchBar.superview?.subviews.first?.isHidden = true
        //        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    //    override func viewDidDisappear(_ animated: Bool) {
    //        super.viewDidDisappear(animated)
    //
    //        self.navigationItem.searchController?.searchBar.superview?.subviews.first?.isHidden = true
    //    }
    
    @objc func showRandomMovieDetails() {
        presenter.showRandomMovieDetails()
    }
    
    fileprivate func updateHeader() {
        let header = self.tableView.tableHeaderView!
        
        let headerWidth = header.bounds.width
        
        let headerHeight = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        
        header.frame = CGRect(origin: .zero, size: CGSize(width: headerWidth, height: headerHeight))
        
        tableView.tableHeaderView = header
    }
    
    @objc func refresh() {
        presenter.refresh()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.genres.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "genreCell", for: indexPath)
        
        cell.accessoryType = .disclosureIndicator
        
        cell.selectionStyle = .none
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = presenter.genres[indexPath.row].localizedString
        cell.backgroundColor = .clear
        
        return cell        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.select(genre: presenter.genres[indexPath.row])
    }
    
}

extension BrowseViewController: BrowseView {
    
    func update(withRandomMovie movie: Movie) {
        tableView.refreshControl?.endRefreshing()
        
        randomMovieImageView.sd_cancelCurrentImageLoad()
        
        randomMovieImageView.sd_setImage(with: movie.backdropURL ?? movie.posterURL)
        randomMovieTitle.text = movie.title
        randomMovieOverview.text = movie.overview
        
        if let releaseDate = movie.releaseDate {
            let year = Calendar.current.component(.year, from: releaseDate)
            randomMovieYearLabel.text = "\(year)"
        }
        
        if let voteAverage = movie.voteAverage, let voteCount = movie.voteCount {
            randomMovieRatingView.rating = CGFloat(voteAverage)
            randomMovieRatingView.votesCount = voteCount
        }
        
        updateHeader()
    }
    
    func showError(description: String) {
        tableView.refreshControl?.endRefreshing()
        print(description)
    }
    
}

extension BrowseViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let title = searchBar.text!
        (self.navigationItem.searchController?.searchResultsController as? TitleMovieSearchViewController)?.search(title: title)
    }
    
}

extension BrowseViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let title = searchController.searchBar.text!
        if title.last == " " {
            (self.navigationItem.searchController?.searchResultsController as? TitleMovieSearchViewController)?.search(title: title)
        }
    }
    
}
