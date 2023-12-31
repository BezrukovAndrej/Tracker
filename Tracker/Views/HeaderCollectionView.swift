//
//  HeaderCollectionView.swift
//  Tracker
//
//  Created by Andrey Bezrukov on 29.06.2023.
//

import UIKit

final class HeaderCollectionView: UICollectionReusableView {
    
    static let identifier = Identifier.idHeader
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.ypBold19()
        label.textColor = .toggleBlackWhiteColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    private func addSubview() {
        addSubview(titleLabel)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
