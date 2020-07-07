//
//  ContainerPageVC.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 30.06.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit

import JXPageControl

class ContainerPageVC: UIPageViewController {
    
    var pageControl: JXPageControlExchange?
    
    lazy var controllers: [UIViewController?] = {
        
        let first = UIStoryboard.getViewController(storyboardName: .main, controllerIdentifier: "OnboardingSlideViewController") as? OnboardingSlideViewController
        first?.data = OnboardingSlideViewController.SlideData.init(title: "onboarding_title_0".localized, subtitle: "onboarding_subtitle_0".localized, imageName: "onboarding_0")
        let second = UIStoryboard.getViewController(storyboardName: .main, controllerIdentifier: "OnboardingSlideViewController") as? OnboardingSlideViewController
        second?.data = OnboardingSlideViewController.SlideData.init(title: "onboarding_title_1".localized, subtitle: "onboarding_subtitle_1".localized, imageName: "onboarding_1")
        let third = UIStoryboard.getViewController(storyboardName: .main, controllerIdentifier: "OnboardingSlideViewController") as? OnboardingSlideViewController
        third?.data = OnboardingSlideViewController.SlideData.init(title: "onboarding_title_2".localized, subtitle: "onboarding_subtitle_2".localized, imageName: "onboarding_2")
        let fourth = UIStoryboard.getViewController(storyboardName: .main, controllerIdentifier: "OnboardingSlideViewController") as? OnboardingSlideViewController
        fourth?.data = OnboardingSlideViewController.SlideData.init(title: "onboarding_title_3".localized, subtitle: "onboarding_subtitle_3".localized, imageName: "onboarding_3")
    
        return [first, second, third, fourth]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        if let startController = controllers[0] {
            setViewControllers([startController], direction: .forward, animated: true, completion: nil)
        }
        if let scrollView = self.view.subviews.filter({$0.isKind(of: UIScrollView.self)}).first as? UIScrollView {
         //   scrollView.isScrollEnabled = false
        }
    }
    
    func next() {
        if (pageControl!.currentPage + 1) < controllers.count {
            if let nextController = controllers[pageControl!.currentPage + 1] {
                self.setViewControllers([nextController], direction: .forward, animated: true, completion: nil)
                pageControl!.currentPage += 1
            }
        }
    }
}

extension ContainerPageVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = controllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return nil }
        return controllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = controllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < controllers.count else { return nil }
        return controllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl?.currentPage = controllers.firstIndex(of: pageContentViewController)!
    }
}
