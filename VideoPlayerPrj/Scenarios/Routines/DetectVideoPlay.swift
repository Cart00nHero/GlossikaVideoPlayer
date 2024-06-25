//
//  DetectVideoPlayerPlay.swift
//  VideoPlayerPrj
//
//  Created by YuCheng on 2024/6/23.
//

import Foundation
import Theatre
import AVFoundation
import Combine
import SwiftUI

class DetectVideoPlay: Routine {
    private let player: AVPlayer
    private var cancellable: AnyCancellable?
    private var detector:((Bool) -> Void)?
    private var playerItemObserver: Any?
    
    init(_ attach: Scenario, player: AVPlayer) {
        self.player = player
        super.init(attach)
    }
    
    private func actDetectingPlayState(_ received: @escaping(Bool) -> Void) {
        detector = received
        cancellable = player.publisher(for: \.rate)
            .sink { [weak self] newRate in
                guard let self = self else { return }
                if newRate > 0 {
                    notifyTracker(true)
                } else {
                    notifyTracker(false)
                }
            }
    }
    
    private func actDetectEndOfPlaying(_ complete:@escaping() -> Void) {
        playerItemObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { [weak self] _ in
            self?.attach.act {
                complete()
            }
        }
    }
    
    private func notifyTracker(_ result: Bool) {
        attach.act { [weak self] in
            self?.detector?(result)
        }
    }
    
    private func actStopDetecting() {
        detector = nil
    }
}
extension DetectVideoPlay: DetectVideoPlayProtocol {
    func detectingPlayState(_ received: @escaping(Bool) -> Void) {
        act { [weak self] in
            self?.actDetectingPlayState(received)
        }
    }
    
    func detectEndOfPlaying(_ complete:@escaping() -> Void) {
        act { [weak self] in
            self?.actDetectEndOfPlaying(complete)
        }
    }
    
    
    func stopDetecting() {
        act { [weak self] in
            self?.actStopDetecting()
        }
    }
}

protocol DetectVideoPlayProtocol {
    func detectingPlayState(_ received: @escaping(Bool) -> Void)
    func detectEndOfPlaying(_ complete:@escaping() -> Void)
    func stopDetecting()
}
