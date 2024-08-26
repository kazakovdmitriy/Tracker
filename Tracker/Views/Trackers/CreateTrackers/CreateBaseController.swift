//
//  CreateBaseController.swift
//  Tracker
//
//  Created by Дмитрий on 30.06.2024.
//

import UIKit

struct TrackerData {
    let name: String
    let emoji: String
    let color: UIColor
}

enum CreateBaseType {
    case create
    case edit
}

protocol CreateBaseControllerDelegate: AnyObject {
    func didTapCreateTrackerButton(category: String, tracker: Tracker, type: CreateBaseType)
}

class CreateBaseController: PopUpViewController {
    
    weak var tableViewDelegate: TrackersTableViewDelegate?
    
    private let creationType: CreateBaseType
    
    private let emojiList: [String] = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪",
    ]
    
    private let colorList: [UIColor] = [
        .ypColorSelection1, .ypColorSelection2, .ypColorSelection3,
            .ypColorSelection4, .ypColorSelection5, .ypColorSelection6,
        .ypColorSelection7, .ypColorSelection8, .ypColorSelection9,
            .ypColorSelection10, .ypColorSelection11, .ypColorSelection12,
        .ypColorSelection13, .ypColorSelection14, .ypColorSelection15,
            .ypColorSelection16, .ypColorSelection17, .ypColorSelection18,
    ]
    
    private let tableCategory: [String]
    
    private var selectedIndexPathSection1: IndexPath? = nil
    private var selectedIndexPathSection2: IndexPath? = nil
    
    private var tableViewHeightConstraint: NSLayoutConstraint?
    
    private lazy var scrollView = UIScrollView()
    
    private let scrollStackViewContainer: UIStackView = {
        let view = UIStackView()
        
        view.axis = .vertical
        view.spacing = 24
        
        return view
    }()
    
    private lazy var dayCountLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var nameTrackerInputField: UITextField = {
        let textField = UITextField()
        
        textField.backgroundColor = .ypBackground
        textField.font = UIFont.systemFont(ofSize: 17)
        
        textField.attributedPlaceholder = NSAttributedString(
            string: "Введите название трекера",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.ypGray]
        )
        textField.textColor = .ypBlack
        
        textField.borderStyle = .none
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.rightView = paddingView
        textField.rightViewMode = .always
        
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        
        textField.clearButtonMode = .whileEditing
        
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var trackersTableView: TrackersTableView<TrackersTableViewCell> = TrackersTableView(
        cellType: TrackersTableViewCell.self,
        cellIdentifier: TrackersTableViewCell.reuseIdentifier
    )
    
    private let emojiColorCollectionViewLayout = UICollectionViewFlowLayout()
    private lazy var emojiColorCollectionView = UICollectionView(frame: view.frame,
                                                                 collectionViewLayout: emojiColorCollectionViewLayout)
    
    private lazy var cancleButton = MainButton(title: "Отменить")
    private lazy var createButton = MainButton(title: "Создать")
    
    private lazy var stackButtonView: UIStackView = {
        let stack = UIStackView()
        
        stack.spacing = 8
        stack.distribution = .fillEqually
        
        return stack
    }()
    
    init(title: String,
         trackerType: TrackerType,
         createType: CreateBaseType
    ) {
        
        switch trackerType {
        case .practice: tableCategory = ["Категория", "Расписание"]
        case .irregular: tableCategory = ["Категория"]
        }
        
        self.creationType = createType
        
        super.init(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getData() -> TrackerData? {
        
        guard
            let index1 = selectedIndexPathSection1?.row,
            let index2 = selectedIndexPathSection2?.row,
            let name = nameTrackerInputField.text
        else {
            return nil
        }
        
        return TrackerData(name: name, emoji: emojiList[index1], color: colorList[index2])
    }
    
    func reloadTable() {
        updateTableViewHeight()
        trackersTableView.reloadData()
    }
    
    func configure(tracker: Tracker) {
        dayCountLabel.text = getDayString(for: tracker.completedDate.count)
        
        nameTrackerInputField.text = tracker.name
        createButton.activateButton()
        
        emojiColorCollectionView.reloadData()
        
        selectEmojiAndColor(for: tracker.emoji, and: tracker.color)
    }
    
    func updateCreateButtonState() {
        let isNameFilled = !(nameTrackerInputField.text?.isEmpty ?? true)
        let isEmojiSelected = selectedIndexPathSection1 != nil
        let isColorSelected = selectedIndexPathSection2 != nil
        let isCategorySelected = tableViewDelegate?.choiseCategory != nil
        let isScheduleSelected = !(tableViewDelegate?.weekDaysSchedule.isEmpty ?? false) || tableCategory.count == 1
        
        let shouldActivate = isNameFilled && isEmojiSelected && isColorSelected && isCategorySelected && isScheduleSelected
        
        if shouldActivate {
            createButton.activateButton()
        } else {
            createButton.deactivateButton()
        }
    }
    
    private func updateTableViewHeight() {
        let numberOfRows = tableViewDelegate?.data.count ?? 0
        
        let height = CGFloat(numberOfRows) * trackersTableView.rowHeight
        tableViewHeightConstraint?.constant = height
        
        view.layoutIfNeeded()
    }
    
    private func selectEmojiAndColor(for emoji: String, and color: UIColor) {
        if let emojiIndex = emojiList.firstIndex(of: emoji),
           emojiIndex < emojiList.count {
            let indexPath = IndexPath(row: emojiIndex, section: 0)
            selectedIndexPathSection1 = indexPath
            emojiColorCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            emojiColorCollectionView.reloadItems(at: [indexPath])
        }

        if let colorIndex = colorList.firstIndex(of: color),
           colorIndex < colorList.count {
            let indexPath = IndexPath(row: colorIndex, section: 1)
            selectedIndexPathSection2 = indexPath
            emojiColorCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            emojiColorCollectionView.reloadItems(at: [indexPath])
        }
    }
}

extension CreateBaseController {
    override func setupViews() {
        super.setupViews()
        
        view.setupView(scrollView)
        scrollView.setupView(scrollStackViewContainer)
        
        [dayCountLabel,
         nameTrackerInputField,
         trackersTableView,
         emojiColorCollectionView,
         stackButtonView].forEach {
            scrollStackViewContainer.addArrangedSubview($0)
        }
        
        tableViewHeightConstraint = trackersTableView.heightAnchor.constraint(equalToConstant: 148)
        tableViewHeightConstraint?.isActive = true
        
        stackButtonView.addArrangedSubview(cancleButton)
        stackButtonView.addArrangedSubview(createButton)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        NSLayoutConstraint.activate([
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 63),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollStackViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant:  16),
            scrollStackViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            scrollStackViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollStackViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollStackViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            
            dayCountLabel.topAnchor.constraint(equalTo: scrollStackViewContainer.topAnchor),
            dayCountLabel.heightAnchor.constraint(equalToConstant: 38),
            dayCountLabel.leadingAnchor.constraint(equalTo: scrollStackViewContainer.leadingAnchor),
            dayCountLabel.trailingAnchor.constraint(equalTo: scrollStackViewContainer.trailingAnchor),
            
            nameTrackerInputField.heightAnchor.constraint(equalToConstant: 75),
            nameTrackerInputField.leadingAnchor.constraint(equalTo: scrollStackViewContainer.leadingAnchor),
            nameTrackerInputField.topAnchor.constraint(equalTo: dayCountLabel.bottomAnchor, constant: 40),
            
            trackersTableView.leadingAnchor.constraint(equalTo: scrollStackViewContainer.leadingAnchor),
            trackersTableView.trailingAnchor.constraint(equalTo: scrollStackViewContainer.trailingAnchor),

            emojiColorCollectionView.leadingAnchor.constraint(equalTo: scrollStackViewContainer.leadingAnchor),
            emojiColorCollectionView.trailingAnchor.constraint(equalTo: scrollStackViewContainer.trailingAnchor),
            emojiColorCollectionView.heightAnchor.constraint(equalToConstant: 408),
            
            stackButtonView.leadingAnchor.constraint(equalTo: scrollStackViewContainer.leadingAnchor),
            stackButtonView.trailingAnchor.constraint(equalTo: scrollStackViewContainer.trailingAnchor),
            stackButtonView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -24)
        ])
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        
        switch creationType {
        case .create: 
            dayCountLabel.isHidden = true
            createButton.configureTitle(newTitle: "Создать")
        case .edit:
            dayCountLabel.isHidden = false
            createButton.configureTitle(newTitle: "Сохранить")
        }
        
        trackersTableView.delegate = tableViewDelegate
        tableViewDelegate?.data = tableCategory
        trackersTableView.dataSource = tableViewDelegate
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        setupCollectionView()
        
        createButton.deactivateButton()
        
        cancleButton.setColors(bgColor: .clear, title: .ypRed)
        cancleButton.layer.cornerRadius = 16
        cancleButton.layer.borderColor = UIColor.ypRed.cgColor
        cancleButton.layer.borderWidth = 1
        
        scrollView.contentSize = scrollStackViewContainer.bounds.size
        
        reloadTableData()
        updateCreateButtonState()
    }
    
    func addActionToButton(create: Selector, cancle: Selector) {
        createButton.configure(action: create)
        cancleButton.configure(action: cancle)
    }
    
    @objc private func handleTap() {
        nameTrackerInputField.resignFirstResponder()
    }
    
    private func reloadTableData() {
        trackersTableView.reloadData()
        trackersTableView.beginUpdates()
        trackersTableView.endUpdates()
    }
    
    private func setupCollectionView() {
        emojiColorCollectionViewLayout.itemSize = CGSize(width: 52, height: 52)
        emojiColorCollectionViewLayout.minimumLineSpacing = 5
        
        emojiColorCollectionView.backgroundColor = .clear
        emojiColorCollectionView.isScrollEnabled = false
        
        emojiColorCollectionView.delegate = self
        emojiColorCollectionView.dataSource = self
        emojiColorCollectionView.register(EmojiCellView.self,
                                          forCellWithReuseIdentifier: EmojiCellView.reuseIdentifier)
        emojiColorCollectionView.register(ColorCellView.self,
                                          forCellWithReuseIdentifier: ColorCellView.reuseIdentifier)
        emojiColorCollectionView.register(TrackerSectionHeader.self,
                                          forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                          withReuseIdentifier: TrackerSectionHeader.reuseIdentifier)
    }
    
    private func getDayString(for number: Int) -> String {
        let remainder10 = number % 10
        let remainder100 = number % 100
        
        if remainder100 >= 11 && remainder100 <= 14 {
            return "\(number) \(Strings.TrackersCardView.days)"
        } else {
            switch remainder10 {
            case 1:
                return "\(number) \(Strings.TrackersCardView.day)"
            case 2, 3, 4:
                return "\(number) \(Strings.TrackersCardView.twoDays)"
            default:
                return "\(number) \(Strings.TrackersCardView.days)"
            }
        }
    }
}

