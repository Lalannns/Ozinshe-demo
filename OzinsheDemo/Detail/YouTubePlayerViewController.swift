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
                showControls: true // Fixed parameter name
            )
        )
        super.init(rootView: YouTubePlayerContainerView(player: player))
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct YouTubePlayerContainerView: View {
    let player: YouTubePlayer

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            YouTubePlayerView(player)
                .ignoresSafeArea()
        }
    }
}
