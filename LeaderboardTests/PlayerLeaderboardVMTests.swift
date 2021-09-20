//
//  LeaderboardTests.swift
//  LeaderboardTests
//
//  Created by Amin
//

import XCTest
@testable import Leaderboard

class LeaderboardProvider_Stub: LeaderboardProvider {
    private var responses: [LeaderboardProviderResult]
    
    init(responses: [LeaderboardProviderResult]) {
        self.responses = responses
    }
    
    func getPlayers(for style: LeaderboardStyle, completion: @escaping LeaderboardProviderCompletion) {
        let response: LeaderboardProviderResult = {
            if responses.isEmpty {
                let error = NSError(domain: "",
                                    code: 0,
                                    userInfo: [NSLocalizedDescriptionKey: "No more responses in stub"])
                return .failure(error)
            } else {
                return responses.removeFirst()
            }
        }()
        
        completion(response)
    }
}

class PlayerLeaderboardVMTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_CanLoad() {
        let players: [LeaderboardPlayer] = [.init(id: 0,
                                                  firstName: "Lorem",
                                                  lastName: "Ipsum",
                                                  rank: 1,
                                                  totalPoints: 100,
                                                  imageURL: "url")]
        let provider = LeaderboardProvider_Stub(responses: [.success(players)])
        let sut = PlayerLeaderboardVM(with: .all, provider: provider)
        sut.load {}
        
