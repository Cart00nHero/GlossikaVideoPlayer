//
//  VideoHandler.swift
//  VideoPlayerPrj
//
//  Created by YuCheng on 2024/6/21.
//

import Foundation
import Theatre
import AVFoundation
import SwiftUI

final class VideoHandler: Actor {
    func actGenerateThumbnail(from url: URL, port: Teleport<UIImage?>) {
        let asset = AVAsset(url: url)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true

        // Set the time to get the thumbnail (e.g., at the 2-second mark)
        let time = CMTime(seconds: 2.0, preferredTimescale: 600)
        let times = [NSValue(time: time)]
        
        assetImgGenerate.generateCGImagesAsynchronously(forTimes: times) { _, image, _, _, error in
            if let cgImage = image {
                let thumbnail = UIImage(cgImage: cgImage)
                port.portal = thumbnail
            } else {
                print("Error generating thumbnail: \(error?.localizedDescription ?? "unknown error")")
                port.portal = nil
            }
        }
    }
    
}
extension VideoHandler: VideoHandlerProtocol {
    func generateThumbnail(from url: URL) -> UIImage? {
        let tel: Teleport<UIImage?> = Teleport(nil)
        act { [weak self] in
            self?.actGenerateThumbnail(from: url, port: tel)
        }
        return tel.portal
    }
}

protocol VideoHandlerProtocol {
    func generateThumbnail(from url: URL) -> UIImage?
}
