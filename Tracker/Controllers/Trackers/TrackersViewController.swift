//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Дмитрий on 20.06.2024.
//

import UIKit

final class TrackersViewController: BaseController {
    
    private let dateFormatter = DateFormatter()
    private var currentDate: Date = Date()
    
    private var categories: [TrackerCategory] = [
        TrackerCategory(name: "Домашний уют", trackers: [
            Tracker(id: UUID(), 
                    name: "Поливать растения",
                    color: .ypColorSelection5,
                    emoji: "❤️",
                    schedule: []),
            Tracker(id: UUID(),
                    name: "Кошка заслонила камеру на созвоне",
                    color: .ypColorSelection3,
                    emoji: "😹",
                    schedule: []),
            Tracker(id: UUID(),
                    name: "Бабушка прислала открытку в ватсапе",
                    color: .ypColorSelection11,
                    emoji: "🌸",
                    schedule: []),
        ]),
        TrackerCategory(name: "Вторая категория", trackers: [
            Tracker(id: UUID(),
                    name: "Поливать растения",
                    color: .ypColorSelection5,
                    emoji: "❤️",
                    schedule: []),
            Tracker(id: UUID(),
                    name: "Кошка заслонила камеру на созвоне",
                    color: .ypColorSelection3,
                    emoji: "😹",
                    schedule: []),
            Tracker(id: UUID(),
                    name: "Бабушка прислала открытку в ватсапе",
                    color: .ypColorSelection11,
                    emoji: "🌸",
                    schedule: []),
        ])
    ]
    private var completedTrackers: [TrackerRecord] = []
    
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
}

private extension TrackersViewController {
    func setupNavigationBar() {
        // Устанавливаем крупный заголовок
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = R.Strings.NavBar.trackers
        
        navigationItem.leftBarButtonItem = addButton
        
        // Создаем и добавляем label для даты справа
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
    }
    
    func configureCollectionView() {
        
        collectionLayout.itemSize = CGSize(width: view.frame.width - 20, height: 100)
        collectionLayout.minimumLineSpacing = 10
        
        collectionDelegate.categories = categories
        
        collectionView.backgroundColor = .clear
        
        collectionView.delegate = collectionDelegate
        collectionView.dataSource = collectionDelegate
        collectionView.register(TrackerCardView.self,
                                forCellWithReuseIdentifier: TrackerCardView.reuseIdentifier)
        collectionView.register(TrackerSectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: TrackerSectionHeader.reuseIdentifier)
    }
    
    @objc private func addButtonTapped() {
        
        var trackerCategories: [String] = []
        
        for category in categories {
            trackerCategories.append(category.name)
        }
        
        let createTrackerViewController = CreateTrackerViewController()
        createTrackerViewController.modalPresentationStyle = .popover
        createTrackerViewController.categories = trackerCategories
        
        present(createTrackerViewController, animated: true)
    }
}

extension TrackersViewController: UISearchBarDelegate {
    
}

extension TrackersViewController {
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        currentDate = selectedDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy" // Формат даты
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
    }
}
