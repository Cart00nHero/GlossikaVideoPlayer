//
//  PlayListScenarioTests.swift
//  VideoPlayerPrjTests
//
//  Created by YuCheng on 2024/6/24.
//

import XCTest
import Theatre
@testable import VideoPlayerPrj

final class PlayListScenarioTests: XCTestCase {
    var playListScenario: PlayListScenario!
    
    override func setUp() {
        super.setUp()
        playListScenario = PlayListScenario()
    }
    
    override func tearDown() {
        playListScenario = nil
        super.tearDown()
    }
    
    func testClaimPlayList() {
        claimParcelsTestMethod(testScenario: VideoAlbumScenario())
    }
    
    func testSelectVideoFromPlayVideoScenario() {
        claimParcelsTestMethod(testScenario: PlayVideoScenario())
    }
    
    private func claimParcelsTestMethod(testScenario: Scenario) {
        // Assuming Parcel and claimParcels are properly defined and used
        let testCategories: [VideoCategory] = MockCallApi().loadVideoCategories()
        let parcelExpectation = XCTestExpectation(description: "get parcel succeed")
        let selectionExpectation = XCTestExpectation(description: "Received selected notification")
        var resultList: [Video] = []
        var received: Bool = false
        
        // Mock claimParcels() method to return the parcel
        DispatchQueue.global().async {
            Routine(testScenario).trackParcels {
                received = true
                selectionExpectation.fulfill()
            }
        }
        DispatchQueue.global().async { [weak self] in
            guard let category: VideoCategory = testCategories.first else { return }
            testScenario.applyExpress(
                category, recipient: PlayListScenario.self)
            sleep(1)
            self?.playListScenario.claimPlayList()
        }
        playListScenario.playListsObserver.addObserver { result, _ in
            resultList = result
            parcelExpectation.fulfill()
        }
        // Verify Parcel
        wait(for: [parcelExpectation], timeout: 2)
        XCTAssertEqual(3, resultList.count, "Count should be 3")
        DispatchQueue.global().async { [weak self] in
            self?.playListScenario.selectVideo(at: 0)
        }
        wait(for: [selectionExpectation], timeout: 5)
        XCTAssertTrue(received, "Should be true")
    }
}
