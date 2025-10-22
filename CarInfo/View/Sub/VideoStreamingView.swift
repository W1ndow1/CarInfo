//
//  VideoStreamingView.swift
//  CarInfo
//
//  Created by window1 on 10/17/25.
//

import SwiftUI
import AVKit

struct VideoStreamingView: View {
    
    let position: CameraPosition
    @StateObject private var videoVM: VideoPlayerViewModel
    @Environment(UserManager.self) var userManager
    @EnvironmentObject var vm: ControlViewViewModel // ControlViewViewModel 접근

    init(position: CameraPosition) {
        self.position = position
        _videoVM = StateObject(wrappedValue: VideoPlayerViewModel())
    }
    
    var body: some View {
        // ControlViewViewModel의 상태에 따라 영상 표시 여부 결정
        if vm.getCameraStatus(for: position) {
            VStack {
                if videoVM.isLoading {
                    ProgressView()
                        .frame(width: 100)
                } else if let url = videoVM.videoURL {
                    VideoPlayer(player: AVPlayer(url: url))
                        .frame(width: 200, height: 125)
                        // .onAppear { AVPlayer(url: url).play() } // VideoPlayer가 자동으로 재생 관리
                } else {
                    Rectangle()
                        .foregroundStyle(.gray)
                        .frame(width: 200, height: 125)
                        .overlay(content: {
                            Text("비디오URL을 가져오지 못했습니다.")
                                .foregroundStyle(.white)
                        })
                }
            }
            .onAppear {
                videoVM.loadVideoURL(for: position)
            }
            .onChange(of: position) { oldPosition, newPosition in
                // position이 변경될 경우 (예: 뷰가 재사용될 때) URL 다시 로드
                videoVM.loadVideoURL(for: newPosition)
            }
        } else {
            // 카메라가 꺼져 있을 때 표시할 플레이스홀더
            Rectangle()
                .foregroundStyle(.black)
                .frame(width: 200, height: 125)
                .overlay(content: {
                    Text("\(position.rawValue) 카메라 OFF")
                        .foregroundStyle(.white)
                })
        }
    }
}

#Preview {
    VideoStreamingView(position: .front)
        .environment(UserManager())
        .environmentObject(ControlViewViewModel())
}
