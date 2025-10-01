//
//  ControlViewViewModel.swift
//  CarInfo
//
//  Created by window1 on 9/22/25.
//

import Foundation
import SwiftUI

class ControlViewViewModel: ObservableObject {
    
    @Published var carStatus = CarStatus()
    @Published var setTemp: Double = 22.0
    @Published var isFanOn: Bool = false
    @Published var isSteeringWheelHeatOn: Bool = false
    @Published var isCarseatHeatOn: Bool = false
    @Published var seatHeaterStatuses: [SeatPosition: SeatHeaterStatus] = [
        .driver: SeatHeaterStatus(level: 0),
        .passenger: SeatHeaterStatus(level: 0),
        .rearLeft: SeatHeaterStatus(level: 0),
        .rearRight: SeatHeaterStatus(level: 0),
    ]
    
    init() {
        getCarStatus()
    }
    
    func getCarStatus() {
        self.carStatus = CarStatus()
    }
    
    func toggleFanControl() {
        carStatus.isFanOn.toggle()
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
}
