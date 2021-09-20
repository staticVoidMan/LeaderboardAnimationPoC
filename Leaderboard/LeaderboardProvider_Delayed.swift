//
//  LeaderboardProvider_Delayed.swift
//  Leaderboard
//
//  Created by Amin
//

import Foundation

struct LeaderboardProvider_Delayed: LeaderboardProvider {
    private let provider: LeaderboardProvider
    private let delay: TimeInterval
    
    init(on provider: LeaderboardProvider, by duration: TimeInterval) {
        self.provider = provider
        self.delay = duration
    }
    
    func getPlayers(for style: LeaderboardStyle, completion: @escaping LeaderboardProviderCompletion) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            provider.getPlayers(for: style, completion: completion)
        }
    }
}

extension LeaderboardProvider {
    func delay(by duration: TimeInterval) -> LeaderboardProvider {
        return LeaderboardProvider_Delayed(on: self, by: duration)
    }
}
