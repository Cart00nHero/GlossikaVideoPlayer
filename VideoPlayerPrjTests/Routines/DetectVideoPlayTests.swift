//
//  DetectVideoPlayTests.swift
//  VideoPlayerPrjTests
//
//  Created by YuCheng on 2024/6/23.
//

import XCTest
import AVFoundation
import Combine
import Theatre
@testable import VideoPlayerPrj

class DetectVideoPlayTests: XCTestCase {
    var player: AVPlayer!
    var detectVideoPlay: DetectVideoPlay!
    var scenario: Scenario!

    override func setUp() {
        super.setUp()
        player = AVPlayer()
        scenario = Scenario()
        detectVideoPlay = DetectVideoPlay(scenario, player: player)
    }

    override func tearDown() {
        detectVideoPlay.stopDetecting()
        player = nil
        detectVideoPlay = nil
        scenario = nil
        super.tearDown()
    }

    func testDetectingPlayState() {
        let playStateExpectation = expectation(description: "Play state detected")

        detectVideoPlay.detectingPlayState { isPlaying in
            if isPlaying {
                playStateExpectation.fulfill()
            }
        }

        player.play()
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testDetectEndOfPlaying() {
        let endOfPlayingExpectation = expectation(description: "End of playing detected")
        detectVideoPlay.detectEndOfPlaying {
            endOfPlayingExpectation.fulfill()
        }
        if let videoURL: URL = Bundle.main.url(forResource: "TestVideo", withExtension: "mp4") {
            let playerItem = AVPlayerItem(url: videoURL)
            player.replaceCurrentItem(with: playerItem)
            // Seek to the end of the video to trigger the end of playing notification
            player.seek(to: CMTime(seconds: 20, preferredTimescale: 1))
            player.play()
        } else {
            XCTFail("Missing file")
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testStopDetecting() {
        detectVideoPlay.stopDetecting()

        // No expectations to fulfill, just ensuring no crashes or unwanted behavior
    }
}
