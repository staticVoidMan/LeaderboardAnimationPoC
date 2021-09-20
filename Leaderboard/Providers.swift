//
//  Providers.swift
//  Leaderboard
//
//  Created by Amin
//

enum Providers {
    
    static var leaderboard: LeaderboardProvider {
        return LeaderboardProvider_Dummy().delay(by: 1)
    }
    
    static var playerStatistics: PlayerStatisticsProvider {
        return PlayerStatisticsProvider_Dummy().delay(by: 1.5)
    }
    
}
