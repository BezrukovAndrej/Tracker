//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Andrey Bezrukov on 29.06.2023.
//

import UIKit

final class ScheduleViewController: UIViewController {
    
    var selectedDays: [String]
    var provideSelectedDays: (([String]) -> Void)?
    private let preferredOrder = WeekDay.allCases.map{$0.shortName}
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.ypMedium16()
        label.textColor = .toggleBlackWhiteColor
        label.text = NSLocalizedString("schedule", comment: "")
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.layer.masksToBounds = true
        table.bounces = false
        table.backgroundColor = .clear
        table.layer.cornerRadius = 16
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        table.separatorColor = .uiGray
        return table
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(.blackGrayColorButton, for: .normal)
        button.backgroundColor = .toggleBlackWhiteColor
        button.setTitle(NSLocalizedString("ready", comment: ""), for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.ypMedium16()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        return button
    }()
    
    init(selectedDays: [String]) {
        self.selectedDays = selectedDays
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setConstraints()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let sortedSelectedDays = sortSelectedDays(selectedDays)
        provideSelectedDays?(sortedSelectedDays)
    }
    
    private func sortSelectedDays(_ days: [String]) -> [String] {
        return days.sorted { preferredOrder.firstIndex(of: $0)! < preferredOrder.firstIndex(of: $1)! }
    }
    
    @objc
    private func didTapConfirmButton() {
        dismiss(animated: true)
    }
    
    @objc
    private func didTapSwitcher(_ sender: UISwitch) {
        if sender.isOn {
            switch sender.tag {
            case 0: selectedDays.append(WeekDay.monday.shortName)
            case 1: selectedDays.append(WeekDay.tuesday.shortName)
            case 2: selectedDays.append(WeekDay.wednesday.shortName)
            case 3: selectedDays.append(WeekDay.thursday.shortName)
            case 4: selectedDays.append(WeekDay.friday.shortName)
            case 5: selectedDays.append(WeekDay.saturday.shortName)
            case 6: selectedDays.append(WeekDay.sunday.shortName)
            default: break
            }
        } else {
            switch sender.tag {
            case 0: selectedDays.removeAll { $0 == WeekDay.monday.shortName }
            case 1: selectedDays.removeAll { $0 == WeekDay.tuesday.shortName }
            case 2: selectedDays.removeAll { $0 == WeekDay.wednesday.shortName }
            case 3: selectedDays.removeAll { $0 == WeekDay.thursday.shortName }
            case 4: selectedDays.removeAll { $0 == WeekDay.friday.shortName }
            case 5: selectedDays.removeAll { $0 == WeekDay.saturday.shortName }
            case 6: selectedDays.removeAll { $0 == WeekDay.sunday.shortName }
            default: break
            }
        }
    }
    
}

// MARK: - UITableViewDelegate

extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}

// MARK: - UITableViewDataSource

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        WeekDay.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let switcher = UISwitch()
        switcher.onTintColor = .uiBlue
        switcher.tag = indexPath.row
        switcher.addTarget(self, action: #selector(didTapSwitcher(_:)), for: .valueChanged)
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let weekday = WeekDay.allCases[indexPath.row]
        cell.selectionStyle = .none
        cell.backgroundColor = .uiBackground
        cell.textLabel?.text = weekday.localizedName
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.accessoryView = switcher
        if !selectedDays.isEmpty {
            if selectedDays.contains(weekday.shortName) {
                switcher.isOn = true
            }
        }
        return cell
    }
}

// MARK: - Set constraints / Add subviews

extension ScheduleViewController {
    
    private func addSubviews() {
        view.backgroundColor = .uiWhite
        
        [titleLabel, tableView, confirmButton].forEach {view.addViewsTAMIC($0)}
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 73),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 524),
            
            confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            confirmButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
