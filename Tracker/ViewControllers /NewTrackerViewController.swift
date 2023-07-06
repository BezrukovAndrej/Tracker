//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Andrey Bezrukov on 28.06.2023.
//

import UIKit

protocol NewTrackerViewControllerDelegate: AnyObject {
    func addNewTrackerCategory(_ newTrackerCategory: TrackerCategory)
}

final class NewTrackerViewController: UIViewController {
    
    weak var delegate: NewTrackerViewControllerDelegate?
    var typeOfNewTracker: TypeTracker?
    private var heightTableView: CGFloat = 74
    private var currentCategory: String? = "Новая категория"
    private var schedule: [WeekDay] = []
    private var trackerText = ""
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.ypMedium16()
        label.textColor = .uiBlack
        switch typeOfNewTracker {
        case .habitTracker: label.text = "Новая привычка"
        case .eventTracker: label.text = "Новое нерегулярное событие"
        case .none: break
        }
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Введите название трекера"
        let leftInsertView = UIView(frame: CGRect(x: 0, y: 0, width: 17, height: 30))
        textfield.leftView = leftInsertView
        textfield.leftViewMode = .always
        textfield.backgroundColor = .uiBackground
        textfield.layer.cornerRadius = 16
        textfield.clipsToBounds = true
        textfield.delegate = self
        return textfield
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .uiBackground
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.isScrollEnabled = false
        tableView.separatorColor = .uiGray
        return tableView
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.uiRed, for: .normal)
        button.titleLabel?.font = UIFont.ypMedium16()
        button.backgroundColor = .uiWhite
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.uiRed.cgColor
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.uiWhite, for: .normal)
        button.titleLabel?.font = UIFont.ypMedium16()
        button.backgroundColor = .uiGray
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
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
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true) {
        }
    }
    
    @objc private func createButtonTapped() {
        dismiss(animated: true)
        let trackerName = textField.text ?? ""
        delegate?.addNewTrackerCategory(TrackerCategory(title: "Новая категория",
                                                             trackers: [Tracker.init(id: UUID(),
                                                                                     text: trackerName,
                                                                                     emoji: "🔥",
                                                                                     color: .uiBlue,
                                                                                     schedule: self.schedule)]))
    }
    
    // MARK: - Private func
    
    private func buttonIsEnabled() {
        if textField.text?.isEmpty == false && ((currentCategory?.isEmpty != nil)) {
            saveButton.backgroundColor = .uiBlack
            saveButton.setTitleColor(.uiWhite, for: .normal)
            saveButton.isEnabled = true
        }
    }
}

// MARK: - UITableViewDataSource

extension NewTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch typeOfNewTracker {
        case .habitTracker: return 2
        case .eventTracker: return 1
        case .none: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.detailTextLabel?.font = UIFont.ypRegular17()
        cell.detailTextLabel?.textColor = .uiGray
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Категория"
            cell.detailTextLabel?.text = currentCategory
        case 1:
            cell.textLabel?.text = "Расписание"
            cell.detailTextLabel?.text = scheduleToString(for: schedule)
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    private func scheduleToString(for: [WeekDay]) -> String {
        guard schedule.count != WeekDay.allCases.count else { return "Каждый день" }

        let scheduleSorted = schedule.sorted()
        let scheduleShortName = scheduleSorted.map { $0.shortName }.joined(separator: ", ")
        return scheduleShortName
    }
}

// MARK: - UITextFieldDelegate

extension NewTrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        trackerText = textField.text ?? ""
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if range.location == 0 && string == " " {
            return false
        }
        
        switch typeOfNewTracker {
        case .habitTracker:
            if schedule.isEmpty == false {
                buttonIsEnabled()
                return true
            }
        case .eventTracker:
            buttonIsEnabled()
            return true
        case .none:
            return true
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text?.isEmpty == true {
            saveButton.backgroundColor = .uiGray
            saveButton.setTitleColor(.uiWhite, for: .normal)
            saveButton.isEnabled = false
        }
    }
}

// MARK: - UITableViewDelegate

extension NewTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            break
        case 1:
            let sheduleVC = ScheduleViewController()
            sheduleVC.delegate = self
            present(sheduleVC, animated: true)
        default:
            break
        }
    }
}

// MARK: - ScheduleViewControllerDelegate

extension NewTrackerViewController: ScheduleViewControllerDelegate {
    func addNewScedule(_ newShedule: [WeekDay]) {
        schedule = newShedule
        tableView.reloadData()
        buttonIsEnabled()
    }
}

// MARK: - Set constraints / Add subviews

extension NewTrackerViewController {
    
    private func addSubviews() {
        [titleLabel, textField, tableView, cancelButton, saveButton].forEach {
            view.addViewsTAMIC($0)
        }
    }
    
    private func setConstraints() {
        switch typeOfNewTracker {
        case .eventTracker: heightTableView = 74
        case .habitTracker: heightTableView = 149
        case .none: break
        }
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32),
            
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: heightTableView),
            
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cancelButton.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: -8),
            cancelButton.heightAnchor.constraint(equalToConstant: 50),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            saveButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor),
            saveButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor)
        ])
    }
}
