//
//  LeaderboardSelectionVC.swift
//  Leaderboard
//
//  Created by Amin
//

import UIKit

class LeaderboardSelectionVC: UIViewController {
    
    @IBOutlet var segmentController: UISegmentedControl!
    var pageController: LeaderboardSelectionPageVC!
    
    var viewModel: LeaderboardSelectionVM = .init(styles: [.all, .department])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentControlUI()
        
        viewModel.leaderboardSwitched { [weak self] in
            guard let _weakSelf = self else { return }
            _weakSelf.segmentController.selectedSegmentIndex = _weakSelf.viewModel.selectedIndex
        }
        viewModel.availableLeaderboardsUpdated { [weak self] in
            self?.reloadSegmentControl()
        }
    }
    
    func setupSegmentControlUI() {
        let normalColor: UIColor = .white
        let selectedColor = brandColor
        let font = UIFont.systemFont(ofSize: 13, weight: .bold)
        
        segmentController.applyiOS12Style()
        
        segmentController.selectedSegmentTintColor = selectedColor
        segmentController.setTitleTextAttributes([.font: font,
                                                  .foregroundColor: selectedColor],
                                                 for: .normal)
        segmentController.setTitleTextAttributes([.font: font,
                                                  .foregroundColor: normalColor],
                                                 for: .selected)
    }
    
    func reloadSegmentControl() {
        segmentController.removeAllSegments()
        
        for (index, style) in viewModel.leaderboardStyles.enumerated() {
            segmentController.insertSegment(withTitle: style.title, at: index, animated: false)
            segmentController.selectedSegmentIndex = viewModel.selectedIndex
        }
    }
    
    @IBAction func segmentControllerDidSelect(_ sender: UISegmentedControl) {
        loadSelectedLeaderboard()
    }
    
    func loadSelectedLeaderboard() {
        viewModel.selectLeaderboard(index: segmentController.selectedSegmentIndex)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? LeaderboardSelectionPageVC {
            self.pageController = destination
            self.pageController.viewModel = viewModel
        }
    }
    
}

