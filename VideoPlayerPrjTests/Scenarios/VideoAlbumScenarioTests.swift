//
//  VideoAlbumScenarioTests.swift
//  VideoPlayerPrjTests
//
//  Created by YuCheng on 2024/6/24.
//

import XCTest
import Theatre
@testable import VideoPlayerPrj

class VideoAlbumScenarioTests: XCTestCase {
    var videoAlbumScenario: VideoAlbumScenario!

    override func setUp() {
        super.setUp()
        videoAlbumScenario = VideoAlbumScenario()
        videoAlbumScenario.callApi = MockCallApi()
    }

    override func tearDown() {
        videoAlbumScenario = nil
        super.tearDown()
    }

    func testLoadVideoCategories() {
        let expectation = self.expectation(description: "load should succeed")
        videoAlbumScenario.loadVideoCategories()
        var categories: [VideoCategory] = []
        videoAlbumScenario.categoriesObserver.addObserver { newArray, _ in
            categories = newArray
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(categories.count, 1)
        XCTAssertEqual(categories[0].name, "Movies")
    }

    func testSendPlayListParcel() {
        let parcelExpectation = self.expectation(description: "get parcel succeed")
        let selectionExpectation = XCTestExpectation(description: "Received selected notification")
        let testScenario = PlayListScenario()
        var parcelCount = 0
        var result: Bool = false
        let category = VideoCategory.with {
            $0.name = "Category1"
        }
        DispatchQueue.global().async { [weak self] in
            self?.videoAlbumScenario.sendPlayListParcel(category: category)
            sleep(1)
            parcelCount = testScenario.claimParcels().count
            parcelExpectation.fulfill()
        }
        wait(for: [parcelExpectation], timeout: 2)
        XCTAssertTrue(parcelCount > 0, "Sould larger than 0")
        DispatchQueue.global().async {
            Routine(testScenario).notifyRecipient(VideoAlbumScenario.self)
        }
        _ = videoAlbumScenario.videoSelectedPublisher
            .subscribe(on: DispatchQueue.main)
            .sink(receiveValue: {
                guard $0 else {
                    return
                }
                result = true
                selectionExpectation.fulfill()
            })
        wait(for: [selectionExpectation], timeout: 5)
        XCTAssertTrue(result, "Should be true")
    }
}
