//
//  Top3PlayersVM.swift
//  OneHuddle
//
//  Created by Amin
//  Copyright © 2021 1Huddle. All rights reserved.
//

import UIKit

class Top3PlayersVM {
    
    typealias DidSelectHandler = (Int) -> Void
    
    private(set) var players: [LeaderboardPlayerVM]
    private var didSelectHandler: DidSelectHandler?
    
    init(with players: [LeaderboardPlayerVM]) {
        self.players = players
    }
    
    @discardableResult
    func observeDidSelect(_ handler: @escaping DidSelectHandler) -> Self {
        self.didSelectHandler = handler
        return self
    }
    
    func didSelect(index: Int) {
        didSelectHandler?(index)
    }
    
}
