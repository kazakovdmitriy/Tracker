//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Дмитрий on 20.06.2024.
//

import UIKit

final class TrackersViewController: BaseController {
    
    // MARK: - Private Properties
    private let dateFormatter = DateFormatter()
    private var currentDate: Date = Date()
    private let calendar = Calendar(identifier: .gregorian)
    
    private var categories: [TrackerCategory] = Mocks.categories
    private var completedTrackers: Set<TrackerRecord> = Mocks.completedTrackers
    
    private var trackerCategoriesList: [String] {
        var trackerCategories: [String] = []
        
        for category in categories {
            trackerCategories.append(category.name)
        }
        
        return trackerCategories
    }
    
    private lazy var trackerStubView = StubView()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        
        searchBar.placeholder = "Поиск"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        // Убираем серые полосы вокруг поиска
        searchBar.backgroundColor = .clear
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.searchTextField.textColor = .ypBlack
        
        return searchBar
    }()
    
    private lazy var addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                                 target: self,
                                                 action: #selector(addButtonTapped))
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.locale = Locale(identifier: "ru_RU")
        picker.calendar.firstWeekday = 2
        picker.tintColor = .ypBlue
        picker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        return picker
    }()
    
    private let collectionLayout = UICollectionViewFlowLayout()
    private let collectionDelegate = TrackerCollectionViewDelegate()
    private lazy var collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: collectionLayout)
}

// MARK: - Setup View
extension TrackersViewController {
    override func setupViews() {
        super.setupViews()
        
        setupNavigationBar()
        
        view.setupView(searchBar)
        view.setupView(collectionView)
        view.setupView(trackerStubView)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            trackerStubView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackerStubView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        
        searchBar.delegate = self
        
        addButton.tintColor = .ypBlack
        
        let emptyImage = UIImage(named: "empty_trackers_image") ?? UIImage()
        trackerStubView.configure(with: "Что будем отслеживать?", and: emptyImage)
        
        // Проверка есть ли трекеры для текущего дня
        let todayCategories = filterTrackersForToday()
        
        changeStateStubView(isHidden: !todayCategories.isEmpty)
        
//        if !todayCategories.isEmpty {
//            hideStubView()
//        } else {
//            showStubView()
//        }
        
        configureCollectionView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    private func changeStateStubView(isHidden: Bool) {
        trackerStubView.isHidden = isHidden
        collectionView.isHidden = !isHidden
    }
    
    private func setupNavigationBar() {
        // Устанавливаем крупный заголовок
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = R.Strings.NavBar.trackers
        
        navigationItem.leftBarButtonItem = addButton
        
        // Создаем и добавляем label для даты справа
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
    }
    
    private func configureCollectionView() {
        
        collectionLayout.itemSize = CGSize(width: view.frame.width - 20, height: 100)
        collectionLayout.minimumLineSpacing = 10
        
        collectionDelegate.categories = filterTrackersForToday()
        collectionDelegate.completedTrackers = completedTrackers
        collectionDelegate.currentDate = currentDate
        
        collectionView.backgroundColor = .clear
        
        collectionView.delegate = collectionDelegate
        collectionView.dataSource = collectionDelegate
        collectionView.register(TrackerCardView.self,
                                forCellWithReuseIdentifier: TrackerCardView.reuseIdentifier)
        collectionView.register(TrackerSectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: TrackerSectionHeader.reuseIdentifier)
        
        collectionDelegate.completedTrackers = completedTrackers
    }
}

// MARK: - CreateBaseContollerDelegate
extension TrackersViewController: CreateBaseControllerDelegate {
    func didTapCreateTrackerButton(category: String, 
                                   tracker: Tracker) {
        let newCategory = createNewTrackerList(to: category, tracker: tracker)
        categories = newCategory
        let todaysCategory = filterTrackersForToday()
        updateCollectionView(with: todaysCategory)
    }
    
