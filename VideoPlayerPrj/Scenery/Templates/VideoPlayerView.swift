//
//  VideoPlayerView.swift
//  VideoPlayerPrj
//
//  Created by YuCheng on 2024/6/20.
//

import SwiftUI
import AVKit

struct VideoPlayerView: UIViewControllerRepresentable {
    @Binding var player: AVPlayer
    var onEnterFullscreen: (() -> Void)?
    var onExitFullscreen: (() -> Void)?
    
    class Coordinator: NSObject, AVPlayerViewControllerDelegate {
        var parent: VideoPlayerView
        
        init(parent: VideoPlayerView) {
            self.parent = parent
        }
        
        func playerViewController(_ playerViewController: AVPlayerViewController, willTransitionToFullscreen fullscreen: Bool) {
            if fullscreen {
                parent.onEnterFullscreen?()
            } else {
                parent.onExitFullscreen?()
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.delegate = context.coordinator
        return playerViewController
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        uiViewController.player = player
    }
}
