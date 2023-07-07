//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Andrey Bezrukov on 28.06.2023.
//

import UIKit

protocol TrackerCollectionViewCellDelegate: AnyObject {
    func plusButtonTapped(cell: TrackerCollectionViewCell)
}

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    static let indetifier = Identifier.idTrackCell
    weak var delegate: TrackerCollectionViewCellDelegate?
    
    private var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = .uiBlue
        return view
    }()
    
    private let numberOfDayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .uiBlack
        label.font = UIFont.ypMedium12()
        label.text = "0 Дней"
        return label
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 34 / 2
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.backgroundColor = .uiBackground
        label.textAlignment = .center
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.text = "🍏"
        return label
    }()
    
    private var trackerNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .uiWhite
        label.font = UIFont.ypMedium12()
        label.numberOfLines = 2
        label.text = "Поливать растения"
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setConstrainst()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configeCell(tracker: Tracker) {
        trackerNameLabel.text = tracker.text
        emojiLabel.text = tracker.emoji
        colorView.backgroundColor = tracker.color
        plusButton.backgroundColor = tracker.color
    }
    
    func configRecord(countDay: Int, isDoneToday: Bool) {
        let title = isDoneToday ? "✓" : "+"
        plusButton.setTitle(title, for: .normal)
        let opacity: Float = isDoneToday ? 0.3 : 1
        plusButton.layer.opacity = opacity
        
        numberOfDayLabel.text = "\(countDay) Дней"
    }
    
    @objc private func plusButtonTapped() {
        delegate?.plusButtonTapped(cell: self)
    }
}

// MARK: - Set constraints / Add subviews

extension TrackerCollectionViewCell {
    
    private func addSubviews() {
        [colorView, numberOfDayLabel, plusButton].forEach {
            contentView.addViewsTAMIC($0)
        }
        
        [emojiLabel, trackerNameLabel].forEach {
            colorView.addViewsTAMIC($0)
        }
    }
    
    private func setConstrainst() {
        let space: CGFloat = 12
        
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -42),
            
            numberOfDayLabel.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            numberOfDayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: space),
            
            plusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -space),
            plusButton.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 8),
            plusButton.heightAnchor.constraint(equalToConstant: 34),
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            
            emojiLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: space),
            emojiLabel.topAnchor.constraint(equalTo: colorView.topAnchor, constant: space),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            
            trackerNameLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: space),
            trackerNameLabel.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -space),
            trackerNameLabel.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -space),
        ])
    }
}
