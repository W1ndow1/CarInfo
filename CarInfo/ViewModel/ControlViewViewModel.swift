//
//  ControlViewViewModel.swift
//  CarInfo
//
//  Created by window1 on 9/22/25.
//

import Foundation
import SwiftUI

class ControlViewViewModel: ObservableObject {
    
    @Published var carStatus: CarStatus?
    @Published var isFanOn: Bool = false
    @Published var isSteeringWheelHeatOn: Bool = false
    @Published var isCarseatHeatOn: Bool = false
    @Published var setTemp: Double = 22.0 {
        didSet {
            if setTemp > maxTemperature {
                setTemp = maxTemperature
            }
            if setTemp < minTemperature {
                setTemp = minTemperature
            }
        }
    }
    @Published var seatHeaterStatuses: [SeatPosition: SeatHeaterStatus] = [
        .driver: SeatHeaterStatus(level: 0),
        .passenger: SeatHeaterStatus(level: 0),
        .rearLeft: SeatHeaterStatus(level: 0),
        .rearRight: SeatHeaterStatus(level: 0),
    ]
    @Published var cameraStatuses: [CameraPosition: Bool] = [
        .front: false,
        .back: false,
        .inner: false,
        .left: false,
        .right: false
    ]
    
    private var maxTemperature: Double = 27.0
    private var minTemperature: Double = 18.0
    
    var currentCarStatus: CarStatus {
        carStatus ?? CarStatus.mock()
    }
    
    init() {
        
    }

    
    func fetchUserCarData(userId: UUID) async throws -> CarStatus {
        let status = self.carStatus
        return status!
        
        
    }
    
    func toggleFanControl() {
        //carStatus.isFanOn.toggle()
    }
    
    func setSeatHeaterLevel(for position: SeatPosition, to newLevel: Int) {
        let clampedLevel = min(3, max(0, newLevel))
        
        if var status = seatHeaterStatuses[position] {
            status.level = clampedLevel
            seatHeaterStatuses[position] = status
            
            //서버에 시트 히터 레벨 정보 보내기
        }
    }
    
    func getHeaterLevel(for position: SeatPosition) -> Int {
        return seatHeaterStatuses[position]?.level ?? 0
    }
    
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
