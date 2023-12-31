//
//  StatisticCell.swift
//  Tracker
//
//  Created by Andrey Bezrukov on 14.08.2023.
//

import UIKit

final class StatisticCell: UITableViewCell {
    
    static let identifier = Identifier.idStatisticCell
    
    private let gradientBorderView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .uiWhite
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.backgroundColor = .clear
        stack.distribution = .fill
        stack.spacing = 7
        return stack
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.ypBold34()
        label.textColor = .toggleBlackWhiteColor
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.ypMedium12()
        label.textColor = .toggleBlackWhiteColor
        return label
    }()
    
    private var gradientBorder: CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientBorderView.bounds
        gradientLayer.colors = [
            UIColor.color(from: "#FD4C49").cgColor,
            UIColor.color(from: "#46E69D").cgColor,
            UIColor.color(from: "#007BFA").cgColor,
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        return gradientLayer
    }
    
    //MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientBorder.removeFromSuperlayer()
        
        DispatchQueue.main.async { [weak self] in
            self?.gradientBorderView.layer.insertSublayer(self?.gradientBorder ?? CAGradientLayer(), at: 0)
        }
    }
    
    //MARK: - Methods
    
    func configureCell(with model: StatisticsCellModel) {
        contentView.backgroundColor = .uiWhite
        
        addSubview()
        setConstraints()
        
        valueLabel.text = model.value
        descriptionLabel.text = model.description
    }
    
    private func addSubview() {
        contentView.addViewsTAMIC(gradientBorderView)
        gradientBorderView.addViewsTAMIC(mainView)
        mainView.addViewsTAMIC(stackView)
        stackView.addArrangedSubview(valueLabel)
        stackView.addArrangedSubview(descriptionLabel)
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            gradientBorderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gradientBorderView.topAnchor.constraint(equalTo: contentView.topAnchor),
            gradientBorderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gradientBorderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            mainView.leadingAnchor.constraint(equalTo: gradientBorderView.leadingAnchor, constant: 1),
            mainView.topAnchor.constraint(equalTo: gradientBorderView.topAnchor, constant: 1),
            mainView.trailingAnchor.constraint(equalTo: gradientBorderView.trailingAnchor, constant: -1),
            mainView.bottomAnchor.constraint(equalTo: gradientBorderView.bottomAnchor, constant: -1),
            
            stackView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 11),
            stackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 11),
            stackView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -11),
            stackView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -11)
        ])
    }
}
