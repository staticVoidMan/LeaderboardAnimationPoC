//
//  PlayerStatisticsProvider.swift
//  Leaderboard
//
//  Created by Amin
//

typealias PlayerStatisticsProviderResult = Result<PlayerStatistics,Error>
typealias PlayerStatisticsProviderCompletion = (PlayerStatisticsProviderResult) -> Void

protocol PlayerStatisticsProvider {
    func getPlayer(id: Int, completion: @escaping PlayerStatisticsProviderCompletion)
}
