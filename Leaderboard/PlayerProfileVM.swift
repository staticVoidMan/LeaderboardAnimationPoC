//
//  PlayerProfileVM.swift
//  Leaderboard
//
//  Created by Amin
//

import Foundation

struct PlayerStatisticsVM {
    let statistics: PlayerStatistics
    
    var totalPointsText: String { statistics.points.withSeparators }
    var gamesPlayedText: String { statistics.gamesPlayed.withSeparators }
    var trophiesWonText: String { statistics.trophyCount.withSeparators }
    var perfectGamesText: String { statistics.perfectGamesCount.withSeparators }
    var contestsWonText: String { statistics.contestCount.withSeparators }
}

class PlayerProfileVM {
    
    struct PlayerDetails {
        let id: Int
        let name: String
        let imageURL: URL?
    }
    
    let playerDetails: PlayerDetails
    private let provider: PlayerStatisticsProvider
    var playerStatistics: PlayerStatisticsVM?
    
    var messageText: String? = nil
    
    init(playerDetails: PlayerDetails, provider: PlayerStatisticsProvider) {
        self.playerDetails = playerDetails
        self.provider = provider
    }
    
    func load(_ completion: @escaping ()->Void) {
        provider.getPlayer(id: playerDetails.id) { [weak self] result in
            guard let _weakSelf = self else { return }
            
            switch result {
            case .success(let statistics):
                _weakSelf.playerStatistics = .init(statistics: statistics)
            case .failure(let error):
                _weakSelf.messageText = error.localizedDescription
            }
            
            completion()
        }
    }
    
}
