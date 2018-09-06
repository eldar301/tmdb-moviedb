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
        
        for index in configurator.selectedGenreIndices {
            self.tableView.selectRow(at: IndexPath(row: index, section: 1), animated: false, scrollPosition: .none)
        }
        
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
        setupTableView()
        loadHeaderTableView()
        loadSearchButton()
    }
    
    fileprivate func setupTableView() {
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
        header.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.tableHeaderView = header

        let cancelButton = UIButton()
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cancelButton)

        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
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
        
        cancelButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        cancelButton.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: selectYearRangeLabel.bottomAnchor).isActive = true
        
        selectYearRangeLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        selectYearRangeLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        
        yearPicker.heightAnchor.constraint(equalToConstant: 64.0).isActive = true
        yearPicker.topAnchor.constraint(equalTo: selectYearRangeLabel.bottomAnchor, constant: 45.0).isActive = true
        yearPicker.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 20.0).isActive = true
        yearPicker.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -20.0).isActive = true
        
        selectRatingLabel.topAnchor.constraint(equalTo: yearPicker.bottomAnchor, constant: 8.0).isActive = true
        selectRatingLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        
        ratingPicker.heightAnchor.constraint(equalToConstant: 64.0).isActive = true
        ratingPicker.topAnchor.constraint(equalTo: selectRatingLabel.bottomAnchor, constant: 45.0).isActive = true
        ratingPicker.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 20.0).isActive = true
        ratingPicker.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -20.0).isActive = true
        ratingPicker.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    fileprivate func loadSearchButton() {
        let footerView = UIView()
        footerView.frame = CGRect(origin: .zero, size: CGSize(width: self.tableView.bounds.width, height: 100.0))
        
        let searchButton = UIButton()
        searchButton.setTitle("Search", for: .normal)
        searchButton.titleLabel?.textAlignment = .center
        searchButton.layer.cornerRadius = 10.0
        searchButton.layer.borderColor = UIColor.white.cgColor
        searchButton.layer.borderWidth = 0.5
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        footerView.addSubview(searchButton)
        
        searchButton.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
        searchButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
        searchButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        
        searchButton.addTarget(self, action: #selector(doSearch), for: .touchUpInside)
        
        self.tableView.tableFooterView = footerView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateHeader()
    }
    
    fileprivate func updateHeader() {
        let header = self.tableView.tableHeaderView!
        let headerWidth = self.tableView.bounds.width
        
        let tempConstraint = header.widthAnchor.constraint(equalTo: self.tableView!.widthAnchor)
        tempConstraint.isActive = true
    
        let headerHeight = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height

        header.frame = CGRect(origin: header.frame.origin, size: CGSize(width: headerWidth, height: headerHeight))

        self.tableView.tableHeaderView = header
        
        header.removeConstraint(tempConstraint)
    }
    
}

extension DetailedSearchSettingsViewController {
    
    @objc func doSearch() {
        let selectedYearFrom = yearPicker.intLowerValue
        let selectedYearTo = yearPicker.intUpperValue
        
        let selectedRatingFrom = ratingPicker.lowerValue
        let selectedRatingTo = ratingPicker.upperValue
        
        let selectedTableRows = self.tableView.indexPathsForSelectedRows!
        
        let selectedSortIndex = selectedTableRows.first(where: { $0.section == 0 })!.row - 1
        
        let selectedGenresIndices = selectedTableRows.compactMap({ $0.section == 1 ? $0.row : nil })
        
        presenter.setup(fromYear: selectedYearFrom,
                        toYear: selectedYearTo,
                        fromRating: selectedRatingFrom,
                        toRating: selectedRatingTo,
                        sortOptionIndex: selectedSortIndex,
                        genreOptionsIndices: selectedGenresIndices)
    }
    
    @objc func cancel() {
        presenter.cancel()
    }
    
}

extension DetailedSearchSettingsViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? configurator.sortOptions.count + 2 : configurator.genreOptions.count
    }
    
    override func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section != 0 {
            return indexPath
        } else {
            return nil
        }
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
        cell.textLabel?.textAlignment = .natural
        
        let index = indexPath.row
        let section = indexPath.section
        
        if section == 0 {
            var text: String
            if index == 0 {
                text = "Sort by"
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 19.0)
                cell.textLabel?.textAlignment = .center
            } else if index < configurator.sortOptions.count + 1 {
                text = configurator.sortOptions[index - 1]
            } else {
                text = "Genres"
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 19.0)
                cell.textLabel?.textAlignment = .center
            }
            
            cell.textLabel?.text = text
        } else {
            cell.textLabel?.text = configurator.genreOptions[index]
        }
        
        return cell
    }
    
}
