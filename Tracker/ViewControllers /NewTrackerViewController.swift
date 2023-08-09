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
    private let emojiAndColorsCollection = EmojiAndColorsCollection()
    private var heightTableView: CGFloat = 74
    private var currentCategory: String? = "Новая категория"
    private var schedule: [WeekDay]?
    private var swichDays: [WeekDay] = []
    private var trackerText = ""
    private var emoji = ""
    private var color: UIColor = .clear
    private var lastCategory = ""
    
    private var chosenName = false
    private var chosenCategory = false
    private var chosenSchedule = false
    private var chosenEmoji = false
    private var chosenColor = false
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = .uiWhite
        return scroll
    }()
    
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
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.clearButtonMode = .whileEditing
        let leftInsertView = UIView(frame: CGRect(x: 0, y: 0, width: 17, height: 30))
        textField.leftView = leftInsertView
        textField.leftViewMode = .always
        textField.backgroundColor = .uiBackground
        textField.layer.cornerRadius = 16
        textField.clipsToBounds = true
        textField.delegate = self
        return textField
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
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.backgroundColor = .uiWhite
        return collection
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .uiWhite
        addSubviews()
        setConstraints()
        setupCollection()
    }
    
    // MARK: - Action private func
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true) {
        }
    }
    
    @objc private func createButtonTapped() {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            switch self.typeOfNewTracker {
            case .eventTracker:
                let trackerName = textField.text ?? ""
                self.delegate?.addNewTrackerCategory(TrackerCategory(title: lastCategory, trackers: [Tracker(id: UUID(), text: trackerName, emoji: emoji, color: color, schedule: WeekDay.allCases)]))
                
            case .habitTracker:
                guard let schedule = schedule else { return }
                let trackerName = textField.text ?? ""
                self.delegate?.addNewTrackerCategory(TrackerCategory(title: lastCategory, trackers: [Tracker(id: UUID(), text: trackerName, emoji: emoji, color: color, schedule: schedule)]))
            case .none: break
            }
        }
    }
    
    private func buttonIsEnabled() {
        switch typeOfNewTracker {
        case .habitTracker:
            if chosenName == true && chosenCategory == true && chosenSchedule == true && chosenEmoji == true && chosenColor == true {
                saveButton.backgroundColor = .uiBlack
                saveButton.setTitleColor(.uiWhite, for: .normal)
                saveButton.isEnabled = true
            } else {
                saveButton.backgroundColor = .uiGray
                saveButton.setTitleColor(.white, for: .normal)
            }
            
        case .eventTracker:
            if chosenName == true && chosenCategory == true && chosenEmoji == true && chosenColor == true {
                saveButton.backgroundColor = .uiBlack
                saveButton.setTitleColor(.uiWhite, for: .normal)
                saveButton.isEnabled = true
            } else {
                saveButton.backgroundColor = .uiGray
                saveButton.setTitleColor(.white, for: .normal)
            }
        case .none: break
        }
    }
    
    // MARK: - Private func
    
    func setupCollection() {
        collectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SupplementaryView.identifier)
        
        collectionView.register(EmojiAndColorsCollectionCell.self, forCellWithReuseIdentifier: EmojiAndColorsCollectionCell.reuseIdentifier)
        
        collectionView.delegate = emojiAndColorsCollection
        collectionView.dataSource = emojiAndColorsCollection
        emojiAndColorsCollection.delegate = self
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
            cell.detailTextLabel?.text = lastCategory
        case 1:
            cell.textLabel?.text = "Расписание"
            if schedule == WeekDay.allCases {
                cell.detailTextLabel?.text = "Каждый день"
            } else {
                if let schedule = schedule {
                    cell.detailTextLabel?.text = schedule
                        .map { $0.shortName }
                        .joined(separator: ", ")
                }
            }
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
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
        } else if textField.text?.isEmpty == true && !string.isEmpty {
            chosenName = true
        }
        
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text?.isEmpty == true {
            chosenName = false
        }
    }
}

// MARK: - UITableViewDelegate

extension NewTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            guard let categoriesVC = CategoriesAssembly().assemle(
                    with: CategoryConfiguration(lastCategory: lastCategory)
            ) as? CategoriesViewController
            else { return }
            categoriesVC.delegate = self
            present(categoriesVC, animated: true)
        case 1:
            let scheduleVC = ScheduleViewController()
            scheduleVC.delegate = self
            scheduleVC.swichDay = swichDays
            present(scheduleVC, animated: true)
        default: break
        }
    }
}

// MARK: - ScheduleViewControllerDelegate

extension NewTrackerViewController: ScheduleViewControllerDelegate {
    func addNewScedule(_ newShedule: [WeekDay]) {
        schedule = newShedule
        swichDays = newShedule
        chosenSchedule = true
        buttonIsEnabled()
        tableView.reloadData()
    }
}

// MARK: - EmojiAndColorsCollectionDelegate

extension NewTrackerViewController: EmojiAndColorsCollectionDelegate {
    func addNewEmoji(_ emoji: String) {
        self.emoji = emoji
        chosenEmoji = true
        buttonIsEnabled()
    }
    
    func addNewColor(_ color: UIColor) {
        self.color = color
        chosenColor = true
        buttonIsEnabled()
    }
}

extension NewTrackerViewController: CategoriesViewControllerDelegate {
    func didSelectCategory(with name: String?) {
        lastCategory = name ?? ""
        chosenCategory = true
        buttonIsEnabled()
        tableView.reloadData()
    }
}

// MARK: - Set constraints / Add subviews

extension NewTrackerViewController {
    
    private func addSubviews() {
        [titleLabel, scrollView].forEach {
            view.addViewsTAMIC($0)
        }
        [textField, tableView, collectionView, saveButton, cancelButton].forEach {
            scrollView.addViewsTAMIC($0)
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
            
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            textField.topAnchor.constraint(equalTo: scrollView.topAnchor),
            textField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32),
            
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(heightTableView)),
            
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            collectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 484),
            
            cancelButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: -4),
            cancelButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -34),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            
            saveButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            saveButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            saveButton.leadingAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 4),
            saveButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -34),
            saveButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
