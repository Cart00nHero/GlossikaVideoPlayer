//
//  PlayVideoScenarioTests.swift
//  VideoPlayerPrjTests
//
//  Created by YuCheng on 2024/6/24.
//

import XCTest
import Theatre
@testable import VideoPlayerPrj

class PlayVideoScenarioTests: XCTestCase {
    var playVideoScenario: PlayVideoScenario!
    var mockVideoHandler: MockVideoHandler!
    
    override func setUp() {
        super.setUp()
        mockVideoHandler = MockVideoHandler()
        playVideoScenario = PlayVideoScenario(videoHandler: mockVideoHandler)
    }
    
    override func tearDown() {
        playVideoScenario = nil
        mockVideoHandler = nil
        super.tearDown()
    }
    
    func testClaimPlayVideo() {
        // Set up initial state
        let parcelExpectation = XCTestExpectation(description: "get parcel succeed")
        let testCategories: [VideoCategory] = MockCallApi().loadVideoCategories()
        let testScenario = PlayListScenario()
        var resultVideo: Video? = nil
        var testCount: Int = 0
        
        // Perform the action
        guard let category: VideoCategory = testCategories.first else { return }
        DispatchQueue.global().async { [weak self] in
            testScenario.applyExpress(category, recipient: PlayVideoScenario.self)
            testScenario.applyExpress(0, recipient: PlayVideoScenario.self)
            sleep(1)
            self?.playVideoScenario.claimPlayVideo()
        }
        _ = playVideoScenario.playVideoPublisher
            .subscribe(on: DispatchQueue.main)
            .sink(receiveValue: {
                guard
                    let newValue: Video = $0
                else { return }
                resultVideo = newValue
                parcelExpectation.fulfill()
            })
        _ = playVideoScenario.isPlayngPublisher.subscribe(on: DispatchQueue.main).sink(receiveValue: { state in
            guard testCount == 0 else {
                return
            }
            DispatchQueue.global().async { [weak self] in
                self?.playVideoScenario.playClickedAction()
            }
            testCount += 1
        })
        // Verify the results
        wait(for: [parcelExpectation], timeout: 2)
        XCTAssertNotNil(resultVideo, "Shouldn't nil")
        alsoTestOpenPlayList(testScenario)
    }
    
    private func alsoTestOpenPlayList(_ testScenario: PlayListScenario) {
        let trackExpectation = XCTestExpectation(description: "received new parcels")
        var received: Bool = false
        DispatchQueue.global().async { [weak self] in
            self?.playVideoScenario.openPlayList {
                received = true
                trackExpectation.fulfill()
            }
            sleep(1)
            Routine(testScenario).notifyRecipient(PlayVideoScenario.self)
        }
        wait(for: [trackExpectation], timeout: 3)
        XCTAssertTrue(received, "Sould be true")
        alsoTestChangeVideo()
    }
    
    private func alsoTestChangeVideo() {
        let expectationF = XCTestExpectation(description: "foward list")
        let expectationB = XCTestExpectation(description: "backward list")
        var testCount = 0
        DispatchQueue.global().async { [weak self] in
            self?.playVideoScenario.changeVideo(direction: .forward)
        }
        _ = playVideoScenario.playVideoPublisher
            .subscribe(on: DispatchQueue.main)
            .sink(receiveValue: {
                guard $0 != nil else {
                    return
                }
                testCount += 1
                expectationF.fulfill()
                testCount += 1
                expectationB.fulfill()
            })
        wait(for: [expectationF, expectationB], timeout: 4)
        XCTAssertEqual(2, testCount, "Should be 2")
        DispatchQueue.global().async { [weak self] in
            self?.playVideoScenario.changeVideo(direction: .backward)
        }
    }
}