        XCTAssertEqual(sut.top3Players.count, 0)
        XCTAssertEqual(sut.listPlayers.count, 1)
        XCTAssertEqual(sut.messageText, nil)
    }
    
    func test_CanHandleError() {
        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Some Error"])
        let provider = LeaderboardProvider_Stub(responses: [.failure(error)])
        let sut = PlayerLeaderboardVM(with: .all, provider: provider)
        sut.load {}
        
        XCTAssertEqual(sut.messageText, "Some Error")
    }
    
    func test_AfterError_OnRefresh_WithSuccess_CanLoad() {
        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Some Error"])
        let players: [LeaderboardPlayer] = [.init(id: 0,
                                                  firstName: "Lorem",
                                                  lastName: "Ipsum",
                                                  rank: 1,
                                                  totalPoints: 100,
                                                  imageURL: "url")]
        
        let provider = LeaderboardProvider_Stub(responses: [.failure(error),
                                                            .success(players)])
        let sut = PlayerLeaderboardVM(with: .all, provider: provider)
        
        sut.load {}
        XCTAssertEqual(sut.top3Players.count, 0)
        XCTAssertEqual(sut.listPlayers.count, 0)
        XCTAssertEqual(sut.messageText, "Some Error")
        
        sut.load {}
        XCTAssertEqual(sut.top3Players.count, 0)
        XCTAssertEqual(sut.listPlayers.count, 1)
        XCTAssertEqual(sut.messageText, nil)
    }
    
    func test_AfterSuccess_OnRefresh_WithError_CanHandleError() {
        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Some Error"])
        let players: [LeaderboardPlayer] = [.init(id: 0,
                                                  firstName: "Lorem",
                                                  lastName: "Ipsum",
                                                  rank: 1,
                                                  totalPoints: 100,
                                                  imageURL: "url")]
        
        let provider = LeaderboardProvider_Stub(responses: [.success(players),
                                                            .failure(error)])
        let sut = PlayerLeaderboardVM(with: .all, provider: provider)
        
        sut.load {}
        XCTAssertEqual(sut.top3Players.count, 0)
        XCTAssertEqual(sut.listPlayers.count, 1)
        XCTAssertEqual(sut.messageText, nil)
        
        sut.load {}
        XCTAssertEqual(sut.top3Players.count, 0)
        XCTAssertEqual(sut.listPlayers.count, 0)
        XCTAssertEqual(sut.messageText, "Some Error")
    }
    
    func test_CanLoad_ThreePlayers() {
        let players: [LeaderboardPlayer] = [.init(id: 0,
                                                  firstName: "Lorem",
                                                  lastName: "Ipsum",
                                                  rank: 1,
                                                  totalPoints: 100,
                                                  imageURL: "url"),
                                            .init(id: 1,
                                                  firstName: "Dolor",
                                                  lastName: "Set",
                                                  rank: 2,
                                                  totalPoints: 90,
                                                  imageURL: "url"),
                                            .init(id: 2,
                                                  firstName: "Amet",
                                                  lastName: "Consectetur",
                                                  rank: 3,
                                                  totalPoints: 80,
                                                  imageURL: "url")]
        let provider = LeaderboardProvider_Stub(responses: [.success(players)])
        let sut = PlayerLeaderboardVM(with: .all, provider: provider)
        sut.load {}
        
        XCTAssertEqual(sut.top3Players.count, 0)
        XCTAssertEqual(sut.listPlayers.count, 3)
        
        XCTAssertEqual(sut.listPlayers[0].rankText, "1")
        XCTAssertEqual(sut.listPlayers[0].fullNameText, "Lorem Ipsum")
        XCTAssertEqual(sut.listPlayers[1].rankText, "2")
        XCTAssertEqual(sut.listPlayers[1].fullNameText, "Dolor Set")
        XCTAssertEqual(sut.listPlayers[2].rankText, "3")
        XCTAssertEqual(sut.listPlayers[2].fullNameText, "Amet Consectetur")
    }
    
    func test_CanLoad_MoreThanThreePlayers() {
        let players: [LeaderboardPlayer] = [.init(id: 0,
                                                  firstName: "Lorem",
                                                  lastName: "Ipsum",
                                                  rank: 1,
                                                  totalPoints: 100,
                                                  imageURL: "url"),
                                            .init(id: 1,
                                                  firstName: "Dolor",
                                                  lastName: "Set",
                                                  rank: 2,
                                                  totalPoints: 90,
                                                  imageURL: "url"),
                                            .init(id: 2,
                                                  firstName: "Amet",
                                                  lastName: "Consectetur",
                                                  rank: 3,
                                                  totalPoints: 80,
                                                  imageURL: "url"),
                                            .init(id: 3,
                                                  firstName: "Adipiscing",
                                                  lastName: "Elit",
                                                  rank: 4,
                                                  totalPoints: 70,
                                                  imageURL: "url")]
        
        let provider = LeaderboardProvider_Stub(responses: [.success(players)])
        let sut = PlayerLeaderboardVM(with: .all, provider: provider)
        sut.load {}
        
        XCTAssertEqual(sut.top3Players.count, 3)
        XCTAssertEqual(sut.listPlayers.count, 1)
        
        XCTAssertEqual(sut.top3Players[0].rankText, "1")
        XCTAssertEqual(sut.top3Players[0].fullNameText, "Lorem Ipsum")
        XCTAssertEqual(sut.top3Players[1].rankText, "2")
        XCTAssertEqual(sut.top3Players[1].fullNameText, "Dolor Set")
        XCTAssertEqual(sut.top3Players[2].rankText, "3")
        XCTAssertEqual(sut.top3Players[2].fullNameText, "Amet Consectetur")
        
        XCTAssertEqual(sut.listPlayers[0].rankText, "4")
        XCTAssertEqual(sut.listPlayers[0].fullNameText, "Adipiscing Elit")
    }
    
    func test_OnSelect_InList_CanGetPlayer() {
        let players: [LeaderboardPlayer] = [.init(id: 0,
                                                  firstName: "Lorem",
                                                  lastName: "Ipsum",
                                                  rank: 1,
                                                  totalPoints: 100,
                                                  imageURL: "url"),
                                            .init(id: 1,
                                                  firstName: "Dolor",
                                                  lastName: "Set",
                                                  rank: 2,
                                                  totalPoints: 90,
                                                  imageURL: "url"),
                                            .init(id: 2,
                                                  firstName: "Amet",
                                                  lastName: "Consectetur",
                                                  rank: 3,
                                                  totalPoints: 80,
                                                  imageURL: "url"),
                                            .init(id: 3,
                                                  firstName: "Adipiscing",
                                                  lastName: "Elit",
                                                  rank: 4,
                                                  totalPoints: 70,
                                                  imageURL: "url")]
        let provider = LeaderboardProvider_Stub(responses: [.success(players)])
        let sut = PlayerLeaderboardVM(with: .all, provider: provider)
        
        let exp = XCTestExpectation(description: "Expected Selected Player from Top-3")
        sut.observeDidSelectPlayer { player in
            XCTAssertEqual(player.fullNameText, "Dolor Set")
            exp.fulfill()
        }
        sut.load {}
        XCTAssertNoThrow(try sut.didSelectTop3Player(at: 1))
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_OnSelect_InTop3_CanGetPlayer() {
        let players: [LeaderboardPlayer] = [.init(id: 0,
                                                  firstName: "Lorem",
                                                  lastName: "Ipsum",
                                                  rank: 100,
                                                  totalPoints: 100,
                                                  imageURL: "url")]
        let provider = LeaderboardProvider_Stub(responses: [.success(players)])
        let sut = PlayerLeaderboardVM(with: .all, provider: provider)
        
        let exp = XCTestExpectation(description: "Expected Selected Player from List")
        sut.observeDidSelectPlayer { player in
            XCTAssertEqual(player.fullNameText, "Lorem Ipsum")
            exp.fulfill()
        }
        sut.load {}
        XCTAssertNoThrow(try sut.didSelectListPlayer(at: 0))
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_OnInvalidPlayerIndex_ShouldThrowError() {
        let players: [LeaderboardPlayer] = [.init(id: 0,
                                                  firstName: "Lorem",
                                                  lastName: "Ipsum",
                                                  rank: 100,
                                                  totalPoints: 100,
                                                  imageURL: "url")]
        let provider = LeaderboardProvider_Stub(responses: [.success(players)])
        let sut = PlayerLeaderboardVM(with: .all, provider: provider)
        sut.load {}
        
        XCTAssertThrowsError(try sut.didSelectTop3Player(at: 0))
        XCTAssertThrowsError(try sut.didSelectListPlayer(at: 1))
    }

}
