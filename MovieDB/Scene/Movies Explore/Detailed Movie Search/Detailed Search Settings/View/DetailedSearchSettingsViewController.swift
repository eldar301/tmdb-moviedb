//
//  DetailedSearchSettingsViewController.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 01/09/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import UIKit

class DetailedSearchSettingsViewController: UITableViewController {
    
    var presenter: DetailedSearchSettingsPresenter!
    
    fileprivate weak var yearPicker: TwoThumbsSliderView!
    fileprivate weak var ratingPicker: TwoThumbsSliderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateHeader()
        
//        let configurator = presenter.configurator()
        
        yearPicker.minValue = 1900
        yearPicker.maxValue = 2018
        yearPicker.upperValue = 1980
        yearPicker.lowerValue = 1950
        yearPicker.highlightMode = .integer
        
        ratingPicker.minValue = 0.0
        ratingPicker.maxValue = 5.0
        ratingPicker.upperValue = 3.0
        ratingPicker.lowerValue = 2.0
        ratingPicker.highlightMode = .fractional
        
    }
    
    override func loadView() {
        loadTableView()
        loadHeaderTableView()
    }
    
    fileprivate func loadTableView() {
        self.tableView = UITableView()
        self.tableView.backgroundColor = .blue
        self.tableView.separatorColor = .black
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "sortCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "genreCell")
    }
    
    fileprivate func loadHeaderTableView() {
        let header = UIView()
        
        let selectYearRangeLabel = UILabel()
        selectYearRangeLabel.text = "Select the year range"
        selectYearRangeLabel.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(selectYearRangeLabel)
        
        let yearPicker = TwoThumbsSliderView()
        yearPicker.backgroundColor = .clear
        yearPicker.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(yearPicker)
        self.yearPicker = yearPicker
        
        let selectRatingLabel = UILabel()
        selectRatingLabel.text = "Select the rating"
        selectRatingLabel.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(selectRatingLabel)
        
        let ratingPicker = TwoThumbsSliderView()
        ratingPicker.backgroundColor = .clear
        ratingPicker.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(ratingPicker)
        self.ratingPicker = ratingPicker
        
        let margins = header.layoutMarginsGuide
        
        selectYearRangeLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        selectYearRangeLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true

        yearPicker.heightAnchor.constraint(equalToConstant: 64.0).isActive = true
        yearPicker.topAnchor.constraint(equalTo: selectYearRangeLabel.bottomAnchor, constant: 30.0).isActive = true
        yearPicker.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 20.0).isActive = true
        yearPicker.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -20.0).isActive = true
        
        
        selectRatingLabel.topAnchor.constraint(equalTo: yearPicker.bottomAnchor, constant: 8.0).isActive = true
        selectRatingLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        
        
        ratingPicker.heightAnchor.constraint(equalToConstant: 64.0).isActive = true
        ratingPicker.topAnchor.constraint(equalTo: selectRatingLabel.bottomAnchor, constant: 30.0).isActive = true
        ratingPicker.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 20.0).isActive = true
        ratingPicker.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -20.0).isActive = true
        ratingPicker.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        
        self.tableView.tableHeaderView = header
    }
    
    fileprivate func updateHeader() {
        let header = self.tableView.tableHeaderView!
        let headerWidth = header.bounds.width
        
        let headerHeight = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        
        header.frame = CGRect(origin: .zero, size: CGSize(width: headerWidth, height: headerHeight))
        
        self.tableView.tableHeaderView = header
    }

}
