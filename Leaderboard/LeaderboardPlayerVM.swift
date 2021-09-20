//
//  LeaderboardPlayerVM.swift
//  Leaderboard
//
//  Created by Amin
//

import UIKit

class LeaderboardPlayerVM {
    
    private let player: LeaderboardPlayer
    private var oldPlayer: LeaderboardPlayer?
    
    var id: Int { player.id }
    
    var isCurrentPlayer: Bool { player.isCurrentPlayer }
    
    var shouldAnimateRank: Bool {
        guard let old = oldRank else { return false }
        return old > newRank
    }
    var shouldAnimatePoints: Bool {
        guard let old = oldPoints else { return false }
        return old < newPoints
    }
    
    var newRank: Int { player.rank }
    var newPoints: Int { player.totalPoints }
    
    var oldRank: Int? {
        guard let oldPlayer = oldPlayer, oldPlayer.rank > player.rank else { return nil }
        return oldPlayer.rank
    }
    var oldPoints: Int? {
        guard let oldPlayer = oldPlayer, oldPlayer.totalPoints < player.totalPoints else { return nil }
        return oldPlayer.totalPoints
    }
    
    var rankText: String { rankText(for: oldRank ?? newRank) }
    var fullNameText: String { player.fullName }
    var shortNameText: String { player.shortName }
    var pointsText: String { pointsText(for: oldPoints ?? newPoints) }
    
    var url: URL? { URL(string: player.imageURL ?? "") }
    
    init(player: LeaderboardPlayer, old oldPlayer: LeaderboardPlayer? = nil) {
        self.player = player
        self.oldPlayer = oldPlayer
    }
    
    func animationCompleted() {
        oldPlayer = nil
    }
    
    func pointsText(for value: Int) -> String {
        return value.withSeparators
    }
    
    func rankText(for value: Int) -> String {
        return String(value)
    }
    
}

extension LeaderboardPlayerVM: CustomStringConvertible {
    var description: String { String(describing: player) }
}
