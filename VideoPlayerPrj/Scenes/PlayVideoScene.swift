//
//  PlayVideoScene.swift
//  VideoPlayerPrj
//
//  Created by YuCheng on 2024/6/20.
//

import SwiftUI
import AVFoundation

struct PlayVideoScene: View {
    private let director: PlayVideoDirector = PlayVideoScenario()
    @State private var titleText: String = "Loading..."
    @State private var videoPlayer: AVPlayer = AVPlayer()
    @State private var playVideo: Video? = nil
    @State private var thumbnail: Image = Gallery.movie.picture
    @State private var showPlayButton = false
    @State private var showVideoPlayer = false
    @State private var activePlayList: Bool = false
    @StateObject private var videoCtrlScript = FloatingVideoCtrlScript()
    
    var body: some View {
        GeometryReader { mProxy in
            ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                VStack {
                    Text(playVideo?.title ?? "")
                        .customStyle(.title)
                        .lineLimit(nil)
                        .truncationMode(.tail)
                        .padding()
                    displayVideoPlayer()
                    ScrollView(.vertical) {
                        LazyVStack(spacing: 8.0) {
                            Group {
                                Text(playVideo?.subtitle ?? "")
                                    .customStyle(.subTitle)
                                    .multilineTextAlignment(.center)
                                Text(playVideo?.description_p ?? "")
                                    .customStyle(.content)
                                    .multilineTextAlignment(.leading)
                            }
                            .lineLimit(nil)
                            .truncationMode(.tail)
                            .padding()
                        }
                    }
                }
                .navigationBarHidden(false)
                .navigationTitle(titleText)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            videoPlayer.pause()
                            director.openPlayList {
                                activePlayList = true
                            }
                        }) {
                            SystemImage.playList.picture
                        }
                    }
                }
                FloatingVideoCtrl(script: videoCtrlScript)
                    .position(getFloatingPosition(size: mProxy.size))
                    .isHidden(!showPlayButton)
                    .onAppear {
                        videoCtrlScript.changeButtonClicked = {
                            videoPlayer.pause()
                            director.changeVideo(direction: $0)
                        }
                        videoCtrlScript.playButtonClicked = {
                            director.playClickedAction()
                        }
                    }
            }
        }
        .onAppear {
            initialize()
        }
        .sheet(isPresented: $activePlayList, content: {
            AppSceneId.playList(actived: $activePlayList).scene
        })
    }
    
    private func initialize() {
        guard playVideo == nil else {
            return
        }
        subscribeActions()
        director.claimPlayVideo()
    }
    private func subscribeActions() {
        _ = director.playVideoPublisher
            .subscribe(on: DispatchQueue.main)
            .sink(receiveValue: {
                setPrepareUI()
                guard
                    let newValue: Video = $0,
                    newValue.title != playVideo?.title
                else { return }
                titleText = newValue.title
                playVideo = newValue
            })
        
        _ = director.thumbnailPublisher.subscribe(on: DispatchQueue.main).sink(receiveValue: {
            guard let newValue: Image = $0 else { return }
            thumbnail = newValue
            showPlayButton = true
        })
        
        _ = director.palyerPublisher.subscribe(on: DispatchQueue.main).sink(receiveValue: {
            guard let newValue: AVPlayer = $0 else { return }
            videoPlayer = newValue
        })
        _ = director.isPlayngPublisher.subscribe(on: DispatchQueue.main).sink(receiveValue: { state in
            DispatchQueue.main.async {
                if state {
                    videoCtrlScript.playState = .playing
                    guard !showVideoPlayer else {
                        return
                    }
                    showVideoPlayer = true
                } else {
                    videoCtrlScript.playState = .pause
                }
            }
        })
    }
    
    private func setPrepareUI() {
        thumbnail = Gallery.movie.picture
        showPlayButton = false
        showVideoPlayer = false
    }
    
    private func getFloatingPosition(size: CGSize) -> CGPoint {
        switch videoCtrlScript.mode {
        case .riseUp:
            videoCtrlScript.getFloatPosition(size)
        case .collapse:
            videoCtrlScript.getCollapsePosition(size)
        }
    }
    
    private func displayVideoPlayer() -> AnyView {
        if !showVideoPlayer {
            AnyView(
                HStack(spacing: 8.0) {
                    Spacer()
                    PhotoBackground(photo: thumbnail, alignment: .center, opacity: 0.3) {
                        Button {
                            videoPlayer.play()
                            showVideoPlayer = true
                        } label: {
                            let imgSize = autoSize(44).width
                            SystemImage.playFill.picture
                                .resizable()
                                .frame(width: imgSize, height: imgSize)
                                .foregroundColor(.livingCoral)
                        }
                        .buttonStyle(PhysicalStyle())
                        .isHidden(!showPlayButton)
                    }
                    .frame(height: autoSize(300.0).width)
                    .cornerRadius(edgeCorner)
                    Spacer()
                })
        } else {
            AnyView(
                VideoPlayerView(player: $videoPlayer, onEnterFullscreen: {
                    print("Enter")
                    AppDelegate.orientationLock = .all
                }, onExitFullscreen: {
                    print("Exit")
                    AppDelegate.orientationLock = .portrait
                })
                .frame(height: autoSize(320.0).width)
                .cornerRadius(edgeCorner)
                .padding()
                .isHidden(!showVideoPlayer, remove: true))
        }
    }
}

#Preview {
    PlayVideoScene()
}
