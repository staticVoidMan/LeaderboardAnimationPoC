//
//  PlayerStatisticsProvider_Delayed.swift
//  Leaderboard
//
//  Created by Amin
//

import Foundation

struct PlayerStatisticsProvider_Delayed: PlayerStatisticsProvider {
    private let provider: PlayerStatisticsProvider
    private let delay: TimeInterval
    
    init(on provider: PlayerStatisticsProvider, by duration: TimeInterval) {
        self.provider = provider
        self.delay = duration
    }
    
    func getPlayer(id: Int, completion: @escaping PlayerStatisticsProviderCompletion) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            provider.getPlayer(id: id, completion: completion)
        }
    }
}

extension PlayerStatisticsProvider {
    func delay(by duration: TimeInterval) -> PlayerStatisticsProvider {
        return PlayerStatisticsProvider_Delayed(on: self, by: duration)
    }
}


