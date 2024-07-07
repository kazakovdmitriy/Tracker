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
    
    private var categories: [TrackerCategory] = [
        TrackerCategory(name: "Домашний уют", trackers: [
            Tracker(id: UUID(uuidString: "B81135FC-F8FE-4956-A19A-BD9F9F2086E3") ?? UUID(),
                    name: "Поливать растения",
                    color: .ypColorSelection5,
                    emoji: "❤️",
                    schedule: [.monday, .wednesday]),
            Tracker(id: UUID(uuidString: "BDE6641A-1AA1-4B3B-87C3-39C951548031") ?? UUID(),
                    name: "Кошка заслонила камеру на созвоне",
                    color: .ypColorSelection3,
                    emoji: "😹",
                    schedule: [.monday, .friday, .sunday, .saturday]),
            Tracker(id: UUID(uuidString: "8FE2AE56-98F5-496B-8FF9-0ECAA4C477DA") ?? UUID(),
                    name: "Бабушка прислала открытку в ватсапе",
                    color: .ypColorSelection11,
                    emoji: "🌸",
                    schedule: [.thursday, .tuesday])
        ]),
        TrackerCategory(name: "Вторая категория", trackers: [
            Tracker(id: UUID(uuidString: "A5EF31C6-A9CB-4E24-B14A-0619A253B739") ?? UUID(),
                    name: "Поливать растения",
                    color: .ypColorSelection5,
                    emoji: "❤️",
                    schedule: [.monday]),
            Tracker(id: UUID(uuidString: "5F8AFE7A-53A4-4E71-BD9B-3DC7BDC5F4D4") ?? UUID(),
                    name: "Кошка заслонила камеру на созвоне",
                    color: .ypColorSelection3,
                    emoji: "😹",
                    schedule: [.sunday, .saturday]),
            Tracker(id: UUID(uuidString: "F1406143-AC13-493C-BA82-8CF9FD7389B2") ?? UUID(),
                    name: "Бабушка прислала открытку в ватсапе",
                    color: .ypColorSelection11,
                    emoji: "🌸",
                    schedule: [.wednesday, .tuesday, .friday])
        ])
    ]
    private var completedTrackers: Set<TrackerRecord> = []
    
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
        
        if !categories.isEmpty {
            trackerStubView.isHidden = true
        } else {
            trackerStubView.isHidden = false
        }
        
        configureCollectionView()
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
        
        collectionDelegate.categories = categories
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
    }
}

extension TrackersViewController: CreateBaseControllerDelegate {
    
    private func addTracker(to categoryName: String, tracker: Tracker) {
        if let index = categories.firstIndex(where: { $0.name == categoryName }) {
            // Категория уже существует, создаём новый экземпляр категории с добавленным трекером
            let category = categories[index]
            var newTrackers = category.trackers
            newTrackers.append(tracker)
            let updatedCategory = TrackerCategory(name: category.name, trackers: newTrackers)
            categories[index] = updatedCategory
        } else {
            // Категории не существует, создаём новую категорию и добавляем трекер
            let newCategory = TrackerCategory(name: categoryName, trackers: [tracker])
            categories.append(newCategory)
        }
    }
    
    func didTapCreateTrackerButton(category: String, tracker: Tracker) {
        addTracker(to: category, tracker: tracker)
    }
}

// MARK: - Selectors
private extension TrackersViewController {
    @objc func addButtonTapped() {
        
        var trackerCategories: [String] = []
        
        for category in categories {
            trackerCategories.append(category.name)
        }
        
        let createTrackerViewController = CreateTrackerViewController()
        createTrackerViewController.modalPresentationStyle = .popover
        createTrackerViewController.categories = trackerCategories
        
        present(createTrackerViewController, animated: true)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        currentDate = selectedDate
        
        collectionDelegate.currentDate = currentDate
        
        print("Изменилась дата \(currentDate)")
    }
}

// MARK: - UISearchBarDelegate
extension TrackersViewController: UISearchBarDelegate {
    
}
