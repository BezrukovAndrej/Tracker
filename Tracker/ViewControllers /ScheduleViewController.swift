//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Andrey Bezrukov on 29.06.2023.
//

import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func addNewScedule(_ newShedule: [WeekDay])
}

final class ScheduleViewController: UIViewController, UITableViewDelegate {
    
    weak var delegate: ScheduleViewControllerDelegate?
    private var swichDays: [WeekDay] = []
    private var week = WeekDay.allCases
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.ypMedium16()
        label.text = "Расписание"
        label.textColor = .uiBlack
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorColor = .uiGray
        tableView.backgroundColor = .uiWhite
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private lazy var completedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.uiWhite, for: .normal)
        button.titleLabel?.font = UIFont.ypMedium16()
        button.backgroundColor = .uiGray
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(completedButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .uiWhite
        addSubviews()
        setConstraints()
        
    }
    
    // MARK: - Action private func
    
    @objc private func completedButtonTapped() {
        self.delegate?.addNewScedule(self.swichDays)
        dismiss(animated: true)
    }
    
    @objc private func swichTap(_ sender: UISwitch) {
        if sender.isOn {
            swichDays.append(week[sender.tag])
        } else {
            if let index = swichDays.firstIndex(of: week[sender.tag]) {
                swichDays.remove(at: index)
            }
        }
        buttonIsEnabled(!swichDays.isEmpty)
    }
}

// MARK: - UITableViewDataSource

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        WeekDay.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let swicher = UISwitch()
        swicher.onTintColor = .uiBlue
        swicher.tag = indexPath.row
        swicher.addTarget(self, action: #selector(swichTap), for: .valueChanged)
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.selectionStyle = .none
        cell.backgroundColor = .uiBackground
        cell.textLabel?.text = week[indexPath.row].dayName
        cell.textLabel?.font = UIFont.ypRegular17()
        cell.accessoryView = swicher
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    // MARK: - Private func
    
    private func buttonIsEnabled(_ isOn: Bool) {
        completedButton.isEnabled = isOn
        if isOn {
            completedButton.backgroundColor = .uiBlack
            completedButton.setTitleColor(.uiWhite, for: .normal)
        } else {
            completedButton.backgroundColor = .uiGray
            completedButton.setTitleColor(.uiWhite, for: .normal)
        }
    }
}

// MARK: - Set constraints / Add subviews

extension ScheduleViewController {
    
    private func addSubviews() {
        [titleLabel, tableView, completedButton].forEach {view.addViewsTAMIC($0)}
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 73),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 524),
            
            completedButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            completedButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            completedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            completedButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
