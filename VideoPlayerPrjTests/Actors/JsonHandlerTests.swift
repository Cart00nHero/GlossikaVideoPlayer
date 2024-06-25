//
//  JsonHandlerTests.swift
//  VideoPlayerPrjTests
//
//  Created by YuCheng on 2024/6/20.
//

import XCTest
@testable import VideoPlayerPrj

final class JsonHandlerTests: XCTestCase {
    var jsonHandler: JsonHandler!

    override func setUp() {
        super.setUp()
        jsonHandler = JsonHandler()
    }

    override func tearDown() {
        jsonHandler = nil
        super.tearDown()
    }

    func testLoadGeoJSONFromFile_FileExists() {
        // Prepare the bundle without the expected file
        let expectation = self.expectation(description: "GeoJSON file load should succeed")
        var resultData: Data? = nil
        // Execute the method
        DispatchQueue.global().async { [weak self] in
            resultData = self?.jsonHandler.loadGeoJSONFromFile()
            expectation.fulfill()
        }
        // Verify the data is nil
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertNotNil(resultData, "Data should not be nil when the file exists")
    }
}
