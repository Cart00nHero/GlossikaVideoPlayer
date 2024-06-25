//
//  VideoHandlerTests.swift
//  VideoPlayerPrjTests
//
//  Created by YuCheng on 2024/6/22.
//

import XCTest
import AVFoundation
@testable import VideoPlayerPrj

final class VideoHandlerTests: XCTestCase {

    var videoHandler: VideoHandler!

    override func setUp() {
        super.setUp()
        videoHandler = VideoHandler()
    }

    override func tearDown() {
        videoHandler = nil
        super.tearDown()
    }

    func testGenerateThumbnail_FileExists() {
        // Prepare a mock bundle with the expected video file
        let expectation = self.expectation(description: "Thumbnail generation should succeed")
        guard let videoURL: URL = Bundle.main.url(forResource: "TestVideo", withExtension: "mp4") else {
            XCTFail("Missing file")
            return
        }
        var resultImage: UIImage? = nil

        // Execute the method
        DispatchQueue.global().async { [weak self] in
            resultImage = self?.videoHandler.generateThumbnail(from: videoURL)
            expectation.fulfill()
        }
        
        // Verify the image is not nil
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertNotNil(resultImage, "Thumbnail should not be nil when the video file exists")
    }

    func testGenerateThumbnail_FileNotFound() {
        // Prepare a URL for a non-existing video file
        let expectation = self.expectation(description: "Thumbnail generation should fail")
        let nonExistentURL = URL(fileURLWithPath: "/path/to/nonexistent/video.mp4")
        var resultImage: UIImage? = nil

        // Execute the method
        DispatchQueue.global().async { [weak self] in
            resultImage = self?.videoHandler.generateThumbnail(from: nonExistentURL)
            expectation.fulfill()
        }

        // Verify the image is nil
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertNil(resultImage, "Thumbnail should be nil when the video file does not exist")
    }
}
