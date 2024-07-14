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

protocol CreateBaseControllerDelegate: AnyObject {
    func didTapCreateTrackerButton(category: String, tracker: Tracker)
}

class CreateBaseController: PopUpViewController {
    
    var tableViewDelegate: TrackersTableViewDelegate?
        
    private lazy var scrollView = UIScrollView()
    
    private let scrollStackViewContainer: UIStackView = {
        let view = UIStackView()
        
        view.axis = .vertical
        view.spacing = 24
        
        return view
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
    
    lazy var trackersTableView: TrackersTableView<TrackersTableViewCell> = TrackersTableView(
        cellType: TrackersTableViewCell.self,
        cellIdentifier: TrackersTableViewCell.reuseIdentifier
    )
    
    private let emojiList: [String] = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪",
    ]
    
    private let colorList: [UIColor] = [
        .ypColorSelection1, .ypColorSelection2, .ypColorSelection3, .ypColorSelection4, .ypColorSelection5, .ypColorSelection6,
        .ypColorSelection7, .ypColorSelection8, .ypColorSelection9, .ypColorSelection10, .ypColorSelection11, .ypColorSelection12,
        .ypColorSelection13, .ypColorSelection14, .ypColorSelection15, .ypColorSelection16, .ypColorSelection17, .ypColorSelection18,
    ]
    
    var selectedIndexPathSection1: IndexPath? = nil
    var selectedIndexPathSection2: IndexPath? = nil
    
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
    
    private let tableCategory: [String]
    private let trackerCategory: [String]
    
    init(title: String,
         tableCategory: [String],
         trackerCategory: [String]
    ) {
        
        self.tableCategory = tableCategory
        self.trackerCategory = trackerCategory
        
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
}

extension CreateBaseController {
    override func setupViews() {
        super.setupViews()
        
        view.setupView(scrollView)
        scrollView.setupView(scrollStackViewContainer)
        
        [nameTrackerInputField,
         trackersTableView,
         emojiColorCollectionView,
         stackButtonView].forEach {
            scrollStackViewContainer.addArrangedSubview($0)
        }
        
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
            
            nameTrackerInputField.heightAnchor.constraint(equalToConstant: 75),
            nameTrackerInputField.leadingAnchor.constraint(equalTo: scrollStackViewContainer.leadingAnchor),
            nameTrackerInputField.trailingAnchor.constraint(equalTo: scrollStackViewContainer.trailingAnchor),
            nameTrackerInputField.topAnchor.constraint(equalTo: scrollStackViewContainer.topAnchor),
            
            trackersTableView.topAnchor.constraint(equalTo: nameTrackerInputField.bottomAnchor, constant: 22),
            trackersTableView.leadingAnchor.constraint(equalTo: scrollStackViewContainer.leadingAnchor),
            trackersTableView.trailingAnchor.constraint(equalTo: scrollStackViewContainer.trailingAnchor),
            trackersTableView.heightAnchor.constraint(equalToConstant: 150),
            
            emojiColorCollectionView.leadingAnchor.constraint(equalTo: scrollStackViewContainer.leadingAnchor),
            emojiColorCollectionView.trailingAnchor.constraint(equalTo: scrollStackViewContainer.trailingAnchor),
            emojiColorCollectionView.topAnchor.constraint(equalTo: trackersTableView.bottomAnchor, constant: 32),
            emojiColorCollectionView.heightAnchor.constraint(equalToConstant: 408),
            
            stackButtonView.leadingAnchor.constraint(equalTo: scrollStackViewContainer.leadingAnchor),
            stackButtonView.trailingAnchor.constraint(equalTo: scrollStackViewContainer.trailingAnchor),
            stackButtonView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -24)
        ])
        
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        
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
    }
    
    func addActionToButton(create: Selector, cancle: Selector) {
        createButton.configure(action: create)
        cancleButton.configure(action: cancle)
    }
    
    @objc private func handleTap() {
        nameTrackerInputField.resignFirstResponder()
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
        if  newString != "" {
            createButton.activateButton()
        } else {
            createButton.deactivateButton()
        }
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
    }
    
//    func collectionView(_ collectionView: UICollectionView,
//                        didDeselectItemAt indexPath: IndexPath) {
//        
//        let isSelected: Bool
//        switch indexPath.section {
//        case 0:
//            isSelected = selectedIndexPathsSection1.contains(indexPath)
//        case 1:
//            isSelected = selectedIndexPathsSection2.contains(indexPath)
//        default:
//            isSelected = false
//        }
//        
//        if indexPath.section == 0 {
//            let cell = collectionView.cellForItem(at: indexPath) as? EmojiCellView
//            cell?.changeChoiseStatus(isHiden: true)
//            cell?.changeChoiseStatus(isHiden: !isSelected)
//        } else {
//            let cell = collectionView.cellForItem(at: indexPath) as? ColorCellView
//            cell?.changeChoiseStatus(isHiden: true)
//            cell?.changeChoiseStatus(isHiden: isSelected)
//        }
//        
//    }
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
        return 5
    }
}

