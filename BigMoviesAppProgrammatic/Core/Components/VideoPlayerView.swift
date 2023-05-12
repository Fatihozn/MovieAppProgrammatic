//
//  VideoPlayerView.swift
//  BigMoviesAppProgrammatic
//
//  Created by Fatih Özen on 26.04.2023.
//
import UIKit
import AVKit
import YouTubeiOSPlayerHelper

class VideoPlayerView: YTPlayerView {

    private let url: String
    
    init(frame: CGRect, videoUrl: String) {
        self.url = videoUrl
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupVideoPlayer()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupVideoPlayer() {
            load(withVideoId: url)
        
    }
    
}
