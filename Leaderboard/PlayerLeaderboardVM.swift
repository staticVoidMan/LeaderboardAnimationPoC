//
//  PlayerLeaderboardVM.swift
//  Leaderboard
//
//  Created by Amin
//

import Foundation

struct InvalidPlayerIndex: Error {}

class PlayerLeaderboardVM {
    
    typealias DidSelectPlayerHandler = (LeaderboardPlayerVM) -> Void
    
    private let style: LeaderboardStyle
    private let provider: LeaderboardProvider
    
    private var oldPlayer: LeaderboardPlayer!
    
    private(set) var top3Players: [LeaderboardPlayerVM] = []
    private(set) var listPlayers: [LeaderboardPlayerVM] = []
    
    private var didSelectPlayerHandler: DidSelectPlayerHandler?
    
    var messageText: String?
    
    init(with style: LeaderboardStyle, provider: LeaderboardProvider) {
        self.provider = provider
        self.style = style
    }
    
    func load(completion: @escaping ()->Void) {
        provider.getPlayers(for: style) { [weak self] result in
            guard let _weakSelf = self else { return }
            
            switch result {
            case .success(let players):
                let playersVMs: [LeaderboardPlayerVM] = players.map { (player) in
                    if player.isCurrentPlayer {
                        let vm = LeaderboardPlayerVM(player: player, old: _weakSelf.oldPlayer)
                        _weakSelf.oldPlayer = player
                        return vm
                    } else {
                        return .init(player: player)
                    }
                }
                
                if playersVMs.count > 3 {
                    _weakSelf.top3Players = Array(playersVMs[0...2])
                    _weakSelf.listPlayers = Array(playersVMs[3...])
                } else {
                    _weakSelf.top3Players = []
                    _weakSelf.listPlayers = playersVMs
                }
                
                _weakSelf.messageText = nil
            case .failure(let error):
                _weakSelf.top3Players = []
                _weakSelf.listPlayers = []
                _weakSelf.messageText = error.localizedDescription
            }
            
            completion()
        }
    }
    
    func didSelectTop3Player(at index: Int) throws {
        guard index < top3Players.count else { throw InvalidPlayerIndex() }
        let player = top3Players[index]
        didSelectPlayerHandler?(player)
    }
    
    func didSelectListPlayer(at index: Int) throws {
        guard index < listPlayers.count else { throw InvalidPlayerIndex() }
        let player = listPlayers[index]
        didSelectPlayerHandler?(player)
    }
    
    func observeDidSelectPlayer(_ handler: @escaping DidSelectPlayerHandler) {
        self.didSelectPlayerHandler = handler
    }
    
}
