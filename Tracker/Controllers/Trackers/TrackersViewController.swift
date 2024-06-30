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
        
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        return picker
    }()
    
    private let collectionLayout = UICollectionViewFlowLayout()
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
        
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TrackerCardView.self,
                                forCellWithReuseIdentifier: TrackerCardView.reuseIdentifier)
        collectionView.register(TrackerSectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: TrackerSectionHeader.reuseIdentifier)
    }
    
    @objc private func addButtonTapped() {
        let createTrackerViewController = CreateTrackerViewController()
        createTrackerViewController.modalPresentationStyle = .popover
        
        present(createTrackerViewController, animated: true)
    }
}

extension TrackersViewController: UISearchBarDelegate {
    
}

extension TrackersViewController: UICollectionViewDelegate {
    
}

extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return categories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCardView.reuseIdentifier, for: indexPath) as! TrackerCardView
        let item = categories[indexPath.section].trackers[indexPath.row]
        cell.configure(title: item.name, bgColor: item.color, emoji: item.emoji)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError("Unexpected element kind")
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, 
                                                                     withReuseIdentifier: TrackerSectionHeader.reuseIdentifier,
                                                                     for: indexPath) as! TrackerSectionHeader
        header.setText(categories[indexPath.section].name)
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
        // Установите нужный размер ячейки
        return CGSize(width: 167, height: 148)
    }
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
