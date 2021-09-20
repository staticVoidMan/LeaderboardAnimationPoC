//
//  PlayerProfile.swift
//  Leaderboard
//
//  Created by Amin
//

struct PlayerStatistics {
    let playerID: Int
    
    let trophyCount: Int
    let contestCount: Int
    let perfectGamesCount: Int
    let gamesPlayed: Int
    let points: Int
}

extension PlayerStatistics: Codable {}
