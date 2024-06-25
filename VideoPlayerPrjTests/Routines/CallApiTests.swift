//
//  CallApiTests.swift
//  VideoPlayerPrjTests
//
//  Created by YuCheng on 2024/6/24.
//

import XCTest
import Theatre
@testable import VideoPlayerPrj

final class CallApiTests: XCTestCase {
    var jsonHandlerMock: JsonHandlerMock!
    var scenario: Scenario!
    var callApi: CallApi!

    override func setUp() {
        super.setUp()
        jsonHandlerMock = JsonHandlerMock()
        scenario = Scenario()
        callApi = CallApi(scenario, jsonHandler: jsonHandlerMock)
    }

    override func tearDownWithError() throws {
        jsonHandlerMock = nil
        scenario = nil
        callApi = nil
        super.tearDown()
    }

    func testLoadVideoCategoriesWithValidData() throws {
        // Given
        let validJsonString = """
        {
           "categories":[
              {
                 "name":"Movies",
                 "videos":[
                    {
                       "description":"The Smoking Tire meets up with Chris and Jorge from CarsForAGrand.com to see just how far $1,000 can go when looking for a car.The Smoking Tire meets up with Chris and Jorge from CarsForAGrand.com to see just how far $1,000 can go when looking for a car.",
                       "sources":[
                          "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4"
                       ],
                       "subtitle":"By Garage419",
                       "thumb":"images/WhatCarCanYouGetForAGrand.jpg",
                       "title":"What care can you get for a grand?"
                    }
                 ]
              }
           ]
        }
        """
        let expectation = self.expectation(description: "GeoJSON file load should succeed")
        jsonHandlerMock.mockData = validJsonString.data(using: .utf8)
        var categories: [VideoCategory] = []
        // When
        DispatchQueue.global().async { [weak self] in
            categories = self?.callApi.loadVideoCategories() ?? []
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(categories.count, 1)
        XCTAssertEqual(categories[0].name, "Movies")
    }

    func testLoadVideoCategoriesWithInvalidData() throws {
        // Given
        let invalidJsonString = "{ invalid json }"
        jsonHandlerMock.mockData = invalidJsonString.data(using: .utf8)
        
        // When
        let categories = callApi.loadVideoCategories()
        
        // Then
        XCTAssertEqual(categories.count, 0)
    }

    func testLoadVideoCategoriesWithNoData() throws {
        // Given
        jsonHandlerMock.mockData = nil
        
        // When
        let categories = callApi.loadVideoCategories()
        
        // Then
        XCTAssertEqual(categories.count, 0)
    }
}
