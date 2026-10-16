//
//  YouTubePlayerViewController.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 14.10.2026.
//

import UIKit
import SwiftUI
import YouTubePlayerKit

class YouTubePlayerViewController: UIHostingController<YouTubePlayerContainerView> {
    
    init(videoID: String) {
        let player = YouTubePlayer(
            source: .video(id: videoID),
            parameters: .init(
                autoPlay: true,
                showControls: true
            )
        )
        
        var containerView: YouTubePlayerContainerView!
        
        super.init(rootView: YouTubePlayerContainerView(player: player, onClose: {}))
        
        containerView = YouTubePlayerContainerView(player: player) { [weak self] in
            self?.dismiss(animated: true)
        }
        self.rootView = containerView
        
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct YouTubePlayerContainerView: View {
    let player: YouTubePlayer
    var onClose: () -> Void

    @State private var isCloseButtonVisible: Bool = true
    @State private var hideWorkItem: DispatchWorkItem?

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.black.ignoresSafeArea()
            
            // 1. YouTube Player View
            YouTubePlayerView(player)
                .ignoresSafeArea()
            
            // 2. Invisible full-screen tap detector overlay to catch taps and toggle UI
            Color.clear
                .contentShape(Rectangle())
                .ignoresSafeArea()
                .onTapGesture {
                    toggleControls()
                }
            
            // 3. Toggleable Close Button
            if isCloseButtonVisible {
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.black.opacity(0.6))
                        .clipShape(Circle())
                }
                .padding(.top, 50)
                .padding(.leading, 20)
                .transition(.opacity.animation(.easeInOut(duration: 0.2)))
                .zIndex(1) // Ensure it sits above the tap layer
            }
        }
        .onAppear {
            scheduleAutoHide()
        }
    }

    private func toggleControls() {
        withAnimation(.easeInOut(duration: 0.2)) {
            isCloseButtonVisible.toggle()
        }
        if isCloseButtonVisible {
            scheduleAutoHide()
        } else {
            hideWorkItem?.cancel()
        }
    }

    private func scheduleAutoHide() {
        hideWorkItem?.cancel()
        let item = DispatchWorkItem {
            withAnimation(.easeInOut(duration: 0.2)) {
                self.isCloseButtonVisible = false
            }
        }
        hideWorkItem = item
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: item)
    }
}
