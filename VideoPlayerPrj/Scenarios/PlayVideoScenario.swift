//
//  PlayVideoScenario.swift
//  VideoPlayerPrj
//
//  Created by YuCheng on 2024/6/20.
//

import Foundation
import Theatre
import SwiftUI
import AVFoundation

class PlayVideoScenario: Scenario {
    private var playCategory: VideoCategory? = nil
    private var playIndex: Int = -1
    private let thumbnailCache = NSCache<NSNumber, UIImage>()
    @Published private var playVideo: Video? = nil
    @Published private var thumbnail: Image? = nil
    @Published private var videoPlayer: AVPlayer? = nil
    @Published private var isPlayng: Bool = false
    var playerDetector: DetectVideoPlayProtocol?
    private let videoHandler: VideoHandlerProtocol
    private var isEndOfPlaying = false
    
    init(videoHandler: VideoHandlerProtocol = VideoHandler()) {
        self.videoHandler = videoHandler
    }
    
    private func actClaimPlayVideo() {
        let parcels = claimParcels()
        var newIdx: Int = 0
        for parcel in parcels {
            switch parcel {
            case let item as Parcel<VideoCategory>:
                playCategory = item.cargo
            case let item as Parcel<Int>:
                newIdx = item.cargo
            default: break
            }
        }
        guard playIndex != newIdx else {
            return
        }
        playIndex = newIdx
        playVideo = playCategory?.videos[newIdx]
        fetchThumbnail()
    }
    
    private func actOpenPlayList(_ complete: @escaping () -> Void) {
        guard let category: VideoCategory = playCategory else { return }
        applyExpress(category, recipient: PlayListScenario.self)
        let tracker = Routine(self)
        tracker.trackParcels { [weak self] in
            self?.claimPlayVideo()
            tracker.stopTracking()
        }
        DispatchQueue.main.async {
            complete()
        }
    }
    
    private func actChangeVideo(_ direction: PlayListMovingDirection) {
        switch direction {
        case .backward:
            guard playIndex > 0 else { return }
            playIndex -= 1
        case .forward:
            guard
                let category = playCategory,
                playIndex < (category.videos.count - 1)
            else { return }
            playIndex += 1
        }
        if let theVideo: Video = playCategory?.videos[playIndex] {
            playVideo = theVideo
        }
        fetchThumbnail()
    }
    
    private func actPlayClickedAction() {
        CondDo(
            (self.isPlayng == true) => { [weak self] in
                self?.videoPlayer?.pause()
            },
            true => { [weak self] in
                guard let weakSelf = self else { return }
                if weakSelf.isEndOfPlaying {
                    weakSelf.videoPlayer?.seek(to: .zero)
                    weakSelf.isEndOfPlaying = false
                }
                weakSelf.videoPlayer?.play()
            }
        )
    }
    
    private func fetchThumbnail() {
        guard
            let theVideo: Video = playVideo,
            let playUrl: URL = URL(string: theVideo.sources.first ?? " ")
        else { return }
        let isReachable = Teleport(false)
        Task {
            playUrl.isReachable { [weak self] reachable in
                isReachable.portal = reachable
                self?.videoPlayer = AVPlayer(url: playUrl)
                self?.detectVideoPlayerState()
            }
        }
        let cachedThumbnail = thumbnailCache.object(forKey: NSNumber(value: playIndex))
        CondDo(
            (cachedThumbnail != nil) => { [weak self] in
                self?.thumbnail = Image(uiImage: cachedThumbnail!)
            },
            true => { [weak self] in
                guard
                    let weakSelf = self
                else { return }
                Task {
                    guard
                        isReachable.portal,
                        let thumbnailImg: UIImage = weakSelf.videoHandler.generateThumbnail(from: playUrl) else { return }
                    let itemNumber = NSNumber(value: weakSelf.playIndex)
                    weakSelf.thumbnailCache.setObject(thumbnailImg, forKey: itemNumber)
                    weakSelf.thumbnail = Image(uiImage: thumbnailImg)
                }
            }
        )
    }
    
    private func detectVideoPlayerState() {
        guard let newPlayer = videoPlayer else { return }
        isEndOfPlaying = false
        playerDetector?.stopDetecting()
        playerDetector = DetectVideoPlay(self, player: newPlayer)
        playerDetector?.detectingPlayState({ [weak self] in
            self?.isPlayng = $0
        })
        playerDetector?.detectEndOfPlaying { [weak self] in
            self?.isEndOfPlaying = true
        }
    }
}

extension PlayVideoScenario: PlayVideoDirector {
    var playVideoPublisher: Published<Video?>.Publisher {
        $playVideo
    }
    var thumbnailPublisher: Published<Image?>.Publisher {
        $thumbnail
    }
    var palyerPublisher: Published<AVPlayer?>.Publisher {
        $videoPlayer
    }
    var isPlayngPublisher: Published<Bool>.Publisher {
        $isPlayng
    }
    
    func claimPlayVideo() {
        act { [weak self] in
            self?.actClaimPlayVideo()
        }
    }
    func openPlayList(_ complete: @escaping () -> Void) {
        act { [weak self] in
            self?.actOpenPlayList(complete)
        }
    }
    func changeVideo(direction: PlayListMovingDirection) {
        act { [weak self] in
            self?.actChangeVideo(direction)
        }
    }
    func playClickedAction() {
        act { [weak self] in
            self?.actPlayClickedAction()
        }
    }
}

protocol PlayVideoDirector {
    var playVideoPublisher: Published<Video?>.Publisher { get }
    var thumbnailPublisher: Published<Image?>.Publisher { get }
    var palyerPublisher: Published<AVPlayer?>.Publisher { get }
    var isPlayngPublisher: Published<Bool>.Publisher { get }
    func claimPlayVideo()
    func openPlayList(_ complete:@escaping() -> Void)
    func changeVideo(direction: PlayListMovingDirection)
    func playClickedAction()
}
