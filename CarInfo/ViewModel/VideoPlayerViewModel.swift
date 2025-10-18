//
//  VideoPlayerViewModel.swift
//  CarInfo
//
//  Created by window1 on 10/17/25.
//

import Foundation
import AVKit

@Observable
@MainActor

class VideoPlayerViewModel: ObservableObject {
    var videoURL: URL?
    var isLoading = true
    
    private var videoService = VideoService()
    private let videoPath = "DoubleTest.mp4"
    
    
    func loadVideoURL() {
        Task {
            do {
                let url = try await videoService.getSignedVideoURL(path: videoPath)
                DispatchQueue.main.async {
                    self.videoURL = url
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    print("DEBUG: Failed to get video URL: \(error)")
                    self.isLoading = false
                }
            }
        }
    }
}
