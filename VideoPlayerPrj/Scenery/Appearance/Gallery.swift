//
//  Gallery.swift
//  VideoPlayerPrj
//
//  Created by YuCheng on 2024/6/21.
//

import Foundation
import SwiftUI

enum Gallery: String {
    case opening = "image_opening"
    case movie = "icon_movie"
    case videoThumbnail = "image_video_thumbnail"
}
extension Gallery {
    var picture: Image {
        Image(self.rawValue)
    }
}

enum SystemImage: String {
    case playFill = "play.fill"
    case play = "play"
    case pause = "pause"
    case playList = "list.bullet.rectangle.portrait"
    case triangleArrowUpFill = "arrowtriangle.up.fill"
    case triangleArrowDown = "arrowtriangle.down"
    case forwardEnd = "forward.end"
    case backwardEnd = "backward.end"
    case circleXmark = "xmark.circle"
}
extension SystemImage {
    var picture: Image {
        Image(systemName: self.rawValue)
    }
}
