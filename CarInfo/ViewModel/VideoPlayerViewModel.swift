//
//  VideoPlayerViewModel.swift
//  CarInfo
//
//  Created by window1 on 10/17/25.
//

import Foundation
import AVKit

@MainActor

class VideoPlayerViewModel: ObservableObject {
    @Published var videoURL: URL?
    @Published var isLoading = true
    
    private var videoService = VideoService()
    
    func loadVideoURL(for position: CameraPosition) {
        self.isLoading = true
        self.videoURL = nil // 이전 URL 초기화
        
        let videoFileName: String
        switch position {
        case .front: videoFileName = "front.mp4"
        case .back: videoFileName = "back.mp4"
        case .left: videoFileName = "left.mp4"
        case .right: videoFileName = "right.mp4"
        case .inner: videoFileName = "inner.mp4" // 내부 카메라 영상 파일명 가정
        }
        
        Task {
            do {
                let url = try await videoService.getSignedVideoURL(path: videoFileName)
                DispatchQueue.main.async {
                    self.videoURL = url
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    print("DEBUG: Failed to get video URL for \(position.rawValue): \(error)")
                    self.videoURL = nil
                    self.isLoading = false
                }
            }
        }
    }
}
