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
            if let configurator = presenter?.configurator() {
                self.configurator = configurator
                self.configure()
            }
        }
    }
    
    private weak var yearPicker: TwoThumbsSliderView!
    private weak var ratingPicker: TwoThumbsSliderView!
    
    private var configurator: DetailedSearchSettingsConfigurator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(SelectableTableViewCell.self, forCellReuseIdentifier: Constants.Strings.reuseIdentifier)
        self.tableView.allowsMultipleSelection = true
        
        self.tableView.selectRow(at: IndexPath(row: configurator.selectedSortOptionIndex + 1, section: 0), animated: false, scrollPosition: .none)
    }
    
    private func configure() {
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
    
    private func setupTableView() {
        self.tableView = UITableView()
        self.tableView.backgroundColor = Constants.Colors.backgroundColor
        self.tableView.separatorColor = .black
        self.tableView.bounces = false
    }
    
    private func loadHeaderTableView() {
        let header = UIView()
        header.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.tableHeaderView = header
        header.topAnchor.constraint(equalTo: self.tableView.topAnchor).isActive = true
        
        let cancelButton = UIButton()
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        cancelButton.titleLabel?.font = Constants.Fonts.regularFont
        cancelButton.setTitle(Constants.Strings.cancel, for: .normal)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cancelButton)
        
        let selectYearRangeLabel = UILabel()
        selectYearRangeLabel.font = Constants.Fonts.boldFont
        selectYearRangeLabel.textColor = .white
        selectYearRangeLabel.text = Constants.Strings.selectTheYearRange
        selectYearRangeLabel.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(selectYearRangeLabel)
        
        let yearPicker = TwoThumbsSliderView()
        yearPicker.backgroundColor = .clear
        yearPicker.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(yearPicker)
        self.yearPicker = yearPicker
        
        let selectRatingLabel = UILabel()
        selectRatingLabel.font = Constants.Fonts.boldFont
        selectRatingLabel.textColor = .white
        selectRatingLabel.text = Constants.Strings.selectTheRating
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
        
        yearPicker.heightAnchor.constraint(equalToConstant: Constants.Sizes.Picker.height).isActive = true
        yearPicker.topAnchor.constraint(equalTo: selectYearRangeLabel.bottomAnchor, constant: Constants.Sizes.Picker.topAnchorConstant).isActive = true
        yearPicker.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: Constants.Sizes.Picker.leadingAnchorConstant).isActive = true
        yearPicker.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: Constants.Sizes.Picker.trailingAnchorConstant).isActive = true
        
        selectRatingLabel.topAnchor.constraint(equalTo: yearPicker.bottomAnchor, constant: Constants.Sizes.RatingLabel.topAnchorConstant).isActive = true
        selectRatingLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        
        ratingPicker.heightAnchor.constraint(equalToConstant: Constants.Sizes.Picker.height).isActive = true
        ratingPicker.topAnchor.constraint(equalTo: selectRatingLabel.bottomAnchor, constant: Constants.Sizes.Picker.topAnchorConstant).isActive = true
        ratingPicker.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: Constants.Sizes.Picker.leadingAnchorConstant).isActive = true
        ratingPicker.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: Constants.Sizes.Picker.trailingAnchorConstant).isActive = true
        ratingPicker.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    private func loadSearchButton() {
        let footerView = UIView()
        footerView.frame = CGRect(origin: .zero, size: CGSize(width: self.tableView.bounds.width, height: Constants.Sizes.FooterView.height))
        
        let searchButton = UIButton()
        searchButton.setTitle(Constants.Strings.search, for: .normal)
        searchButton.titleLabel?.textAlignment = .center
        searchButton.layer.borderColor = UIColor.white.cgColor
        searchButton.layer.cornerRadius = Constants.Sizes.SearchButton.cornerRadius
        searchButton.layer.borderWidth = Constants.Sizes.SearchButton.borderWidth
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        footerView.addSubview(searchButton)
        
        searchButton.widthAnchor.constraint(equalToConstant: Constants.Sizes.SearchButton.width).isActive = true
        searchButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
        searchButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        
        searchButton.addTarget(self, action: #selector(doSearch), for: .touchUpInside)
        
        self.tableView.tableFooterView = footerView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateHeader()
    }
    
    private func updateHeader() {
        let header = self.tableView.tableHeaderView!
        let headerWidth = self.tableView.bounds.width
        
        let temp = header.leadingAnchor.constraint(equalTo: self.tableView.leadingAnchor)
        temp.isActive = true
        
        let tempConstraint = header.widthAnchor.constraint(equalTo: self.tableView.widthAnchor)
        tempConstraint.isActive = true
        
        let headerHeight = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        
        header.frame = CGRect(origin: header.frame.origin, size: CGSize(width: headerWidth, height: headerHeight))
        
        self.tableView.tableHeaderView = header
        
        header.removeConstraint(tempConstraint)
        header.removeConstraint(temp)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Strings.reuseIdentifier, for: indexPath)
        cell.textLabel?.font = Constants.Fonts.regularFont
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
                text = Constants.Strings.sortBy
                cell.textLabel?.font = Constants.Fonts.tableviewSectionFont
                cell.textLabel?.textAlignment = .center
            } else if index < configurator.sortOptions.count + 1 {
                text = configurator.sortOptions[index - 1]
            } else {
                text = Constants.Strings.genres
                cell.textLabel?.font = Constants.Fonts.tableviewSectionFont
                cell.textLabel?.textAlignment = .center
            }
            
            cell.textLabel?.text = text
        } else {
            cell.textLabel?.text = configurator.genreOptions[index]
        }
        
        return cell
    }
    
}

fileprivate struct Constants {
    struct Strings {
        static let reuseIdentifier = "reuseCell"
        static let cancel = NSLocalizedString("Cancel", comment: #file)
        static let selectTheYearRange = NSLocalizedString("Select the year range", comment: #file)
        static let selectTheRating = NSLocalizedString("Select the rating", comment: #file)
        static let search = NSLocalizedString("Search", comment: #file)
        static let sortBy = NSLocalizedString("Sort by", comment: #file)
        static let genres = NSLocalizedString("Genres", comment: #file)
    }
    struct Sizes {
        struct Picker {
            static let height: CGFloat = 64.0
            static let topAnchorConstant: CGFloat = 45.0
            static let leadingAnchorConstant: CGFloat = 20.0
            static let trailingAnchorConstant: CGFloat = -20.0
        }
        struct RatingLabel {
            static let topAnchorConstant: CGFloat = 8.0
        }
        struct FooterView {
            static let height: CGFloat = 100.0
        }
        struct SearchButton {
            static let cornerRadius: CGFloat = 12.0
            static let borderWidth: CGFloat = 0.5
            static let width: CGFloat = 150.0
        }
    }
    struct Colors {
        static let backgroundColor: UIColor = UIColor(red: 18.0 / 255.0,
                                                      green: 27.0 / 255.0,
                                                      blue: 36.0 / 255.0,
                                                      alpha: 1.0)
    }
    struct Fonts {
        static let regularFont = UIFont(name: "AvenirNext-Regular", size: 17.0)
        static let boldFont = UIFont(name: "AvenirNext-Bold", size: 17.0)
        static let tableviewSectionFont = UIFont(name: "AvenirNext-Regular", size: 19.0)
    }
}
