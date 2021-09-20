//
//  LeaderboardSelectionVM.swift
//  Leaderboard
//
//  Created by Amin
//

import Foundation

enum LeaderboardStyle: Int, Comparable {
    case all
    case department
    case group
    
    var title: String {
        switch self {
        case .all        : return "All".uppercased()
        case .department : return "Department".uppercased()
        case .group      : return "Group".uppercased()
        }
    }
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs != .group && rhs != .all
    }
}

class LeaderboardSelectionVM {
    
    typealias VoidHandler = () -> Void
    
    private(set) var leaderboardStyles: [LeaderboardStyle]
    private(set) var selectedIndex: Int
    var selectedStyle: LeaderboardStyle { leaderboardStyles[selectedIndex] }
    
    private var leaderboardSwitchedObservers = [VoidHandler]()
    private var availableLeaderboardsUpdatedObservers = [VoidHandler]()
    
    init(styles: [LeaderboardStyle]) {
        self.leaderboardStyles = Set(styles).sorted()
        selectedIndex = 0
    }
    
    func updateStyles(_ styles: [LeaderboardStyle]) {
        self.leaderboardStyles = Set(styles).sorted()
        availableLeaderboardsUpdatedObservers.forEach { $0() }
        
        if selectedIndex > leaderboardStyles.count - 1  {
            updateSelectedIndex(to: 0)
        }
    }
    
    func leaderboardSwitched(_ handler: @escaping VoidHandler) {
        handler()
        leaderboardSwitchedObservers.append(handler)
    }
    
    func availableLeaderboardsUpdated(_ handler: @escaping VoidHandler) {
        handler()
        self.availableLeaderboardsUpdatedObservers.append(handler)
    }
    
    func selectLeaderboard(style: LeaderboardStyle) {
        guard let index = leaderboardStyles.firstIndex(of: style) else { return }
        updateSelectedIndex(to: index)
    }
    
    func selectLeaderboard(index: Int) {
        guard index < leaderboardStyles.count else { return }
        updateSelectedIndex(to: index)
    }
    
    private func updateSelectedIndex(to index: Int) {
        selectedIndex = index
        leaderboardSwitchedObservers.forEach { $0() }
    }
    
}
