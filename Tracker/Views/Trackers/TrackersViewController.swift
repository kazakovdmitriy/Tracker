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
    
    private let trackerStore = TrackerStore.shared
    private let trackerRecordStore = TrackerRecordStore.shared
    private let trackerCategoryStore = TrackerCategoryStore.shared
    
    private var categories: [TrackerCategory] = []
    private var showedCategories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    
    private lazy var trackerStubView = StubView(imageName: "empty_trackers_image",
                                                text: "Что будем отслеживать?")
    
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Фильтры", for: .normal)
        
        button.backgroundColor = .ypBlue
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        
        button.addTarget(nil, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
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
    private lazy var collectionView = UICollectionView(frame: view.frame, collectionViewLayout: collectionLayout)
}

// MARK: - Setup View
extension TrackersViewController {
    override func setupViews() {
        super.setupViews()
        
        setupNavigationBar()
        
        view.setupView(searchBar)
        view.setupView(collectionView)
        view.setupView(trackerStubView)
        view.setupView(filterButton)
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
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 114)
        ])
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        
        configureCollectionView()
        updateCollectionView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
                
        completedTrackers = trackerRecordStore.fetchedObjects()
        
        searchBar.delegate = self
        
        addButton.tintColor = .ypBlack
        
        
    }
    
    private func changeStateStubView(isHidden: Bool) {
        trackerStubView.isHidden = isHidden
        
        filterButton.isHidden = !isHidden
        collectionView.isHidden = !isHidden
    }
    
    private func setupNavigationBar() {
        // Устанавливаем крупный заголовок
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = Strings.NavBar.trackers
        
        navigationItem.leftBarButtonItem = addButton
        
        // Создаем и добавляем label для даты справа
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
    }
    
    private func configureCollectionView() {
        
        collectionLayout.itemSize = CGSize(width: view.frame.width - 20, height: 100)
        collectionLayout.minimumLineSpacing = 10
        
        collectionView.backgroundColor = .clear
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TrackerCardView.self,
                                forCellWithReuseIdentifier: TrackerCardView.reuseIdentifier)
        collectionView.register(TrackerSectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: TrackerSectionHeader.reuseIdentifier)
    }
}

// MARK: - CreateBaseContollerDelegate
extension TrackersViewController: CreateBaseControllerDelegate {
    func didTapCreateTrackerButton(category: String,
                                   tracker: Tracker) {
        
        trackerStore.createTracker(tracker: tracker, 
                                   toCategory: category)
        
        
        updateCollectionView()
    }
}

// MARK: - Selectors
private extension TrackersViewController {
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func addButtonTapped() {
        let createTrackerViewController = ChoiseTypeTrackerViewController()
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
        
        updateCollectionView()
    }
    
    @objc func filterButtonTapped() {
        let filtersVC = FiltersViewController()
        
        filtersVC.modalPresentationStyle = .popover
        
        present(filtersVC, animated: true)
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
            let filteredTrackers = category.trackers.filter { (tracker: Tracker) in                
                switch tracker.type {
                case .practice:
                    return tracker.schedule.contains(today)
                case .irregular:
                    return (
                        !completedTrackers.containtRecord(withId: tracker.id) || 
                        completedTrackers.containtRecordForDay(withId: tracker.id, andDate: currentDate)
                    )
                }
            }
            if !filteredTrackers.isEmpty {
                filteredCategories.append(TrackerCategory(name: category.name, trackers: filteredTrackers))
            }
        }
        
        return filteredCategories
    }
    
    func updateCollectionView() {
        
        categories = trackerCategoryStore.fetchCategoriesWithTrackers()
        showedCategories = filterTrackersForToday()
        
        showedCategories = filterTrackersForToday()
        changeStateStubView(isHidden: !showedCategories.isEmpty)
        collectionView.reloadData()
    }
}

extension TrackersViewController: CreateTrackerViewControllerDelegate {
    func selectedPracticeVC() {
        let newPracticeVC = NewPracticeViewController()
        newPracticeVC.modalPresentationStyle = .popover
        newPracticeVC.delegate = self
        
        present(newPracticeVC, animated: true)
    }
    
    func selectedIrregularVC() {
        let newIrregularVC = NewIrregularViewController()
        newIrregularVC.modalPresentationStyle = .popover
        newIrregularVC.delegate = self
        
        present(newIrregularVC, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension TrackersViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return showedCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCardView.reuseIdentifier,
            for: indexPath) as? TrackerCardView
        else {
            return UICollectionViewCell()
        }
        
        let item = showedCategories[indexPath.section].trackers[indexPath.row]
        let category = showedCategories[indexPath.section].name
        let days = countTrackersDays(date: currentDate, trackerId: item.id)
        let currentTrackerRecord = TrackerRecord(id: item.id, dateComplete: currentDate)
        let isDone = completedTrackers.contains(currentTrackerRecord)
        
        let config = TrackerCardConfig(
            id: item.id,
            title: item.name,
            color: item.color,
            emoji: item.emoji,
            category: category,
            days: days,
            isDone: isDone,
            plusDelegate: self,
            date: currentDate
        )
        
        cell.configure(config: config)
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return showedCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError("Unexpected element kind")
        }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TrackerSectionHeader.reuseIdentifier,
            for: indexPath) as? TrackerSectionHeader
        else {
            return UICollectionReusableView()
        }
        
        header.setText(showedCategories[indexPath.section].name)
        return header
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = (collectionView.layer.frame.width - 10) / 2
        
        return CGSize(width: cellWidth, height: 148)
    }
    
    // Минимальное межстрочное расстояние
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // Минимальное межколоночное расстояние
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

private extension TrackersViewController {
    func countTrackersDays(date: Date, trackerId: UUID) -> Int {
        var trackerCounts: [UUID: Int] = [:]
        
        for tracker in completedTrackers {
            if tracker.dateComplete <= date {
                trackerCounts[tracker.id, default: 0] += 1
            }
        }
        
        return trackerCounts[trackerId] ?? 0
    }
}

extension TrackersViewController: TrackerCardViewProtocol {
    func pinCategory(forTracker id: UUID) {
        print("Закрепили \(id)")
        
        trackerStore.pinnedTracker(forTrackerId: id)
        self.categories = trackerCategoryStore.fetchCategoriesWithTrackers()
        
        updateCollectionView()
    }
    
    func didChangeCompletedTrackers(with data: Set<TrackerRecord>) {
        completedTrackers = data
    }
    
    func didTapPlusButton(with id: UUID, isActive: Bool) {
        
        if currentDate <= Date() {
            let newTrackerRecord = TrackerRecord(id: id, dateComplete: currentDate)
            
            if !isActive {
                completedTrackers.remove(newTrackerRecord)
                try? trackerRecordStore.delete(trackerRecord: newTrackerRecord)
            } else {
                completedTrackers.insert(newTrackerRecord)
                trackerRecordStore.createTrackerRecord(trackerRecord: newTrackerRecord)
            }
        }
    }
}
