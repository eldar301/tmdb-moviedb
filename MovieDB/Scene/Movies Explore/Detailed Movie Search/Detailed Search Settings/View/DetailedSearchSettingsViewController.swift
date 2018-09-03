//
//  DetailedSearchSettingsViewController.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 01/09/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import UIKit

class DetailedSearchSettingsViewController: UITableViewController {
    
    var presenter: DetailedSearchSettingsPresenter! {
        didSet {
            configurator = presenter.configurator()
        }
    }
    
    fileprivate weak var yearPicker: TwoThumbsSliderView!
    fileprivate weak var ratingPicker: TwoThumbsSliderView!
    
    fileprivate var configurator: DetailedSearchSettingsConfigurator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(SelectableTableViewCell.self, forCellReuseIdentifier: "reuseCell")
        self.tableView.allowsMultipleSelection = true
        
        self.tableView.selectRow(at: IndexPath(row: configurator.selectedSortOptionIndex + 1, section: 0), animated: false, scrollPosition: .none)
        
        self.tableView.selectRow(at: IndexPath(row: configurator.selectedGenreIndex, section: 1), animated: false, scrollPosition: .none)
        
        updateHeader()
        
        yearPicker.minValue = Double(configurator.minYear)
        yearPicker.maxValue = Double(configurator.maxYear)
        yearPicker.upperValue = Double(configurator.maxChosenYear)
        yearPicker.lowerValue = Double(configurator.minChosenYear)
        yearPicker.highlightMode = .integer
        
        ratingPicker.minValue = configurator.minRating
        ratingPicker.maxValue = configurator.maxRating
        ratingPicker.upperValue = configurator.maxChosenRating
        ratingPicker.lowerValue = configurator.minChosenRating
        ratingPicker.highlightMode = .fractional
    }
    
    override func loadView() {
        loadTableView()
        loadHeaderTableView()
    }
    
    fileprivate func loadTableView() {
        self.tableView = UITableView()
        self.tableView.backgroundColor = UIColor(red: 9.0 / 255.0,
                                                 green: 18.0 / 250.0,
                                                 blue: 27.0 / 255.0,
                                                 alpha: 1.0)
        self.tableView.separatorColor = .black
        self.tableView.bounces = false
    }
    
    fileprivate func loadHeaderTableView() {
        let header = UIView()
        
        let selectYearRangeLabel = UILabel()
        selectYearRangeLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        selectYearRangeLabel.textColor = .white
        selectYearRangeLabel.text = "Select the year range"
        selectYearRangeLabel.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(selectYearRangeLabel)
        
        let yearPicker = TwoThumbsSliderView()
        yearPicker.backgroundColor = .clear
        yearPicker.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(yearPicker)
        self.yearPicker = yearPicker
        
        let selectRatingLabel = UILabel()
        selectRatingLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        selectRatingLabel.textColor = .white
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

extension DetailedSearchSettingsViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? configurator.sortOptions.count + 2 : configurator.genreOptions.count
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard indexPath.section == 0 else {
            return indexPath
        }
        
        guard indexPath.row != 0 && indexPath.row != configurator.sortOptions.count + 1 else {
            return nil
        }
        
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt selectedIndexPath: IndexPath) {
        if selectedIndexPath.section == 0, let selectedIndexPaths = self.tableView.indexPathsForSelectedRows {
            for indexPath in selectedIndexPaths where indexPath.section == 0 && indexPath != selectedIndexPath {
                self.tableView.deselectRow(at: indexPath, animated: false)
            }
        }
    }
    
}

extension DetailedSearchSettingsViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell", for: indexPath)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17.0)
        cell.textLabel?.textColor = .white
        cell.tintColor = .white
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        let index = indexPath.row
        let section = indexPath.section
        
        if section == 0 {
            var text: String
            if index == 0 {
                text = "Sort by"
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 19.0)
            } else if index < configurator.sortOptions.count + 1 {
                text = configurator.sortOptions[index - 1]
            } else {
                text = "Genres"
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 19.0)
            }
            
            cell.textLabel?.text = text
        } else {
            cell.textLabel?.text = configurator.genreOptions[index]
        }
        
        return cell
    }
    
}
