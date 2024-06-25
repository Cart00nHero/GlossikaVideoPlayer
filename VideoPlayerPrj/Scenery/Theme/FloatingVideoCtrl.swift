//
//  FloatingVideoCtrl.swift
//  VideoPlayerPrj
//
//  Created by YuCheng on 2024/6/22.
//

import SwiftUI

struct FloatingVideoCtrl: View {
    @ObservedObject var script: FloatingVideoCtrlScript
    @State private var heightValue: CGFloat = 0
    private let riseHeight = autoSize(80.0).height
    private let collapseHeight = autoSize(30.0).height
    
    var body: some View {
        ZStack {
            switch script.mode {
            case .riseUp:
                HStack(spacing: 8.0) {
                    Spacer()
                    flyModeUI()
                        .cornerRadius(edgeCorner)
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                        .scaleEffect(1.05)
                    Spacer()
                }
            case .collapse:
                collapseModeUI()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: heightValue)
        .onAppear {
            switch script.mode {
            case .riseUp:
                heightValue = riseHeight
            case .collapse:
                heightValue = collapseHeight
            }
        }
    }
    
    private func flyModeUI() -> AnyView {
        AnyView(
            VStack(spacing: 2.0) {
                let btnHeight = autoSize(20.0).width
                Button {
                    script.mode = .collapse
                    heightValue = collapseHeight
                } label: {
                    HStack {
                        Spacer()
                        SystemImage.triangleArrowDown.picture
                            .resizable()
                            .frame(width: autoSize(30.0).width, height: btnHeight)
                            .foregroundColor(Painting.theme)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .contentShape(Rectangle())
                .frame(maxWidth: .infinity, maxHeight: btnHeight)
                .background(Painting.headline)
                Spacer()
                HStack(spacing: 64.0) {
                    Button {
                        script.changeButtonClicked?(.backward)
                    } label: {
                        SystemImage.backwardEnd.picture
                            .resizable()
                            .frame(width: btnHeight, height: btnHeight)
                            .contentShape(Rectangle())
                    }
                    Button {
                        script.playButtonClicked?()
                    } label: {
                        script.playState.playIcon
                            .resizable()
                            .scaledToFit()
                            .frame(width: btnHeight, height: btnHeight)
                            .contentShape(Rectangle())
                    }
                    Button {
                        script.changeButtonClicked?(.forward)
                    } label: {
                        SystemImage.forwardEnd.picture
                            .resizable()
                            .scaledToFit()
                            .frame(width: btnHeight, height: btnHeight)
                            .contentShape(Rectangle())
                    }
                }
                Spacer()
            }
                .background(Painting.theme)
        )
    }
    
    private func collapseModeUI() -> AnyView {
        AnyView(
            Button {
                script.mode = .riseUp
                heightValue =  riseHeight
            } label: {
                HStack {
                    Spacer()
                    SystemImage.triangleArrowUpFill.picture
                        .resizable()
                        .frame(width: autoSize(30.0).width, height: autoSize(20.0).width)
                        .foregroundColor(Painting.theme)
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.clear)
                .contentShape(Rectangle())
            }
        )
    }
}

#Preview {
    FloatingVideoCtrl(script: FloatingVideoCtrlScript())
}

final class FloatingVideoCtrlScript: ObservableObject {
    @Published var mode: FloatingMode = .collapse
    @Published var playState: PlayerPlaystate = .pause
    var changeButtonClicked: ((PlayListMovingDirection) -> Void)?
    var playButtonClicked: (() -> Void)?
    
    func getFloatPosition(_ geoSize: CGSize) -> CGPoint {
        CGPoint(
            x: geoSize.width / 2.0,
            y: geoSize.height - autoSize(120.0).height)
    }
    
    func getCollapsePosition(_ geoSize: CGSize) -> CGPoint {
        CGPoint(
            x: geoSize.width / 2.0,
            y: geoSize.height - autoSize(10.0).width)
    }
    
}

enum FloatingMode: Int {
    case riseUp
    case collapse
}

enum PlayListMovingDirection: Int {
    case backward, forward
}

enum PlayerPlaystate {
    case pause, playing
}
extension PlayerPlaystate {
    var playIcon: Image {
        switch self {
        case .pause:
            return SystemImage.play.picture
        case .playing:
            return SystemImage.pause.picture
        }
    }
}
