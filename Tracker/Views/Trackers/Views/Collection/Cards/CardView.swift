//
//  CardView.swift
//  Tracker
//
//  Created by Дмитрий on 24.06.2024.
//

import UIKit

protocol CardViewDelegateProtocol: AnyObject {
    func pinCardAction()
    func editCardAction()
    func deleteCardAction()
}

final class CardView: BaseView {
    
    weak var delegate: CardViewDelegateProtocol?
    
    private lazy var backgroundColorView: UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.backgroundColor = .ypColorSelection1
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var emojiBackView: UIView = {
        let view = UIView()
        
        let viewSize: CGFloat = 24
        view.frame = CGRect(x: 0, y: 0, width: viewSize, height: viewSize)
        
        view.layer.cornerRadius = viewSize / 2
        view.layer.masksToBounds = true
        
        view.backgroundColor = .ypWhite30
        
        return view
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        
        return label
    }()
    
    func configure(title: String, bgColor: UIColor, emoji: String) {
        titleLabel.text = title
        backgroundColorView.backgroundColor = bgColor
        emojiLabel.text = emoji
    }
}

extension CardView {
    override func setupViews() {
        super.setupViews()
        
        setupView(backgroundColorView)
        
        backgroundColorView.setupView(titleLabel)
        backgroundColorView.setupView(emojiBackView)
        
        emojiBackView.setupView(emojiLabel)
        
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        NSLayoutConstraint.activate([
            backgroundColorView.topAnchor.constraint(equalTo: topAnchor),
            backgroundColorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundColorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundColorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            // backgroundColorView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiBackView.topAnchor.constraint(equalTo: backgroundColorView.topAnchor, constant: 12),
            emojiBackView.leadingAnchor.constraint(equalTo: backgroundColorView.leadingAnchor, constant: 12),
            emojiBackView.widthAnchor.constraint(equalToConstant: 24),
            emojiBackView.heightAnchor.constraint(equalToConstant: 24),
            
            emojiLabel.centerXAnchor.constraint(equalTo: emojiBackView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiBackView.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: backgroundColorView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: backgroundColorView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: backgroundColorView.bottomAnchor, constant: -12)
        ])
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        
        // Добавляем контекстное меню к ячейке
        let interaction = UIContextMenuInteraction(delegate: self)
        self.addInteraction(interaction)
    }
}

extension CardView: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            // Создаем элементы контекстного меню
            let pinAction = UIAction(title: "Закрепить") { [weak self] action in
                guard let self = self else { return }
                self.delegate?.pinCardAction()
            }
            
            let editAction = UIAction(title: "Редактировать") { [weak self] action in
                guard let self = self else { return }
                self.delegate?.editCardAction()
            }
            
            let deleteAction = UIAction(title: "Удалить", attributes: .destructive) { [weak self] action in
                guard let self = self else { return }
                self.delegate?.deleteCardAction()
            }
            
            return UIMenu(children: [pinAction, editAction, deleteAction])
        }
    }
}
