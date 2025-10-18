//
//  SecurityCameraViewModel.swift
//  CarInfo
//
//  Created by window1 on 10/13/25.
//

import SwiftUI

class SecurityCameraViewModel: ObservableObject {
    
    @Published var cameraStatuses: [CameraPosition: Bool] = [
        .front: false,
        .back: false,
        .inner: false,
        .left: false,
        .right: false
    ]
    
    func setCameraStatus(for position: CameraPosition) {
        if var status = cameraStatuses[position] {
            status.toggle()
            cameraStatuses[position] = status
            
            //서버에 카메라 영상 요청 보내기
        }
    }
    
    func getCameraStatus(for position: CameraPosition) -> Bool {
        return cameraStatuses[position] ?? false
    }
}
