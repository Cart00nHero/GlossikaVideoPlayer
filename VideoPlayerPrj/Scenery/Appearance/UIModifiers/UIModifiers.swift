//
//  UIModifiers.swift
//  PrivateKitchen
//
//  Created by 林祐正 on 2021/9/27.
//

import SwiftUI
import Combine

// Our custom view modifier to track rotation and
// call our action
struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(
                NotificationCenter.default.publisher(
                    for: UIDevice.orientationDidChangeNotification
                )
            ) { _ in
                action(UIDevice.current.orientation)
            }
    }
}
extension View {
    /// Hide or show the view based on a boolean value.
    ///
    /// Example for visibility:
    ///
    ///     Text("Label")
    ///         .isHidden(true)
    ///
    /// Example for complete removal:
    ///
    ///     Text("Label")
    ///         .isHidden(true, remove: true)
    ///
    /// - Parameters:
    ///   - hidden: Set to `false` to show the view. Set to `true` to hide the view.
    ///   - remove: Boolean value indicating whether or not to remove the view.
    @ViewBuilder func isHidden(
        _ hidden: Bool, remove: Bool = false
    ) -> some View {
        if hidden {
            switch remove {
            case true:
                EmptyView()
            default:
                self.hidden()
            }
        } else {
            self
        }
    }
}
// A View wrapper to make the modifier easier to use
extension View {
    func onRotate(
        perform action: @escaping (UIDeviceOrientation) -> Void
    ) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}

struct NavigationBarColor: ViewModifier {
    init(backgroundColor: Color, tintColor: Color) {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = UIColor(backgroundColor)
        coloredAppearance.titleTextAttributes =
        [.foregroundColor: UIColor(tintColor)]
        coloredAppearance.largeTitleTextAttributes =
        [.foregroundColor: UIColor(tintColor)]
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = UIColor(tintColor)
    }
    
    func body(content: Content) -> some View {
        content
    }
}
extension View {
    func navigationBarColor(
        backgroundColor: Color, tintColor: Color
    ) -> some View {
        self.modifier(
            NavigationBarColor(
                backgroundColor: backgroundColor,
                tintColor: tintColor
            )
        )
    }
}
extension TextField {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
struct ClearButtonModifier: ViewModifier {
    @Binding var text: String

    func body(content: Content) -> some View {
        HStack {
            content
            if !text.isEmpty {
                Button {
                    self.text = ""
                } label: {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(Color(UIColor.opaqueSeparator))
                }
                .padding(.trailing, 8)
            }
        }
    }
}
extension View {
    func clearButton(text: Binding<String>) -> some View {
        self.modifier(ClearButtonModifier(text: text))
    }
}

//struct StereoscopicCircle: ViewModifier {
//    func body(content: Content) -> some View {
//        content.clipShape(Circle()).shadow(
//            color: .lovelyLavender,
//            radius: 2.0, x: 0.0, y: 2.0
//        )
//    }
//}

struct PlaceholderModifier: ViewModifier {
    var text: String
    var color: UIColor
    
    func body(content: Content) -> some View {
        content
            .overlay(
                TextField(text, text: .constant(""))
                    .foregroundColor(Color(color))
                    .opacity(0) // 隱藏原始文本框但保留占位符
                    .padding(.leading, -7) // 如有必要，調整內距
            )
    }
}

// 擴展方便應用修改器
extension TextField {
    func placeholder(_ text: String, color: UIColor) -> some View {
        self.modifier(PlaceholderModifier(text: text, color: color))
    }
}


// 應用於你的ScrollView的Modifier
struct KeyboardResponsive: ViewModifier {
    private var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
        Publishers.Merge(
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
                .map { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero }
                .map { $0.height },
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in CGFloat(0) }
        )
        .eraseToAnyPublisher()
    }
    @State private var keyboardHeight: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardHeight) // Add padding equal to keyboard height
            .onReceive(keyboardHeightPublisher) { height in
                withAnimation {
                    self.keyboardHeight = height
                }
            }
    }
}

extension ScrollView {
    func keyboardResponsive() -> some View {
        self.modifier(KeyboardResponsive())
    }
}

// Define a custom view modifier for adding a clear button to a TextEditor
struct TextEditorClearButton: ViewModifier {
    @Binding var text: String

    func body(content: Content) -> some View {
        content
            .overlay(
                HStack {
                    Spacer()
                    if !text.isEmpty {
                        Button(action: {
                            self.text = ""
                        }) {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 8)
                    }
                }
                .padding(.top, 8),
                alignment: .topTrailing
            )
    }
}

// Extension to View to make the modifier easier to apply
extension TextEditor {
    func textEditorClearButton(text: Binding<String>) -> some View {
        self.modifier(TextEditorClearButton(text: text))
    }
}


// Custom View Modifier
struct TransparentTabBarModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onAppear {
                let appearance = UITabBarAppearance()
                appearance.configureWithTransparentBackground()

                // For iOS versions supporting appearance customization
                if #available(iOS 15.0, *) {
                    UITabBar.appearance().scrollEdgeAppearance = appearance
                }

                UITabBar.appearance().standardAppearance = appearance
            }
    }
}

// Extension to easily apply the modifier
extension View {
    func transparentTabBar() -> some View {
        self.modifier(TransparentTabBarModifier())
    }
}
