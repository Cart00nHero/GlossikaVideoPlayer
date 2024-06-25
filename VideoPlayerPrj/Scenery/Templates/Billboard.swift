//
//  Billboard.swift
//  eMenu
//
//  Created by YuCheng on 2024/2/29.
//

import SwiftUI

struct Billboard<Content: View>: View {
    @Binding var headline: String
    let alignment: HorizontalAlignment
    public var content: (GeometryProxy, CGSize) -> Content
    
    init(
        headline: Binding<String>,
        alignment: HorizontalAlignment = .center,
        @ViewBuilder content: @escaping (GeometryProxy, CGSize) -> Content
    ) {
        self._headline = headline
        self.alignment = alignment
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: alignment, spacing: 0) {
                ZStack(alignment: .center) {
                    Text(headline)
                        .font(.title2.bold())
                        .lineLimit(1)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(Painting.headline)
                }
                .edgesIgnoringSafeArea(.all)
                .frame(width: geometry.size.width, height: barHeight)
                .background(Painting.theme)
                let contentSize = CGSize(
                    width: geometry.size.width,
                    height: geometry.size.height - barHeight)
                content(geometry, contentSize)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

#Preview {
    Billboard(headline: .constant(""), content: {_,_  in })
}
