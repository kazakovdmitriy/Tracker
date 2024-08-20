//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Дмитрий on 20.06.2024.
//

import UIKit

final class TrackersViewController: BaseController {
    
    // MARK: - Private Properties
    private var viewModel: TrackersViewModelProtocol
    
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
    
    // MARK: - Initializer
    init(viewModel: TrackersViewModelProtocol = TrackersViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
                
        searchBar.delegate = self
        addButton.tintColor = .ypBlack
        
        bindings()
    }
    
    private func bindings() {
        viewModel.onCategoriesUpdated = { [weak self] in
            self?.updateCollectionView()
        }
        viewModel.onCompletedTrackersUpdated = { [weak self] in
            self?.updateCollectionView()
        }
        viewModel.fetchCategories()
        viewModel.updateCompletedTrackers()
    }
    
    private func changeStateStubView(isHidden: Bool) {
        trackerStubView.isHidden = isHidden
        filterButton.isHidden = !isHidden
        collectionView.isHidden = !isHidden
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = Strings.NavBar.trackers
        navigationItem.leftBarButtonItem = addButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
    }
    
    private func configureCollectionView() {
        collectionLayout.itemSize = CGSize(width: view.frame.width - 20, height: 100)
        collectionLayout.minimumLineSpacing = 10
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        collectionView.scrollIndicatorInsets = collectionView.contentInset
        
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TrackerCardView.self,
                                forCellWithReuseIdentifier: TrackerCardView.reuseIdentifier)
        collectionView.register(TrackerSectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: TrackerSectionHeader.reuseIdentifier)
    }
    
    private func updateCollectionView() {
        collectionView.reloadData()
        changeStateStubView(isHidden: !viewModel.showedCategories.isEmpty)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func datePickerValueChanged(_ picker: UIDatePicker) {
        viewModel.updateDate(picker.date)
    }
    
    @objc private func addButtonTapped() {
        let addVC = ChoiseTypeTrackerViewController()
        addVC.delegate = self
        let navVC = UINavigationController(rootViewController: addVC)
        navVC.modalPresentationStyle = .popover
        present(navVC, animated: true)
    }
    
    @objc private func filterButtonTapped() {
        let filtersVC = FiltersViewController()
        filtersVC.modalPresentationStyle = .popover
        present(filtersVC, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension TrackersViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.showedCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCardView.reuseIdentifier,
            for: indexPath) as? TrackerCardView
        else {
            return UICollectionViewCell()
        }
        
        let item = viewModel.showedCategories[indexPath.section].trackers[indexPath.row]
        let category = viewModel.showedCategories[indexPath.section].name
        let days = countTrackersDays(date: viewModel.currentDate, trackerId: item.id)
        let isDone = viewModel.isTrackerCompleted(trackerId: item.id, date: viewModel.currentDate)
        
        let config = TrackerCardConfig(
            id: item.id,
            title: item.name,
            color: item.color,
            emoji: item.emoji,
            category: category,
            days: days,
            isDone: isDone,
            plusDelegate: self,
            date: viewModel.currentDate
        )
        
        cell.configure(config: config)
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.showedCategories.count
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
        
        header.setText(viewModel.showedCategories[indexPath.section].name)
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
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
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

private extension TrackersViewController {
    func countTrackersDays(date: Date, trackerId: UUID) -> Int {
        return viewModel.getCountOfCompletedTrackers(date: date, trackerId: trackerId)
    }
}

// MARK: - TrackerCardViewProtocol
extension TrackersViewController: TrackerCardViewProtocol {
    func pinCategory(forTracker id: UUID) {
        print("Закрепили \(id)")
        viewModel.pinTracker(forTrackerId: id)
    }
    
    func didChangeCompletedTrackers(with data: Set<TrackerRecord>) {
        viewModel.updateCompletedTrackers()
    }
    
    func didTapPlusButton(with id: UUID, isActive: Bool) {
        if viewModel.currentDate <= Date() {
            let newTrackerRecord = TrackerRecord(id: id, dateComplete: viewModel.currentDate)
            
            if !isActive {
                viewModel.removeCompletedTracker(newTrackerRecord)
            } else {
                viewModel.addCompletedTracker(newTrackerRecord)
            }
        }
    }
}

// MARK: - CreateTrackerViewControllerDelegate
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

extension TrackersViewController: CreateBaseControllerDelegate {
    func didTapCreateTrackerButton(category: String, tracker: Tracker) {
        viewModel.createTracker(category: category, tracker: tracker)
    }
}
