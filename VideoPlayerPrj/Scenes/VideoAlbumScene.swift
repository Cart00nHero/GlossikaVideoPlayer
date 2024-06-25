//
//  VideoCategoriesScene.swift
//  VideoPlayerPrj
//
//  Created by YuCheng on 2024/6/21.
//

import SwiftUI

struct VideoAlbumScene: View {
    private let director: VideoAlbumDirector = VideoAlbumScenario()
    @State private var categories: [VideoCategory] = []
    @State private var activePlayList: Bool = false
    @State private var activePlayVideo: Bool = false
    
    var body: some View {
        ZStack {
            NavigationLink(
                destination: AppSceneId.playVideo.scene,
                isActive: $activePlayVideo) {}.hidden()
            Billboard(headline: .constant(AppSceneId.videoAlbum.headline)) { _, _ in
                PhotoBackground(photo: Gallery.opening.picture) {
                    let gridColumns = Array(
                        repeating: GridItem(.flexible()),
                        count: categories.count == 1 ? 1 : 2)
                    ScrollView(.vertical) {
                        LazyVGrid(columns: gridColumns, alignment: .center, spacing: 8.0) {
                            ForEach(0..<categories.count, id: \.self) { idx in
                                let category: VideoCategory = categories[idx]
                                VStack {
                                    let minSize = autoSize(160.0).width
                                    Button {
                                        director.sendPlayListParcel(category: category)
                                        activePlayList.toggle()
                                    } label: {
                                        Gallery.videoThumbnail.picture
                                            .resizable()
                                            .frame(maxWidth: minSize, maxHeight: minSize)
                                            .cornerRadius(edgeCorner)
                                    }
                                    .buttonStyle(PhysicalStyle())
                                    Text(category.name)
                                        .customStyle(.title)
                                        .lineLimit(1)
                                }
                            }
                        }
                    }
                }
            }
        }
        .background(Painting.background)
        .navigationBarHidden(true)
        .onAppear {
            subscribeActions()
            director.loadVideoCategories()
        }
        .sheet(isPresented: $activePlayList, content: {
            AppSceneId.playList(actived: $activePlayList).scene
        })
    }
    
    private func subscribeActions() {
        director.categoriesObserver.addObserver { newArray, idx in
            categories = newArray
        }
        _ = director.videoSelectedPublisher
            .subscribe(on: DispatchQueue.main)
            .sink(receiveValue: {
                activePlayVideo = $0
            })
    }
}

#Preview {
    VideoAlbumScene()
}
