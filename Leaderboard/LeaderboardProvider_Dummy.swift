//
//  LeaderboardProvider_Dummy.swift
//  Leaderboard
//
//  Created by Amin
//

import Foundation

extension LeaderboardPlayer {
    private static var names: [String] = [
        "Dotty Premo",
        "Tessie Mccallon",
        "Lizette Scalzo",
        "Sharee Daigre",
        "Refugia Victorino",
        "Marget Wardell",
        "Percy Swan",
        "Donnie Coatney",
        "Sunday Leatham",
        "Jacalyn Coty",
        "Jacqualine Liebel",
        "Erik Copley",
        "Craig Ehrhardt",
        "Melina Holloway",
        "Dori Durling",
        "Clarine Borgman",
        "Parker Finger",
        "Cora Felt",
        "Mirtha Becerril",
        "Delila Tabron",
        "Leighann Willcox",
        "Nanci Ezzell",
        "September Amador",
        "Vern Huckabee",
        "Shavonne Ruffo",
        "Elmer Scheid",
        "Peggy Magdaleno",
        "Carina Richison",
        "Virginia Thome",
        "Alejandra Knoblock",
        "Alfonzo Rundle",
        "Joshua Olmo",
        "Debroah Gillmore",
        "Rikki Chretien",
        "Abbie Wommack",
        "Noelle Hemmings",
        "Twanna Maske",
        "Emilio Schutte",
        "Beatris Hibbert",
        "Candra Sitsler",
        "Shelba Barra",
        "Joselyn Griese",
        "Blondell Waldrip",
        "France Wessels",
        "Nerissa Lipp",
        "Fernande Stephan",
        "Kaycee Hobbs",
        "Lavera Gregerson",
        "Belle Robitaille",
        "Darleen Newbrough"
    ]
    
    static func createPlayer(id: UInt, points: Int) -> Self {
        let id = Int(id)
        let name = names[id].split(separator: " ").map(String.init)
        let imageURL = "https://robohash.org/\(id).png?set=set2&bgset=bg\(id % 2 + 1)"
        
        let player = LeaderboardPlayer(id: id,
                                       firstName: name[0],
                                       lastName: name[1],
                                       rank: -1,
                                       totalPoints: points,
                                       imageURL: imageURL)
        return player
    }
}

class LeaderboardProvider_Dummy: LeaderboardProvider {
    
    private var responses: [[LeaderboardPlayer]]
    private var responseIndex: Int = 0
    private let currentPlayerID: UInt = 0
    
