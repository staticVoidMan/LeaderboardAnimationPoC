//
//  LeaderboardPlayerCell.swift
//  Leaderboard
//
//  Created by Amin
//

import UIKit
import SDWebImage

class LeaderboardPlayerCell: UITableViewCell {
    
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var rankLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var pointsLabel: UILabel!
    
    private var pointsAnimator: SlotAnimator?
    private var rankAnimator: SlotAnimator?
    
    private var viewModel: LeaderboardPlayerVM!
    
    func setup(viewModel: LeaderboardPlayerVM) {
        pointsAnimator?.cancel()
        rankAnimator?.cancel()
        
        self.viewModel = viewModel
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.size.height/2
        profileImageView.layer.masksToBounds = true
        
        profileImageView.sd_setImage(with: viewModel.url, placeholderImage: profilePlaceholderImage)
        
        nameLabel.text = viewModel.fullNameText
        rankLabel.text = viewModel.rankText
        pointsLabel.text = viewModel.pointsText
        
        let backgroundColor: UIColor = viewModel.isCurrentPlayer ? brandColor : .white
        let textColor: UIColor = viewModel.isCurrentPlayer ? .white : .black
        
        containerView.backgroundColor = backgroundColor
        rankLabel.textColor = textColor
        nameLabel.textColor = textColor
        pointsLabel.textColor = textColor
    }
    
    func animateContentChanges() {
        animatePointsIfNeeded()
        animateRankIfNeeded()
    }
    
    func animateWithDropDownEffect() {
        let firstTransform  : CGAffineTransform = .identity.scaledBy(x: 0.9, y: 0.9).translatedBy(x: 0, y: -8)
        let secondTransform : CGAffineTransform = .identity
        let thirdTransform  : CGAffineTransform = .identity.translatedBy(x: 0, y: 8)
        
        self.transform = firstTransform
        self.alpha = 0
        UIView.animate(withDuration: 0.1) {
            self.transform = secondTransform
            self.alpha = 1
        }
        UIView.animate(withDuration: 0.05, delay: 0.1) {
            self.transform = thirdTransform
        }
    }
    
}

extension LeaderboardPlayerCell {
    
    private func animatePointsIfNeeded() {
        guard viewModel.shouldAnimatePoints, let oldPoints = viewModel.oldPoints else { return }
        
        self.pointsAnimator = SlotAnimator(from: oldPoints, to: viewModel.newPoints)
            .observeUpdates { [weak self] newValue in
                guard let _weakSelf = self else { return }
                DispatchQueue.main.async {
                    _weakSelf.pointsLabel.text = _weakSelf.viewModel.pointsText(for: newValue)
                }
            }
            .observeCompletion { [weak self] in
                self?.viewModel.animationCompleted()
                self?.pointsAnimator = nil
            }
        
        self.pointsAnimator?.start()
    }
    
    private func animateRankIfNeeded() {
        guard viewModel.shouldAnimateRank, let oldRank = viewModel.oldRank else { return }
        
        self.rankAnimator = SlotAnimator(from: oldRank, to: viewModel.newRank)
            .observeUpdates { [weak self] newValue in
                guard let _weakSelf = self else { return }
                DispatchQueue.main.async {
                    _weakSelf.rankLabel.text = _weakSelf.viewModel.rankText(for: newValue)
                }
            }
            .observeCompletion { [weak self] in
                self?.viewModel.animationCompleted()
                self?.rankAnimator = nil
            }
        
        self.rankAnimator?.start()
    }
    
}
