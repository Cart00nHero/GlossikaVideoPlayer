//
//  PlayListScenario.swift
//  VideoPlayerPrj
//
//  Created by YuCheng on 2024/6/20.
//

import Foundation
import Theatre

class PlayListScenario: Scenario {
    private var currentCategory: VideoCategory? = nil
    private var senderName: String = ""
    @ObservableArray private var playList: [Video] = []
    
    private func actClaimPlayList() {
        let parcels = claimParcels()
        for parcel in parcels {
            switch parcel {
            case let item as Parcel<VideoCategory>:
                senderName = item.sender
                currentCategory = item.cargo
                playList = currentCategory?.videos ?? []
            default: break
            }
        }
    }
    
    private func actSelectVideo(at index: Int) {
        guard let category: VideoCategory = currentCategory else { return }
        applyExpress(category, recipient: PlayVideoScenario.self)
        applyExpress(index, recipient: PlayVideoScenario.self)
        notifySubscriber()
    }
    
    private func notifySubscriber() {
        let traker = Routine(self)
        CondDo(
            (self.senderName == String(describing: VideoAlbumScenario.self)) => {
                traker.notifyRecipient(VideoAlbumScenario.self)
            },
            (self.senderName == String(describing: PlayVideoScenario.self)) => {
                traker.notifyRecipient(PlayVideoScenario.self)
            }
        )
    }
}
extension PlayListScenario: PlayListDirector {
    var playListsObserver: Theatre.ObservableArray<Video> {
        $playList
    }
    
    func claimPlayList() {
        act { [weak self] in
            self?.actClaimPlayList()
        }
    }
    
    func selectVideo(at index: Int) {
        act { [weak self] in
            self?.actSelectVideo(at: index)
        }
    }
    
}

protocol PlayListDirector {
    var playListsObserver: ObservableArray<Video> { get }
    func claimPlayList()
    func selectVideo(at index: Int)
}
