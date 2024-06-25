//
//  Router.swift
//  VideoPlayerPrj
//
//  Created by YuCheng on 2024/6/21.
//

import SwiftUI

enum AppSceneId: Identifiable {
    case videoAlbum
    case playList(actived: Binding<Bool>)
    case playVideo
    
    var id: Int {
        switch self {
        case .videoAlbum:
            return 0
        case .playList:
            return 1
        case .playVideo:
            return 2
        }
    }
}

extension AppSceneId {
    var scene: AnyView {
        switch self {
        case .videoAlbum:
            return AnyView(VideoAlbumScene())
        case .playList(actived: let actived):
            return AnyView(PlayListScene(actived: actived))
        case .playVideo:
            return AnyView(PlayVideoScene())
        }
    }
    
    var headline: String {
        switch self {
        case .videoAlbum:
            return "Album"
        case .playList:
            return "Play list"
        case .playVideo:
            return "Play"
        }
    }
}
