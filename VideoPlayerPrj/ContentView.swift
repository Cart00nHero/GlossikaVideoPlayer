//
//  ContentView.swift
//  VideoPlayerPrj
//
//  Created by YuCheng on 2024/6/20.
//

import SwiftUI

struct ContentView: View {
    @State private var activeApp = false
    var body: some View {
        NavigationView(content: {
            ZStack {
                NavigationLink(
                    destination: AppSceneId.videoAlbum.scene,
                    isActive: $activeApp) {}.hidden()
                Gallery.opening.picture
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            }
        })
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarColor(backgroundColor: Painting.theme, tintColor: Painting.headline)
        .tint(Painting.headline)
        .onAppear {
            openApp()
        }
    }
    
    private func openApp() {
        Task {
            sleep(3)
            activeApp = true
        }
    }
}

#Preview {
    ContentView()
}
