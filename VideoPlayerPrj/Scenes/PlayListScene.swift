//
//  PlayListScene.swift
//  VideoPlayerPrj
//
//  Created by YuCheng on 2024/6/20.
//

import SwiftUI
import Theatre

struct PlayListScene: View {
    @Binding var actived: Bool
    private let director: PlayListDirector = PlayListScenario()
    private let gridColumns: [GridItem] = Array(
        repeating: GridItem(.flexible()), count: 3)
    @State private var playList: [Video] = []
    @State private var previewImgs: [Int: String] = [:]
    
    var body: some View {
        let headline: String = AppSceneId.playList(actived: $actived).headline
        Billboard(headline: .constant(headline)) { _, mSize in
            ZStack {
                List {
                    ForEach(0..<playList.count, id: \.self) { idx in
                        let video: Video = playList[idx]
                        PhotoBackground(photo: Gallery.videoThumbnail.picture) {
                            HStack(spacing: 8.0) {
                                Spacer()
                                Button {
                                    director.selectVideo(at: idx)
                                    actived.toggle()
                                } label: {
                                    VStack(alignment: .leading, spacing: 0.0) {
                                        Group {
                                            Text(video.title)
                                                .customStyle(.title)
                                                .lineLimit(1)
                                            Text(video.subtitle)
                                                .customStyle(.subTitle)
                                                .lineLimit(2)
                                            Text(video.description_p)
                                                .customStyle(.content)
                                                .lineLimit(3)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                                Spacer()
                            }
                        }
                        .frame(height: autoSize(100.0).height)
                    }
                }
                .listStyle(PlainListStyle())
                .edgesIgnoringSafeArea(.all)
                .background(Color.clear)
            }
        }
        .background(Painting.background)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    actived = false
                }) {
                    SystemImage.circleXmark.picture
                }
            }
        }
        .onAppear {
            subscribeActions()
            director.claimPlayList()
        }
    }
    
    @MainActor
    private func subscribeActions() {
        director.playListsObserver.addObserver { newArray, _ in
            playList = newArray
        }
    }
}

#Preview {
    PlayListScene(actived: .constant(false))
}
