//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Andrey Bezrukov on 27.06.2023.
//

import UIKit

import UIKit

final class StatisticViewController: UIViewController {
    
    private var viewModel: StatisticsViewModel
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("statistics", comment: "")
        label.font = UIFont.ypBold34()
        label.textColor = .toggleBlackWhiteColor
        return label
    }()
    
    private lazy var emptyStatisticsImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "crySmile")!
        return image
    }()
    
    private lazy var emptyStatisticsLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("emptyStatistics.text", comment: "")
        label.font = UIFont.ypMedium12()
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            StatisticCell.self,
            forCellReuseIdentifier: StatisticCell.identifier
        )
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    init(viewModel: StatisticsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setConstraints()
        bindingViewModel()
        
        tableView.dataSource = self
        tableView.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.startObserve()
    }
    
    // MARK: - Private func
    
    private func bindingViewModel() {
        viewModel.$isEmptyPlaceholderHidden.bind { [weak self] isEmptyPlaceholderHidden in
            self?.toggleStatisticsPlaceholder(show: isEmptyPlaceholderHidden)
        }
        
        viewModel.$bestPeriod.bind { [weak self] newValue in
            self?.updateCellModel(for: .bestPeriod, value: newValue)
        }
        viewModel.$perfectDays.bind { [weak self] newValue in
            self?.updateCellModel(for: .perfectDays, value: newValue)
        }
        viewModel.$complitedTrackers.bind { [weak self] newValue in
            self?.updateCellModel(for: .complitedTrackers, value: newValue)
        }
        viewModel.$mediumValue.bind { [weak self] newValue in
            self?.updateCellModel(for: .mediumValue, value: newValue)
        }
    }
    
    private func updateCellModel(for statisticsCase: StatisticsCases, value: Int) {
        let cellModel = StatisticsCellModel(value: String(value), description: statisticsCase.description)
        
        if let index = viewModel.cellModels.firstIndex(where: { $0.description == statisticsCase.description }) {
            viewModel.cellModels[index] = cellModel
        } else {
            viewModel.cellModels.append(cellModel)
        }
        tableView.reloadData()
    }
    
    private func toggleStatisticsPlaceholder(show: Bool) {
        emptyStatisticsImageView.isHidden = show
        emptyStatisticsLabel.isHidden = show
        tableView.isHidden = !show
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension StatisticViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        StatisticsCases.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StatisticCell.identifier, for: indexPath) as? StatisticCell else { return UITableViewCell() }
        
        let cellModel = viewModel.cellModels[indexPath.row]
        cell.configureCell(with: cellModel)
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension StatisticViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        102
    }
}

// MARK: - Set constraints / Add subviews

extension StatisticViewController {
    
    private func addSubviews() {
        view.backgroundColor = .uiWhite
        
        [titleLabel, emptyStatisticsLabel,
         emptyStatisticsImageView, tableView].forEach { view.addViewsTAMIC($0) }
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 52),
            
            emptyStatisticsImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStatisticsImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            emptyStatisticsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStatisticsLabel.topAnchor.constraint(equalTo: emptyStatisticsImageView.bottomAnchor, constant: 8),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 77),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 408)
        ])
    }
}
