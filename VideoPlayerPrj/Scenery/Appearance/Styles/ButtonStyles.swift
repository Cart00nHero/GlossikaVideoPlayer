//
//  ButtonStyles.swift
//  eMenu
//
//  Created by YuCheng on 2024/2/18.
//

import SwiftUI

// Define a custom ButtonStyle
struct PhysicalStyle: ButtonStyle {
    var bgColor: Color = .clear
    var fgColor: Color = .white
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(bgColor)
            .foregroundColor(fgColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            // Apply a shadow conditionally based on whether the button is pressed or not
            .shadow(
                color: configuration.isPressed ? .livingCoral : .gray,
                radius: configuration.isPressed ? 1 : 5,
                x: 0, y: configuration.isPressed ? 1 : 5)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0) // Slightly scale down when pressed
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
