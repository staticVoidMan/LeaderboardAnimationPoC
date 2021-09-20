//
//  Top3PlayersVC.swift
//  OneHuddle
//
//  Created by Amin
//  Copyright © 2021 1Huddle. All rights reserved.
//

import UIKit

class Top3PlayersVC: UIViewController {
    
    struct PlayerElementGroup: Equatable {
        weak var container: UIView!
        weak var imageViewContainer: UIView!
        weak var imageView: UIImageView!
        weak var nameLabel: UILabel!
        weak var pointsLabel: UILabel!
        weak var rankLabel: UILabel!
    }
    
    @IBOutlet var firstPlayerContainer: UIView!
    @IBOutlet var firstPlayerImageContainer: UIView!
    @IBOutlet var firstPlayerImageView: UIImageView!
    @IBOutlet var firstPlayerNameLabel: UILabel!
    @IBOutlet var firstPlayerPointsLabel: UILabel!
    @IBOutlet var firstPlayerRankLabel: UILabel!
    
    @IBOutlet var secondPlayerContainer: UIView!
    @IBOutlet var secondPlayerImageContainer: UIView!
    @IBOutlet var secondPlayerImageView: UIImageView!
    @IBOutlet var secondPlayerNameLabel: UILabel!
    @IBOutlet var secondPlayerPointsLabel: UILabel!
    @IBOutlet var secondPlayerRankLabel: UILabel!
    
    @IBOutlet var thirdPlayerContainer: UIView!
    @IBOutlet var thirdPlayerImageContainer: UIView!
    @IBOutlet var thirdPlayerImageView: UIImageView!
    @IBOutlet var thirdPlayerNameLabel: UILabel!
    @IBOutlet var thirdPlayerPointsLabel: UILabel!
    @IBOutlet var thirdPlayerRankLabel: UILabel!
    
    lazy var firstPlayerTapGesture = UITapGestureRecognizer()
    lazy var secondPlayerTapGesture = UITapGestureRecognizer()
    lazy var thirdPlayerTapGesture = UITapGestureRecognizer()
    
    lazy var elementGroups: [PlayerElementGroup] = [.init(container           : firstPlayerContainer,
                                                          imageViewContainer  : firstPlayerImageContainer,
                                                          imageView           : firstPlayerImageView,
                                                          nameLabel           : firstPlayerNameLabel,
                                                          pointsLabel         : firstPlayerPointsLabel,
                                                          rankLabel           : firstPlayerRankLabel),
                                                    .init(container           : secondPlayerContainer,
                                                          imageViewContainer: secondPlayerImageContainer,
                                                          imageView           : secondPlayerImageView,
                                                          nameLabel           : secondPlayerNameLabel,
                                                          pointsLabel         : secondPlayerPointsLabel,
                                                          rankLabel           : secondPlayerRankLabel),
                                                    .init(container           : thirdPlayerContainer,
                                                          imageViewContainer  : thirdPlayerImageContainer,
                                                          imageView           : thirdPlayerImageView,
                                                          nameLabel           : thirdPlayerNameLabel,
                                                          pointsLabel         : thirdPlayerPointsLabel,
                                                          rankLabel           : thirdPlayerRankLabel)]
    
    private var pointsAnimator: SlotAnimator?
    private var rankAnimator: SlotAnimator?
    
