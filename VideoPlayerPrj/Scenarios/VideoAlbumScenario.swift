//
//  VideoCategoriesScenario.swift
//  VideoPlayerPrj
//
//  Created by YuCheng on 2024/6/21.
//

import Foundation
import Theatre

class VideoAlbumScenario: Scenario {
    @ObservableArray private var categories: [VideoCategory] = []
    @Published private var videoSelected: Bool = false
    lazy var callApi: CallApiProtocol = {
        return CallApi(self)
    }()
    
    private func actLoadVideoCategories() {
        categories = callApi.loadVideoCategories()
    }
    private func actSendPlayListParcel(_ category: VideoCategory) {
        applyExpress(category, recipient: PlayListScenario.self)
        subscribeVideoSelected()
    }
    
    private func subscribeVideoSelected() {
        let traker = Routine(self)
        traker.trackParcels { [weak self] in
            self?.videoSelected = true
            traker.stopTracking()
        }
    }
}
extension VideoAlbumScenario: VideoAlbumDirector {
    var categoriesObserver: ObservableArray<VideoCategory> {
        $categories
    }
    
    var videoSelectedPublisher: Published<Bool>.Publisher {
        $videoSelected
    }
    func loadVideoCategories() {
        act { [weak self] in
            self?.actLoadVideoCategories()
        }
    }
    func sendPlayListParcel(category: VideoCategory) {
        act { [weak self] in
            self?.actSendPlayListParcel(category)
        }
    }
    
}

protocol VideoAlbumDirector {
    var categoriesObserver: ObservableArray<VideoCategory> { get }
    var videoSelectedPublisher: Published<Bool>.Publisher { get }
    func loadVideoCategories()
    func sendPlayListParcel(category: VideoCategory)
}
