//
//  RootViewController.swift
//  Fallz
//
//  Created by Carl Henry Roosipuu on 3/5/18.
//  Copyright © 2018 Carl Henry Roosipuu. All rights reserved.
//

import UIKit

class RootViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pageControl = UIPageControl()
    
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 35,width: UIScreen.main.bounds.width,height: 50))
        self.pageControl.numberOfPages = 3
        self.pageControl.currentPage = 1
        self.pageControl.tintColor = UIColor(red: 0.0862745098, green: 0.2352941176, blue: 0.5098039216, alpha: 1)
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.currentPageIndicatorTintColor = UIColor(red: 0.0862745098, green: 0.2352941176, blue: 0.5098039216, alpha: 1)
        self.view.addSubview(pageControl)
    }
    
    lazy var viewControllerList:[UIViewController] = {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let vc1 = sb.instantiateViewController(withIdentifier: "LeaderboardVC")
        let vc2 = sb.instantiateViewController(withIdentifier: "PlayVC")
        let vc3 = sb.instantiateViewController(withIdentifier: "BallVC")
        
        return [vc1, vc2, vc3]
    }()
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController) else {return nil}
        
        let previousIndex = vcIndex - 1
        
        guard previousIndex >= 0 else {return nil}
        
        guard viewControllerList.count > previousIndex else {return nil}
        
        return viewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController) else {return nil}
        
        let nextIndex = vcIndex + 1
        
        guard viewControllerList.count != nextIndex else {return nil}
        
        guard viewControllerList.count > nextIndex else {return nil}
        
        return viewControllerList[nextIndex]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self

        self.setViewControllers([viewControllerList[1]], direction: .forward, animated: true, completion: nil)
        
        self.delegate = self
        configurePageControl()

        
        

        // Do any additional setup after loading the view.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = viewControllerList.index(of: pageContentViewController)!
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if #available(iOS 11.0, *) {
            view.bounds = self.view.safeAreaLayoutGuide.layoutFrame
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

}
