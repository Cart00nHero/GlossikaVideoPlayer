//
//  VideoPlayerPrjTests.swift
//  VideoPlayerPrjTests
//
//  Created by YuCheng on 2024/6/24.
//

import XCTest
@testable import VideoPlayerPrj

final class VideoPlayerPrjTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class JsonHandlerMock: JsonHandlerProtocol {
    var mockData: Data?

    func loadGeoJSONFromFile() -> Data? {
        return mockData
    }
}

class MockCallApi: CallApiProtocol {
    func loadVideoCategories() -> [VideoCategory] {
        let validJsonString = """
        {
           "categories":[
              {
                 "name":"Movies",
                 "videos":[
                    {
                       "description":"Sintel is an independently produced short film, initiated by the Blender Foundation as a means to further improve and validate the free/open source 3D creation suite Blender. With initial funding provided by 1000s of donations via the internet community, it has again proven to be a viable development model for both open 3D technology as for independent animation film.\nThis 15 minute film has been realized in the studio of the Amsterdam Blender Institute, by an international team of artists and developers. In addition to that, several crucial technical and creative targets have been realized online, by developers and artists and teams all over the world.\nwww.sintel.org",
                       "sources":[
                          "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4"
                       ],
                       "subtitle":"By Blender Foundation",
                       "thumb":"images/Sintel.jpg",
                       "title":"Sintel"
                    },
                    {
                       "description":"Smoking Tire takes the all-new Subaru Outback to the highest point we can find in hopes our customer-appreciation Balloon Launch will get some free T-shirts into the hands of our viewers.",
                       "sources":[
                          "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4"
                       ],
                       "subtitle":"By Garage419",
                       "thumb":"images/SubaruOutbackOnStreetAndDirt.jpg",
                       "title":"Subaru Outback On Street And Dirt"
                    },
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
        var result: [VideoCategory] = []
        
        do {
            let testData = try MediaData(jsonString: validJsonString)
            result = testData.categories
        } catch {
            print(error.localizedDescription)
        }
        return result
    }
}

class MockVideoHandler: VideoHandlerProtocol {
    func generateThumbnail(from url: URL) -> UIImage? {
        return UIImage(systemName: "list.bullet.rectangle.portrait")
    }
}

class MockDetectVideoPlay: DetectVideoPlayProtocol {
    var mockPlaying: Bool = false
    func detectingPlayState(_ received: @escaping (Bool) -> Void) {
        received(mockPlaying)
    }
    
    func detectEndOfPlaying(_ complete: @escaping () -> Void) {
        complete()
    }
    
    func stopDetecting() {}
}
