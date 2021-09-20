//
//  LeaderboardPlayer.swift
//  Leaderboard
//
//  Created by Amin
//

import Foundation

struct LeaderboardPlayer {
    let id: Int
    let firstName: String?
    let lastName: String?
    
    let rank: Int
    let totalPoints: Int
    let imageURL: String?
    
    let isCurrentPlayer: Bool
    
    var shortName: String { firstName ?? lastName ?? "Anonymous" }
    var fullName: String { [firstName, lastName].compactMap{ $0 }.joined(separator: " ") }
    
    init(id: Int, firstName: String?, lastName: String?, rank: Int, totalPoints: Int, imageURL: String?, isCurrentPlayer: Bool = false) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.rank = rank
        self.totalPoints = totalPoints
        self.imageURL = imageURL
        self.isCurrentPlayer = isCurrentPlayer
    }
}

extension LeaderboardPlayer: Codable {}
