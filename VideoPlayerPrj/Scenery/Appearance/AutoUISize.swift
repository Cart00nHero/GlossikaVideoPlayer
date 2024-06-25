//
//  AutoUISize.swift
//  PrivateKitchen
//
//  Created by 林祐正 on 2021/9/14.
//

import Foundation
import SwiftUI

func autoSize(_ value: CGFloat) -> CGSize {
    let bounds = UIScreen.main.bounds
    let widthMultiplier: CGFloat
    let heightMultiplier: CGFloat
    
    switch UIDevice.current.userInterfaceIdiom {
    case .phone:
        widthMultiplier = bounds.width / (UIDevice.current.orientation.isLandscape ? 667.0 : 375.0)
        heightMultiplier = bounds.height / (UIDevice.current.orientation.isLandscape ? 375.0 : 667.0)
    default:
        widthMultiplier = bounds.width / (UIDevice.current.orientation.isLandscape ? 1024.0 : 768.0)
        heightMultiplier = bounds.height / (UIDevice.current.orientation.isLandscape ? 768.0 : 1024.0)
    }
    return CGSize(width: value * widthMultiplier, height: value * heightMultiplier)
}

func statusBarHeight() -> CGFloat {
    var statusBarHeight: CGFloat = 0
    if #available(iOS 13.0, *) {
        let window = UIApplication.shared.connectedScenes
        // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
        // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
        // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
        // Finally, keep only the key window
            .first(where: \.isKeyWindow)
        statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    } else {
        statusBarHeight = UIApplication.shared.statusBarFrame.height
    }
    return statusBarHeight
}

/*
func autoWUISize(_ value: CGFloat) -> CGFloat {
    return value * WKInterfaceDevice.current().screenBounds.size.width/162.0
}
func autoWFont(value: CGFloat) -> CGFloat {
    if WKInterfaceDevice.current().screenBounds.size.width < 162.0 {
        return (value - 2.0)
    }
    if WKInterfaceDevice.current().screenBounds.size.width > 162.0 {
        return (value + 2.0)
    }
    return value
}
*/
