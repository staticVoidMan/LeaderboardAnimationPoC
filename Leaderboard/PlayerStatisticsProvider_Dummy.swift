//
//  PlayerStatisticsProvider_Dummy.swift
//  Leaderboard
//
//  Created by Amin
//

import Foundation

struct PlayerStatisticsProvider_Dummy: PlayerStatisticsProvider {
    func getPlayer(id: Int, completion: @escaping PlayerStatisticsProviderCompletion) {
        let statistics = PlayerStatistics(playerID: id,
                                          trophyCount: 7,
                                          contestCount: 1,
                                          perfectGamesCount: 42,
                                          gamesPlayed: 100,
                                          points: 777)
        let error = NSError(domain: "",
                            code: 0,
                            userInfo: [NSLocalizedDescriptionKey: "Something went wrong, Please try again later.\n[Dummy Error]"])
        
        let responses: [PlayerStatisticsProviderResult] = [.success(statistics), .failure(error)]
        completion(responses.randomElement()!)
    }
}
