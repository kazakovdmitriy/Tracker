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
    private var analyticsService = AnalyticsService.shared
    
    private lazy var trackerStubView = StubView(type: .emptyTracker)
    private lazy var findStubView = StubView(type: .nothingFound)
    
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.setTitle(Strings.TrackersVC.filterButton, for: .normal)
        button.backgroundColor = .ypBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(nil, action: #selector(filterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = Strings.TrackersVC.searchPlaceHolder
        searchBar.translatesAutoresizingMaskIntoConstraints = false
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
    
    // MARK: - Lifecycle Methods
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsService.openEvent(screen: .Main)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        analyticsService.closeEvent(screen: .Main)
    }
    
    // MARK: - Setup View
    override func setupViews() {
        super.setupViews()
        setupNavigationBar()
        view.setupView(searchBar)
        view.setupView(collectionView)
        view.setupView(trackerStubView)
        view.setupView(findStubView)
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
            
            findStubView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            findStubView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
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
    
    // MARK: - Private Methods
    private func bindings() {
        viewModel.onCategoriesUpdated = { [weak self] in
            self?.updateCollectionView()
        }
        viewModel.fetchCategories()
    }
    
    private func changeStateStubView(hideType: HideType) {
        switch hideType {
        case .trackerHide:
            findStubView.isHidden = true
            trackerStubView.isHidden = false
            filterButton.isHidden = true
            collectionView.isHidden = true
        case .filterHide:
            findStubView.isHidden = false
            trackerStubView.isHidden = true
            filterButton.isHidden = false
            collectionView.isHidden = true
        case .showTracker:
            findStubView.isHidden = true
            trackerStubView.isHidden = true
            filterButton.isHidden = false
            collectionView.isHidden = false
        }
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
        changeStateStubView(hideType: viewModel.getHideType())
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func datePickerValueChanged(_ picker: UIDatePicker) {
        viewModel.updateDate(picker.date)
    }
    
    @objc private func addButtonTapped() {
        analyticsService.clickEvent(screen: .Main, button: .add_track)
        let addVC = ChoiseTypeTrackerViewController()
        addVC.delegate = self
        let navVC = UINavigationController(rootViewController: addVC)
        navVC.modalPresentationStyle = .popover
        present(navVC, animated: true)
    }
    
    @objc private func filterButtonTapped() {
        analyticsService.clickEvent(screen: .Main, button: .filter)
        let filtersVC = FiltersViewController()
        filtersVC.delegate = self
        filtersVC.modalPresentationStyle = .popover
        present(filtersVC, animated: true)
    }
}

// MARK: - ContextMenuDelegateFunc
private extension TrackersViewController {
    func displayDeleteAlert(forTracker id: UUID) {
        let dialogMessage = UIAlertController(title: "",
                                              message: Strings.TrackersVC.alertMessage,
                                              preferredStyle: .actionSheet)
        
        let delete = UIAlertAction(title: Strings.TrackersVC.alertBtnDelete,
                                   style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            viewModel.deleteTracker(with: id)
        }
        
        let cancel = UIAlertAction(title: Strings.TrackersVC.alertBtnCancle,
                                   style: .cancel) { _ in
            self.dismiss(animated: true)
        }
        
        dialogMessage.addAction(delete)
        dialogMessage.addAction(cancel)
        
        self.present(dialogMessage, animated: true)
    }
    
    func editTrackerTapped(forTracker id: UUID) {
        
        guard let tracker = viewModel.getTracker(by: id) else { return }
        
        let editVC = EditTrackersViewController(tracker: tracker)
        editVC.modalPresentationStyle = .popover
        editVC.delegate = self
        
        present(editVC, animated: true)
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
        let isDone = item.completedDate.contains(viewModel.currentDate)
        
        let config = TrackerCardConfig(
            id: item.id,
            title: item.name,
            color: item.color,
            emoji: item.emoji,
            category: category,
            days: viewModel.getCountOfCompletedTrackers(trackerId: item.id),
            isDone: isDone,
            isPinned: category == "Закрепленные",
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

// MARK: - TrackerCardViewProtocol
extension TrackersViewController: TrackerCardViewProtocol {
    func pinCategory(forTracker id: UUID) {
        viewModel.pinTracker(forTrackerId: id)
    }
    
    func editTracker(forTracker id: UUID) {
        analyticsService.clickEvent(screen: .Main, button: .edit)
        editTrackerTapped(forTracker: id)
    }
    
    func deleteTracker(forTracker id: UUID) {
        analyticsService.clickEvent(screen: .Main, button: .delete)
        displayDeleteAlert(forTracker: id)
    }
    
    func didTapPlusButton(with id: UUID, isActive: Bool) {
        analyticsService.clickEvent(screen: .Main, button: .track)
        
        if viewModel.currentDate <= Date() {
            if !isActive {
                viewModel.removeCompletedTracker(for: id)
            } else {
                viewModel.addCompletedTracker(for: id)
            }
        }
    }
}

// MARK: - CreateTrackerViewControllerDelegate
extension TrackersViewController: CreateTrackerViewControllerDelegate {
    func selectedPracticeVC() {
        let newPracticeVC = NewPracticeViewController(trackerType: .practice)
        newPracticeVC.modalPresentationStyle = .popover
        newPracticeVC.delegate = self
        present(newPracticeVC, animated: true)
    }
    
    func selectedIrregularVC() {
        let newIrregularVC = NewIrregularViewController(trackerType: .irregular)
        newIrregularVC.modalPresentationStyle = .popover
        newIrregularVC.delegate = self
        present(newIrregularVC, animated: true)
    }
}

// MARK: - CreateBaseControllerDelegate
extension TrackersViewController: CreateBaseControllerDelegate {
    func didTapCreateTrackerButton(category: String, tracker: Tracker, type: CreateBaseType) {
        switch type {
        case .create:
            viewModel.createTracker(category: category, tracker: tracker)
        case .edit:
            viewModel.updateTracker(category: category, tracker: tracker)
        }
    }
}

// MARK: - FiltersViewDelegateProtocol
extension TrackersViewController: FiltersViewDelegateProtocol {
    func allTrackers() {
        viewModel.filterAllTrackers()
    }
    
    func todayTrackers() {
        datePicker.setDate(Date(), animated: true)
        viewModel.filterTodayTrackers()
    }
    
    func doneTrackers() {
        viewModel.filterDoneTrackers()
    }
    
    func unfinishedTrackers() {
        viewModel.filterUnfinishedTrackers()
    }
}
