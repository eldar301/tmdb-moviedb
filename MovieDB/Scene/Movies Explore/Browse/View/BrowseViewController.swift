//
//  BrowseViewController.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 27/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import UIKit

class BrowseViewController: UITableViewController {
    
    fileprivate var presenter: BrowsePresenter!
    
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
        
        (tableView.tableHeaderView as? UIControl)?.addTarget(self, action: #selector(showDetails), for: .touchUpInside)
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.barStyle = .black
        searchController.searchBar.tintColor = .white
        searchController.searchBar.placeholder = "Title"
        self.navigationItem.searchController = searchController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
    
    @objc func showDetails() {
        presenter.showDetails()
    }
    
    fileprivate func updateHeader() {
        guard let header = self.tableView.tableHeaderView else {
            return
        }
        
        let headerWidth = header.bounds.width
        
        let headerHeight = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        
        header.frame = CGRect(origin: .zero, size: CGSize(width: headerWidth, height: headerHeight))
        
        tableView.tableHeaderView = header
    }
    
    @objc func refresh() {
        presenter.refresh()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.genresCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "genreCell", for: indexPath)
        
        cell.accessoryType = .disclosureIndicator
        
        cell.selectionStyle = .none
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = presenter.titleForGenre(atIndex: indexPath.row)
        cell.backgroundColor = .clear
        
        return cell        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.selectGenre(withIndex: indexPath.row)
    }
    
}

extension BrowseViewController: BrowseView {
    
    func update() {
        DispatchQueue.main.async {
            self.updateData()
        }
    }
    
    fileprivate func updateData() {
        tableView.refreshControl?.endRefreshing()
        
        randomMovieImageView.sd_cancelCurrentImageLoad()
        
        let configurator = presenter.randomMovieConfigurator()
        
        randomMovieImageView.sd_setImage(with: configurator.backdropURL)
        randomMovieTitle.text = configurator.title
        randomMovieOverview.text = configurator.overview
        randomMovieYearLabel.text = "\(configurator.year ?? 0)"
        
        if let voteAverage = configurator.voteAverage, let voteCount = configurator.voteCount {
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

extension BrowseViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
}
