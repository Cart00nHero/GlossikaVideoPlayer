//
//  ImageBackground.swift
//  eMenu
//
//  Created by YuCheng on 2024/2/22.
//

import SwiftUI

struct PhotoBackground<Content: View>: View {
    let photo: Image
    let alignment: Alignment
    let opacity: CGFloat
    let content: Content
    
    init(
        photo: Image,
        alignment: Alignment = Alignment(horizontal: .center, vertical: .top),
        opacity: CGFloat = 0.8,
        @ViewBuilder content: () -> Content
    ) {
        self.photo = photo
        self.alignment = alignment
        self.opacity = opacity
        self.content = content()
    }
    var body: some View {
        ZStack(alignment: alignment) {
            photo
                .resizable()
                .frame(maxWidth: .infinity)
                .overlay(Color.white.opacity(opacity))
                .edgesIgnoringSafeArea(.all)
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    PhotoBackground(photo: Image(""), content: {})
}