    init() {
        self.responses = [
            [.createPlayer(id: 1               , points: 2000),
             .createPlayer(id: 2               , points: 1900),
             .createPlayer(id: currentPlayerID , points: 0)],
            
            [.createPlayer(id: 1               , points: 2000),
             .createPlayer(id: 2               , points: 1900),
             .createPlayer(id: 3               , points: 1800),
             .createPlayer(id: currentPlayerID , points: 0)],
            
            [.createPlayer(id: 1               , points: 2000),
             .createPlayer(id: 2               , points: 1900),
             .createPlayer(id: 3               , points: 1800),
             .createPlayer(id: 4               , points: 1700),
             .createPlayer(id: 5               , points: 1600),
             .createPlayer(id: 6               , points: 1500),
             .createPlayer(id: 7               , points: 1400),
             .createPlayer(id: 8               , points: 1300),
             .createPlayer(id: 9               , points: 1200),
             .createPlayer(id: 10              , points: 1100),
             .createPlayer(id: 11              , points: 1000),
             .createPlayer(id: 12              , points: 900),
             .createPlayer(id: 13              , points: 800),
             .createPlayer(id: 14              , points: 700),
             .createPlayer(id: 15              , points: 600),
             .createPlayer(id: 16              , points: 500),
             .createPlayer(id: 17              , points: 400),
             .createPlayer(id: 18              , points: 300),
             .createPlayer(id: 19              , points: 200),
             .createPlayer(id: 20              , points: 100),
             .createPlayer(id: currentPlayerID , points: 0)],
            
            [.createPlayer(id: 1               , points: 2000),
             .createPlayer(id: 2               , points: 1900),
             .createPlayer(id: 3               , points: 1800),
             .createPlayer(id: 4               , points: 1700),
             .createPlayer(id: 5               , points: 1600),
             .createPlayer(id: 6               , points: 1500),
             .createPlayer(id: 7               , points: 1400),
             .createPlayer(id: 8               , points: 1300),
             .createPlayer(id: 9               , points: 1200),
             .createPlayer(id: 10              , points: 1100),
             .createPlayer(id: 11              , points: 1000),
             .createPlayer(id: 12              , points: 900),
             .createPlayer(id: 13              , points: 800),
             .createPlayer(id: 14              , points: 700),
             .createPlayer(id: 15              , points: 600),
             .createPlayer(id: currentPlayerID , points: 550),
             .createPlayer(id: 16              , points: 500),
             .createPlayer(id: 17              , points: 400),
             .createPlayer(id: 18              , points: 300),
             .createPlayer(id: 19              , points: 200),
             .createPlayer(id: 20              , points: 100)],
            
            [.createPlayer(id: 1               , points: 2000),
             .createPlayer(id: 2               , points: 1900),
             .createPlayer(id: 3               , points: 1800),
             .createPlayer(id: 4               , points: 1700),
             .createPlayer(id: 5               , points: 1600),
             .createPlayer(id: currentPlayerID , points: 1501),
             .createPlayer(id: 6               , points: 1500),
             .createPlayer(id: 7               , points: 1400),
             .createPlayer(id: 8               , points: 1300),
             .createPlayer(id: 9               , points: 1200),
             .createPlayer(id: 10              , points: 1100),
             .createPlayer(id: 11              , points: 1000),
             .createPlayer(id: 12              , points: 900),
             .createPlayer(id: 13              , points: 800),
             .createPlayer(id: 14              , points: 700),
             .createPlayer(id: 15              , points: 600),
             .createPlayer(id: 16              , points: 500),
             .createPlayer(id: 17              , points: 400),
             .createPlayer(id: 18              , points: 300),
             .createPlayer(id: 19              , points: 200),
             .createPlayer(id: 20              , points: 100)],
            
            [.createPlayer(id: 1               , points: 2000),
             .createPlayer(id: 2               , points: 1900),
             .createPlayer(id: currentPlayerID , points: 1852),
             .createPlayer(id: 3               , points: 1800),
             .createPlayer(id: 4               , points: 1700),
             .createPlayer(id: 5               , points: 1600),
             .createPlayer(id: 6               , points: 1500),
             .createPlayer(id: 7               , points: 1400),
             .createPlayer(id: 8               , points: 1300),
             .createPlayer(id: 9               , points: 1200),
             .createPlayer(id: 10              , points: 1100),
             .createPlayer(id: 11              , points: 1000),
             .createPlayer(id: 12              , points: 900),
             .createPlayer(id: 13              , points: 800),
             .createPlayer(id: 14              , points: 700),
             .createPlayer(id: 15              , points: 600),
             .createPlayer(id: 16              , points: 500),
             .createPlayer(id: 17              , points: 400),
             .createPlayer(id: 18              , points: 300),
             .createPlayer(id: 19              , points: 200),
             .createPlayer(id: 20              , points: 100)],
            
            [.createPlayer(id: 1               , points: 2000),
             .createPlayer(id: currentPlayerID , points: 1903),
             .createPlayer(id: 2               , points: 1900),
             .createPlayer(id: 3               , points: 1800),
             .createPlayer(id: 4               , points: 1700),
             .createPlayer(id: 5               , points: 1600),
             .createPlayer(id: 6               , points: 1500),
             .createPlayer(id: 7               , points: 1400),
             .createPlayer(id: 8               , points: 1300),
             .createPlayer(id: 9               , points: 1200),
             .createPlayer(id: 10              , points: 1100),
             .createPlayer(id: 11              , points: 1000),
             .createPlayer(id: 12              , points: 900),
             .createPlayer(id: 13              , points: 800),
             .createPlayer(id: 14              , points: 700),
             .createPlayer(id: 15              , points: 600),
             .createPlayer(id: 16              , points: 500),
             .createPlayer(id: 17              , points: 400),
             .createPlayer(id: 18              , points: 300),
             .createPlayer(id: 19              , points: 200),
             .createPlayer(id: 20              , points: 100)],
            
            [.createPlayer(id: currentPlayerID , points: 2054),
             .createPlayer(id: 1               , points: 2000),
             .createPlayer(id: 2               , points: 1900),
             .createPlayer(id: 3               , points: 1800),
             .createPlayer(id: 4               , points: 1700),
             .createPlayer(id: 5               , points: 1600),
             .createPlayer(id: 6               , points: 1500),
             .createPlayer(id: 7               , points: 1400),
             .createPlayer(id: 8               , points: 1300),
             .createPlayer(id: 9               , points: 1200),
             .createPlayer(id: 10              , points: 1100),
             .createPlayer(id: 11              , points: 1000),
             .createPlayer(id: 12              , points: 900),
             .createPlayer(id: 13              , points: 800),
             .createPlayer(id: 14              , points: 700),
             .createPlayer(id: 15              , points: 600),
             .createPlayer(id: 16              , points: 500),
             .createPlayer(id: 17              , points: 400),
             .createPlayer(id: 18              , points: 300),
             .createPlayer(id: 19              , points: 200),
             .createPlayer(id: 20              , points: 100)],
        ]
    }
    
    func getPlayers(for style: LeaderboardStyle, completion: @escaping LeaderboardProviderCompletion) {
        if style == .all {
            let response: [LeaderboardPlayer] = responses[responseIndex].enumerated().map { (index, player) in
                LeaderboardPlayer(id: player.id,
                                  firstName: player.firstName,
                                  lastName: player.lastName,
                                  rank: index + 1,
                                  totalPoints: player.totalPoints,
                                  imageURL: player.imageURL,
                                  isCurrentPlayer: player.id == currentPlayerID)
            }
            
            completion(.success(response))
            
            responseIndex = responseIndex < responses.count - 1 ? responseIndex + 1 : 0
        } else {
            let error = NSError(domain: "",
                                code: 0,
                                userInfo: [NSLocalizedDescriptionKey : "You do not have access to this leaderboard\n[Dummy Error]"])
            completion(.failure(error))
        }
    }
}
