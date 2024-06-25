//
//  ListModifiers.swift
//  eMenu
//
//  Created by YuCheng on 2024/2/14.
//

import SwiftUI

// A custom shape for rounding specific corners
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct OvalConfig {
    let bgColor: Color
    let index: Int
    let totalCount: Int
}
struct OvalCellModifier: ViewModifier {
    var config: OvalConfig
    
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading) // Stretch the cell to full width
            .background(config.bgColor)
            .clipShape(
                RoundedCorner(
                    radius: 10,
                    corners: roundedCorners(
                        for: config.index,
                        config.totalCount)))
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
    }
}

extension View {
    func ovalCell(config: OvalConfig) -> some View {
        self.modifier(OvalCellModifier(config: config))
    }
}

// Determine which corners should be rounded for the given item index
fileprivate func roundedCorners(for index: Int, _ total: Int) -> UIRectCorner {
    switch index {
    case 0:
        return [.topLeft, .topRight]
    case total - 1:
        return [.bottomLeft, .bottomRight]
    default:
        return []
    }
}
