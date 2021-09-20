//
//  PlayerProfileVC.swift
//  Leaderboard
//
//  Created by Amin
//

import UIKit
import SDWebImage

class PlayerProfileVC: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var statisticsContainer: UIView!
    
    @IBOutlet var totalPointsContainerView: UIView!
    @IBOutlet var totalPointsTitleLabel: UILabel!
    @IBOutlet var totalPointsValueLabel: UILabel!
    
    @IBOutlet var gamesPlayedContainerView: UIView!
    @IBOutlet var gamesPlayedTitleLabel: UILabel!
    @IBOutlet var gamesPlayedValueLabel: UILabel!
    
    @IBOutlet var perfectGamesContainerView: UIView!
    @IBOutlet var perfectGamesTitleLabel: UILabel!
    @IBOutlet var perfectGamesValueLabel: UILabel!
    
    @IBOutlet var trophiesContainerView: UIView!
    @IBOutlet var trophiesTitleLabel: UILabel!
    @IBOutlet var trophiesValueLabel: UILabel!
    
    @IBOutlet var contestsWonContainerView: UIView!
    @IBOutlet var contestsWonTitleLabel: UILabel!
    @IBOutlet var contestsWonValueLabel: UILabel!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var messageLabel: UILabel!
    
    var viewModel: PlayerProfileVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupUI()
    }
    
    func setupUI() {
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.bounds.size.height/2
        
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        
        imageView.sd_setImage(with: viewModel.playerDetails.imageURL,
                              placeholderImage: profilePlaceholderImage)
        nameLabel.text = viewModel.playerDetails.name
        
        [totalPointsContainerView,
         gamesPlayedContainerView,
         trophiesContainerView,
         perfectGamesContainerView,
         contestsWonContainerView]
            .forEach { view in
                view?.backgroundColor = .white
                
                view?.layer.cornerRadius = 8
                view?.addShadow()
            }
    }
    
    func updateUI() {
        activityIndicator.stopAnimating()
        
        if let playerStatistics = viewModel.playerStatistics {
            statisticsContainer.isHidden = false
            
            totalPointsValueLabel.text  = playerStatistics.totalPointsText
            
            gamesPlayedValueLabel.text  = playerStatistics.gamesPlayedText
            perfectGamesValueLabel.text = playerStatistics.perfectGamesText
            
            trophiesValueLabel.text     = playerStatistics.trophiesWonText
            contestsWonValueLabel.text  = playerStatistics.contestsWonText
        } else if let messageText = viewModel.messageText {
            messageLabel.isHidden = false
            messageLabel.text = messageText
        }
    }
    
    func loadData() {
        statisticsContainer.isHidden = true
        messageLabel.isHidden = true
        activityIndicator.startAnimating()
        
        viewModel.load { [weak self] in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
    }
    
}
