//
//  ControlViewViewModel.swift
//  CarInfo
//
//  Created by window1 on 9/22/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class ControlViewViewModel: ObservableObject {
    @Published var carStatus: CarStatus?
    @Published var isFanOn: Bool = false
    @Published var isWindowOpen:Bool = false
    @Published var isSteeringWheelHeatOn: Bool = false
    @Published var seatHeaterStatuses: [SeatPosition: SeatHeaterStatus] = [
        .driver: SeatHeaterStatus(level: 0),
        .passenger: SeatHeaterStatus(level: 0),
        .rearLeft: SeatHeaterStatus(level: 0),
        .rearRight: SeatHeaterStatus(level: 0),
    ]
    @Published var setTemp: Double = 22.0 {
        didSet {
            if setTemp > maxTemperature {
                setTemp = maxTemperature
            } else if setTemp < minTemperature {
                setTemp = minTemperature
            }
        }
    }
    @Published var isDoorLock: Bool = false
    
    var currentCarStatus: CarStatus {
        carStatus ?? CarStatus.mock()
    }
    private var maxTemperature: Double = 27.0
    private var minTemperature: Double = 18.0
    
    private var cancellables = Set<AnyCancellable>()
    
    private let carControlService: CarControlService
    private let userManager: UserManager
    
    init(carControlService: CarControlService = CarControlService(),
         userManager: UserManager = UserManager()) {
        self.carControlService = carControlService
        self.userManager = userManager
        
        Task {
            await fetchInitialCarstatus()
        }
    }
    
    private func fetchInitialCarstatus() async{
        if let initialStatus = userManager.currentCarStatus {
            //초기값 가져오기
            self.carStatus = initialStatus.first
            self.setTemp = initialStatus.first?.setTemp ?? 22.0
            self.isFanOn = initialStatus.first?.isFanOn ?? false
            self.isWindowOpen = initialStatus.first?.isWindowOpen ?? false
            self.isDoorLock = initialStatus.first?.doorLock ?? false
            //속성구독처리
            setupSubscriptions()
        }
    }

    private func setupSubscriptions() {
        //온도조절 Sub
        $setTemp
            .dropFirst(1)
            .debounce(for: .seconds(0.8), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] debouncedTemp in
                guard let self = self else { return                 }
                let clampedTemp = min(self.maxTemperature, max(self.minTemperature, debouncedTemp))
                print("Debounced: 온도가 \(clampedTemp)로 변경되어 서버에 업데이트합니다.")
                self.setTemperature(clampedTemp)
            }
            .store(in: &cancellables)
        
        $isWindowOpen
            .dropFirst(1)
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] openWindow in
                print(("창문 열기: \(openWindow)"))
                self?.toggleWindowControl(isLock: openWindow )
            }
            .store(in: &cancellables)
    }
    
    func toggleWindowControl(isLock: Bool) {
        Task {
            await updateCarControlStatus(column: "is_window_open", value: isLock)
        }
    }

    func toggleFanControl(isOn: Bool) {
        Task {
            await updateCarControlStatus(column: "is_fan_on", value: isOn)
        }
    }
    
    func toggleDoorControl(isLock: Bool) {
        Task {
            await updateCarControlStatus(column: "door_lock", value: isLock)
        }
    }
    
    private func setTemperature(_ temperature: Double) {
        Task {
            await updateCarControlStatus(column: "set_temp", value: temperature)
        }
    }
    
    func updateCarControlStatus<T:Encodable>(column: String, value: T) async {
        do {
            guard let vehicleId = userManager.currentCarId else { return }
            let updateValue = try await carControlService.updateVehicleStatus(vehicleId: vehicleId, column: column, value: value)
            self.carStatus = updateValue
            print("차량 상태 업데이트에 성공했습니다 ")
        } catch {
            print("차량 업데이트를 실패했습니다. : \(error.localizedDescription)")
        }
    }
    
    func setSeatHeaterLevel(for position: SeatPosition, to newLevel: Int) {
        let clampedLevel = min(3, max(0, newLevel))
        
        if var status = seatHeaterStatuses[position] {
            status.level = clampedLevel
            seatHeaterStatuses[position] = status
        }
    }
    
    func getHeaterLevel(for position: SeatPosition) -> Int {
        return seatHeaterStatuses[position]?.level ?? 0
    }
}
