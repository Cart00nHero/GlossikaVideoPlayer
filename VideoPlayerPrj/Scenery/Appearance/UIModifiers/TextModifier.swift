//
//  TextModifier.swift
//  eMenu
//
//  Created by YuCheng on 2024/2/7.
//

import SwiftUI

// Enumeration to define font sizes
enum FontSizeLevel {
    case xxxSmall, xxSmall, xSmall, small
    case medium
    case large, xLarge, xxLarge, xxxLarge
    case accessibility1, accessibility2
    case accessibility3, accessibility4
    case accessibility5
    case unknown
}

// Extension to provide a CGFloat representation of font sizes
extension FontSizeLevel {
    var size: CGFloat {
        switch self {
        case .xxxSmall: return 12
        case .xxSmall: return 14
        case .xSmall: return 16
        case .small: return 18
        case .medium: return 20
        case .large: return 22
        case .xLarge: return 24
        case .xxLarge: return 26
        case .xxxLarge: return 28
        case .accessibility1: return 30
        case .accessibility2: return 32
        case .accessibility3: return 34
        case .accessibility4: return 36
        case .accessibility5: return 38
        case .unknown: return 20
        }
    }
}

// Define a custom font size modifier
fileprivate struct DynamicFontSizeModifier: ViewModifier {
    @Environment(\.sizeCategory) var sizeCategory
    var baseFontSize: CGFloat
    var fontWeight: Font.Weight = .regular
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: adjustedFontSize(), weight: fontWeight))
            .font(.system(size: adjustedFontSize()))
    }
    
    private func adjustedFontSize() -> CGFloat {
        // increase font size for accessibility larger text sizes
        switch sizeCategory {
        case .accessibilityMedium, .accessibilityLarge, .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge:
            return baseFontSize * 1.5
        default:
            return baseFontSize
        }
    }
}

// Extension to apply the modifier more easily
extension View {
    func autoFontSize(_ sizeLevel: FontSizeLevel, weight: Font.Weight = .regular) -> some View {
        self.modifier(
            DynamicFontSizeModifier(
                baseFontSize: sizeLevel.size,
                fontWeight: weight))
    }
}

fileprivate struct UnderlineTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .padding(.bottom, 1)
                    .foregroundColor(Color.blue) // You can customize the color of the underline
                    .opacity(1.0) // You can adjust the opacity of the underline
                , alignment: .bottom
            )
    }
}
extension Link {
    func underline() -> some View {
        self.modifier(UnderlineTextModifier())
    }
}

enum CustomTextStyle {
    case title, subTitle, content
}
fileprivate struct CustomTextModifier: ViewModifier {
    var textStyle: CustomTextStyle
    func body(content: Content) -> some View {
        switch textStyle {
        case .title:
            content
                .foregroundColor(Painting.title)
                .autoFontSize(.medium, weight: .bold)
        case .subTitle:
            content
                .foregroundColor(Painting.subtile)
                .autoFontSize(.small, weight: .bold)
        case .content:
            content
                .foregroundColor(Painting.detail)
                .autoFontSize(.xSmall)
        }
    }
}
extension Text {
    func customStyle(_ style: CustomTextStyle) -> some View {
        self.modifier(CustomTextModifier(textStyle: style))
    }
}