    private var viewModel: Top3PlayersVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestureRecognizers()
    }
    
    private func setupGestureRecognizers() {
        firstPlayerContainer.addGestureRecognizer(firstPlayerTapGesture)
        secondPlayerContainer.addGestureRecognizer(secondPlayerTapGesture)
        thirdPlayerContainer.addGestureRecognizer(thirdPlayerTapGesture)
        
        [firstPlayerTapGesture, secondPlayerTapGesture, thirdPlayerTapGesture].forEach { gesture in
            gesture?.addTarget(self, action: #selector(playerTapped(_:)))
        }
    }
    
    func setup(with viewModel: Top3PlayersVM) {
        pointsAnimator?.cancel()
        rankAnimator?.cancel()
        
        self.viewModel = viewModel
    }
    
    func updateUI() {
        elementGroups.enumerated().forEach { (idx, group) in
            let player = viewModel.players[idx]
            
            group.container.alpha = 1
            
            group.nameLabel.text = player.shortNameText
            
            group.pointsLabel.text = player.pointsText
            group.rankLabel.text = player.rankText
            
            group.imageView.sd_setImage(with: player.url, placeholderImage: profilePlaceholderImage)
            
            group.rankLabel.layer.cornerRadius = group.rankLabel.bounds.height/2
            group.rankLabel.layer.masksToBounds = true
            group.rankLabel.layer.borderWidth = 1
            group.rankLabel.layer.borderColor = UIColor.white.cgColor
            
            group.imageView.layer.cornerRadius = group.imageView.bounds.height/2
            group.imageView.layer.masksToBounds = true
            group.imageView.layer.borderWidth = player.isCurrentPlayer ? 5 : 1
            group.imageView.layer.borderColor = player.isCurrentPlayer ? brandColor.cgColor : UIColor.white.cgColor
            
            group.imageViewContainer.addShadow()
            
            let textColor: UIColor = player.isCurrentPlayer ? brandColor : .black
            group.nameLabel.textColor = textColor
            group.pointsLabel.textColor = textColor
            
            group.rankLabel.textColor = .white
            group.rankLabel.backgroundColor = brandColor
            
            animateContentChanges(in: group, with: player)
        }
    }
    
    func animateContentChanges(in group: PlayerElementGroup, with player: LeaderboardPlayerVM) {
        let fadeDuration = 0.27
        let scaleDuration = 1.27
        
        let fadeStartDelay = 0.27
        let scaleStartDelay = 0.27
        let counterStartDelay = 1.3
        
        if player.shouldAnimateRank || player.shouldAnimatePoints {
            group.container.alpha = 0
            UIView.animate(withDuration: fadeDuration,
                           delay: fadeStartDelay,
                           options: .curveEaseIn) {
                group.container.alpha = 1
            }
            
            group.container.transform = group.container.transform.scaledBy(x: 1.5, y: 1.5)
            UIView.animate(withDuration: scaleDuration,
                           delay: scaleStartDelay,
                           usingSpringWithDamping: 0.4,
                           initialSpringVelocity: 0.1,
                           options: .curveEaseIn) {
                group.container.transform = .identity
            }
        }
        
        if player.shouldAnimateRank,
           let oldRank = player.oldRank {
            self.rankAnimator = SlotAnimator(from: oldRank, to: player.newRank)
                .observeUpdates { newValue in
                    DispatchQueue.main.async {
                        group.rankLabel.text = player.rankText(for: newValue)
                    }
                }
                .observeCompletion { [weak self] in
                    player.animationCompleted()
                    self?.rankAnimator = nil
                }
            self.rankAnimator?.start(after: counterStartDelay)
        }
        
        if player.shouldAnimatePoints,
           let oldPoints = player.oldPoints {
            self.pointsAnimator = SlotAnimator(from: oldPoints, to: player.newPoints)
                .observeUpdates { newValue in
                    DispatchQueue.main.async {
                        group.pointsLabel.text = player.pointsText(for: newValue)
                    }
                }
                .observeCompletion { [weak self] in
                    player.animationCompleted()
                    self?.pointsAnimator = nil
                }
            self.pointsAnimator?.start(after: counterStartDelay)
        }
    }
    
    @objc
    func playerTapped(_ sender: UITapGestureRecognizer) {
        let index: Int = {
            if sender == firstPlayerTapGesture {
                return 0
            } else if sender == secondPlayerTapGesture {
                return 1
            } else if sender == thirdPlayerTapGesture {
                return 2
            } else {
                fatalError("TILT")
            }
        }()
        
        viewModel.didSelect(index: index)
    }
    
}
