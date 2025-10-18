//
//  VideoStreamingView.swift
//  CarInfo
//
//  Created by window1 on 10/17/25.
//

import SwiftUI
import AVKit

struct VideoStreamingView: View {
    
    @State private var videoVM = VideoPlayerViewModel()
    @Environment(UserManager.self) var userManager
    
    var body: some View {
        VStack {
            if videoVM.isLoading {
                ProgressView()
                    .frame(width: 100)
            }else if let url = videoVM.videoURL {
                VideoPlayer(player: AVPlayer(url: url))
                    .frame(width: 400, height: 250)
                    .onAppear {
                        AVPlayer(url: url).play()
                    }
            } else {
                Rectangle()
                    .foregroundStyle(.gray)
                    .frame(width: 400, height: 250)
                    .overlay(content: {
                        Text("비디오URL을 가져오지 못했습니다.")
                    })
            }
        }
        .onAppear {
            videoVM.loadVideoURL()
        }
    }
}

#Preview {
    VideoStreamingView()
        .environment(UserManager())
}
