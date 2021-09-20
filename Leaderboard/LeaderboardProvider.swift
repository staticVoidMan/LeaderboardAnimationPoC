//
//  LeaderboardProvider.swift
//  Leaderboard
//
//  Created by Amin
//

import Foundation

typealias LeaderboardProviderResult = Result<[LeaderboardPlayer],Error>
typealias LeaderboardProviderCompletion = (LeaderboardProviderResult) -> Void

protocol LeaderboardProvider {
    func getPlayers(for style: LeaderboardStyle, completion: @escaping LeaderboardProviderCompletion)
}


