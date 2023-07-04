//
//  TypeNewTrackerViewController.swift
//  Tracker
//
//  Created by Andrey Bezrukov on 28.06.2023.
//

import UIKit

protocol TypeNewTrackerDelegate: AnyObject {
    func addNewTrackerCategory(_ newTrackerCategory: TrackerCategory)
}

final class TypeNewTrackerViewController: UIViewController {
    
    private let categories: [TrackerCategory]
    weak var delegate: TypeNewTrackerDelegate?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.ypMedium16()
        label.textColor = .uiBlack
        label.text = "Создание трекера"
        return label
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var newHabitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Привычка", for: .normal)
        button.setTitleColor(.uiWhite, for: .normal)
        button.titleLabel?.font = UIFont.ypMedium16()
        button.backgroundColor = .uiBlack
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(newHabitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var newEventButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Нерегулярные событие", for: .normal)
        button.setTitleColor(.uiWhite, for: .normal)
        button.titleLabel?.font = UIFont.ypMedium16()
        button.backgroundColor = .uiBlack
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(newEventButtonTapped), for: .touchUpInside)
        return button
    }()
    
    init(categiries: [TrackerCategory]) {
        self.categories = categiries
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .uiWhite
        
        addSubviews()
        setConstraints()
    }
    
    // MARK: - Action private func
    
    @objc private func newHabitButtonTapped() {
        let newTrackerVC = NewTrackerViewController()
        newTrackerVC.typeOfNewTracker = .habitTracker
        newTrackerVC.delegate = self
        present(newTrackerVC, animated: true)
    }
    
    @objc private func newEventButtonTapped() {
        let newTrackerVC = NewTrackerViewController()
        newTrackerVC.typeOfNewTracker = .eventTracker
        newTrackerVC.delegate = self
        present(newTrackerVC, animated: true)
    }
}

// MARK: - NewTrackerViewControllerDelegate

extension TypeNewTrackerViewController: NewTrackerViewControllerDelegate {
    func addNewTrackerCategory(_ newTrackerCategory: TrackerCategory) {
        delegate?.addNewTrackerCategory(newTrackerCategory)
        dismiss(animated: true)
    }
}

// MARK: - Set constraints / Add subviews

extension TypeNewTrackerViewController {
    
    private func addSubviews() {
        [titleLabel, verticalStackView].forEach {
            view.addViewsTAMIC($0)
        }
        
        [newHabitButton, newEventButton].forEach {
            verticalStackView.addArrangedSubview($0)
        }
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            
            newHabitButton.heightAnchor.constraint(equalToConstant: 60),
            newEventButton.heightAnchor.constraint(equalTo: newHabitButton.heightAnchor),
            
            verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