extension CreateBaseController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        createButton.deactivateButton()
        return true
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let userEnteredString = textField.text
        let newString = (userEnteredString! as NSString).replacingCharacters(in: range, with: string) as NSString
        updateCreateButtonState()
        return true
    }
}

extension CreateBaseController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        let section = indexPath.section
        let selectedIndexPath = indexPath
        
        switch section {
        case 0:
            // Если уже была выбрана другая ячейка в этой секции, снимаем выделение с неё
            if let previousIndexPath = selectedIndexPathSection1 {
                selectedIndexPathSection1 = nil
                collectionView.reloadItems(at: [previousIndexPath])
            }
            
            // Выбираем новую ячейку
            selectedIndexPathSection1 = selectedIndexPath
            collectionView.reloadItems(at: [selectedIndexPath])
            
        case 1:
            // Если уже была выбрана другая ячейка в этой секции, снимаем выделение с неё
            if let previousIndexPath = selectedIndexPathSection2 {
                selectedIndexPathSection2 = nil
                collectionView.reloadItems(at: [previousIndexPath])
            }
            
            // Выбираем новую ячейку
            selectedIndexPathSection2 = selectedIndexPath
            collectionView.reloadItems(at: [selectedIndexPath])
            
        default:
            break
        }
        
        updateCreateButtonState()
    }
}

extension CreateBaseController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return emojiList.count
        } else {
            return colorList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let isSelected: Bool
        switch indexPath.section {
        case 0:
            isSelected = indexPath == selectedIndexPathSection1
        case 1:
            isSelected = indexPath == selectedIndexPathSection2
        default:
            isSelected = false
        }
        
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: EmojiCellView.reuseIdentifier,
                for: indexPath) as? EmojiCellView
            else {
                return UICollectionViewCell()
            }
            
            cell.configure(emoji: emojiList[indexPath.row])
            cell.changeChoiseStatus(isHiden: !isSelected)
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ColorCellView.reuseIdentifier,
                for: indexPath) as? ColorCellView
            else {
                return UICollectionViewCell()
            }
            
            cell.configure(with: colorList[indexPath.row])
            cell.changeChoiseStatus(isHiden: !isSelected)
            
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
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
        
        if indexPath.section == 0 {
            header.setText("Emoji")
        } else {
            header.setText("Цвет")
        }
        
        return header
    }
}

extension CreateBaseController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