    private func createNewTrackerList(to categoryName: String, 
                                      tracker: Tracker) -> [TrackerCategory] {
        
        var newCategories = categories
        
        if let index = newCategories.firstIndex(where: { $0.name == categoryName }) {
            // Категория уже существует, создаём новый экземпляр категории с добавленным трекером
            let category = categories[index]
            var newTrackers = category.trackers
            newTrackers.append(tracker)
            let updatedCategory = TrackerCategory(name: category.name, trackers: newTrackers)
            newCategories[index] = updatedCategory
        } else {
            // Категории не существует, создаём новую категорию и добавляем трекер
            let newCategory = TrackerCategory(name: categoryName, trackers: [tracker])
            newCategories.append(newCategory)
        }
        
        return newCategories
    }
}

// MARK: - Selectors
private extension TrackersViewController {
    @objc func addButtonTapped() {
        let createTrackerViewController = CreateTrackerViewController()
        createTrackerViewController.modalPresentationStyle = .popover
        createTrackerViewController.delegate = self
        
        present(createTrackerViewController, animated: true)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        
        let currentWeek = calendar.component(.weekday, from: currentDate)
        let choiseWeek = calendar.component(.weekday, from: sender.date)
        
        if currentWeek == choiseWeek {
            collectionView.reloadData()
        }
        
        let selectedDate = sender.date
        currentDate = selectedDate
        collectionDelegate.currentDate = currentDate
        
        let newCategories = filterTrackersForToday()
        updateCollectionView(with: newCategories)
    }
}

// MARK: - Update collection view
private extension TrackersViewController {
    
    func getCurrentWeekDay() -> WeekDays? {
        let weekDay = calendar.component(.weekday, from: currentDate)
        
        switch weekDay {
        case 1: return .sunday
        case 2: return .monday
        case 3: return .tuesday
        case 4: return .wednesday
        case 5: return .thursday
        case 6: return .friday
        case 7: return .saturday
        default: return nil
        }
    }
    
    func filterTrackersForToday() -> [TrackerCategory] {
        guard let today = getCurrentWeekDay() else { return [] }
        
        var filteredCategories: [TrackerCategory] = []
        
        for category in categories {
            let filteredTrackers = category.trackers.filter { $0.schedule.contains(today) }
            if !filteredTrackers.isEmpty {
                filteredCategories.append(TrackerCategory(name: category.name, trackers: filteredTrackers))
            }
        }
        
        return filteredCategories
    }
    
    func updateCollectionView(with newCategories: [TrackerCategory]) {
        
        let oldCategories = collectionDelegate.categories
        collectionDelegate.categories = newCategories
        
        if newCategories.isEmpty {
            changeStateStubView(isHidden: false)
            collectionView.reloadData()
        } else {
            changeStateStubView(isHidden: true)
            collectionView.performBatchUpdates({
                let changes = diff(old: oldCategories, new: newCategories)
                for change in changes {
                    switch change {
                    case let .insert(index):
                        collectionView.insertSections(IndexSet(integer: index))
                    case let .delete(index):
                        collectionView.deleteSections(IndexSet(integer: index))
                    case let .update(index):
                        collectionView.reloadSections(IndexSet(integer: index))
                    case let .move(from, to):
                        collectionView.moveSection(from, toSection: to)
                    }
                }
            })
        }
    }
    
    func diff(old: [TrackerCategory], 
              new: [TrackerCategory]) -> [Change] {
        var changes: [Change] = []
        
        let oldNames = old.map { $0.name }
        let newNames = new.map { $0.name }
        
        let diffResult = newNames.difference(from: oldNames)
        
        for change in diffResult {
            switch change {
            case let .remove(offset, _, _):
                changes.append(.delete(offset))
            case let .insert(offset, _, _):
                changes.append(.insert(offset))
            }
        }
        
        for (index, name) in oldNames.enumerated() {
            if let newIndex = newNames.firstIndex(of: name), index != newIndex {
                changes.append(.move(index, newIndex))
            } else if let _ = newNames.firstIndex(of: name), new[index].trackers != old[index].trackers {
                changes.append(.update(index))
            }
        }
        
        return changes
    }
    
    enum Change {
        case insert(Int)
        case delete(Int)
        case update(Int)
        case move(Int, Int)
    }
}

extension TrackersViewController: CreateTrackerViewControllerDelegate {
    func selectedPracticeVC() {
        let newPracticeVC = NewPracticeViewController()
        newPracticeVC.modalPresentationStyle = .popover
        newPracticeVC.categories = trackerCategoriesList
        newPracticeVC.delegate = self
        
        present(newPracticeVC, animated: true)
    }
    
    func selectedIrregularVC() {
        let newIrregularVC = NewIrregularViewController()
        newIrregularVC.modalPresentationStyle = .popover
        newIrregularVC.categories = trackerCategoriesList
        
        present(newIrregularVC, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension TrackersViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
    
}
