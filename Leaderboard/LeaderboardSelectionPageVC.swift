//
//  LeaderboardSelectionPageVC.swift
//  Leaderboard
//
//  Created by Amin
//

import UIKit

class LeaderboardSelectionPageVC: UIPageViewController {
    
    var viewModel: LeaderboardSelectionVM!
    var leaderboards = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        self.dataSource = self
        self.delegate = self
        
        viewModel.availableLeaderboardsUpdated { [unowned self] in
            self.buildLeaderboards()
        }
        
        viewModel.leaderboardSwitched { [unowned self] in
            self.showSelectedLeaderboard()
        }
    }
    
}

extension LeaderboardSelectionPageVC {
    
    func buildLeaderboards() {
        func makeLeaderboard(for style: LeaderboardStyle) -> UIViewController {
            let vc = PlayerLeaderboardVC(nibName: "PlayerLeaderboardVC", bundle: nil)
            vc.viewModel = .init(with: style, provider: Providers.leaderboard)
            return vc
        }
        
        var newLeaderboards = [UIViewController]()
        for (index, style) in viewModel.leaderboardStyles.enumerated() {
            let leaderboard: UIViewController = {
                if leaderboards.count < index + 1 {
                    return makeLeaderboard(for: style)
                } else {
                    return leaderboards[index]
                }
            }()
            
            newLeaderboards.append(leaderboard)
        }
        
        leaderboards = newLeaderboards
    }
    
    func showSelectedLeaderboard() {
        let newIndex = viewModel.selectedIndex
        let oldIndex: Int = {
            guard let vc = viewControllers?.first else { return -1 }
            return leaderboards.firstIndex(of: vc) ?? -1
        }()
        
        guard newIndex != oldIndex else { return }
        
        let newVC = leaderboards[newIndex]
        setViewControllers([newVC], direction: oldIndex < newIndex ? .forward : .reverse, animated: true)
    }
    
}

extension LeaderboardSelectionPageVC: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = leaderboards.firstIndex(of: viewController),
              index > 0
        else { return nil }
        
        let previousIndex = index - 1
        return leaderboards[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = leaderboards.firstIndex(of: viewController),
              index < leaderboards.count - 1
        else { return nil }
        
        let nextIndex = index + 1
        return leaderboards[nextIndex]
    }
    
}

extension LeaderboardSelectionPageVC: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let index = leaderboards.firstIndex(of: viewControllers!.first!)!
        viewModel.selectLeaderboard(index: index)
    }
    
}
