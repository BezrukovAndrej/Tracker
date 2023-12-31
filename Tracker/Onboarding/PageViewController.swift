//
//  PageViewController.swift
//  Tracker
//
//  Created by Andrey Bezrukov on 08.08.2023.
//

import UIKit

final class PageViewController: UIPageViewController {
    
    private var pages: [Pages] = Pages.allCases
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .systemGray
        pageControl.addTarget(self, action: #selector(pageControlDidChange), for: .valueChanged)
        return pageControl
    }()
    
    private lazy var onboardingButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("onboardingPageViewController.Button", comment: ""), for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.tintColor = .white
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(onboardingButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setConstraints()
        setupPageController()
    }
    
    // MARK: - Action private funс
    
    @objc
    private func onboardingButtonTapped() {
        let tabBarVC = TabBarController()
        tabBarVC.modalPresentationStyle = .fullScreen
        present(tabBarVC, animated: true)
    }
    
    @objc
    private func pageControlDidChange(_ sender: UIPageControl) {
        let current = sender.currentPage
        let initialVC = OnboardingViewController(with: pages[current])
        setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)
    }
    
    private func setupPageController() {
        dataSource = self
        delegate = self
        let initialVC = OnboardingViewController(with: pages[0])
        setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)
    }
}

// MARK: - UIPageViewControllerDelegate

extension PageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first as? OnboardingViewController {
            pageControl.currentPage = currentViewController.page.index
        }
    }
}

// MARK: - UIPageViewControllerDataSource

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? OnboardingViewController else { return nil }
        var index = currentVC.page.index
        if index == 0 {
            return nil
        }
        
        index -= 1
        let vc = OnboardingViewController(with: pages[index])
        
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? OnboardingViewController else { return nil }
        var index = currentVC.page.index
        if index >= self.pages.count - 1 {
            return nil
        }
        
        index += 1
        let vc = OnboardingViewController(with: pages[index])
        
        return vc
    }
}

// MARK: - Set constraints / Add subviews

extension PageViewController {
    
    private func addSubviews() {
        [pageControl, onboardingButton].forEach {view.addViewsTAMIC($0)}
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: onboardingButton.topAnchor, constant: -24),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            onboardingButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84),
            onboardingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            onboardingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            onboardingButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
