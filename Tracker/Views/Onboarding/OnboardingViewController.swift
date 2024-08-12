//
//  OnboardingController.swift
//  Tracker
//
//  Created by Дмитрий on 11.08.2024.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    
    private lazy var pageControl: UIPageControl = {
        let pageControle = UIPageControl()
        
        pageControle.numberOfPages = pages.count
        pageControle.currentPage = 0
        
        pageControle.currentPageIndicatorTintColor = .ypNavButtonTitle
        pageControle.pageIndicatorTintColor = .ypNavButtonTitle30
                
        return pageControle
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        
        button.setTitle("Вот это технологии!", for: .normal)
        
        button.backgroundColor = .ypNavButtonTitle
        button.setTitleColor(.ypNavButtonBG, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        
        return button
    }()
    
    private lazy var pages: [UIViewController] = {
        let firstVC = OnboardingChildViewController(bgImageName: "onboarding_first_bg", labelString: Strings.Onboarding.first)
        let secondVC = OnboardingChildViewController(bgImageName: "onboarding_second_bg", labelString: Strings.Onboarding.second)
        
        return [firstVC, secondVC]
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, 
                  navigationOrientation: UIPageViewController.NavigationOrientation,
                  options: [UIPageViewController.OptionsKey : Any]? = nil) {
        
        super.init(transitionStyle: style,
                   navigationOrientation: navigationOrientation,
                   options: options)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true)
        }
        
        view.setupView(pageControl)
        view.setupView(button)
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -134),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            button.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else { return nil }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else { return nil }
        
        return pages[nextIndex]
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, 
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if let currentVC = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentVC) {
            pageControl.currentPage = currentIndex
        }
    }
}
