//
//  CarStatus.swift
//  CarInfo
//
//  Created by window1 on 9/22/25.
//

import Foundation

enum CarStatusType: String, Codable {
    case parking = "주차중"
    case driving = "운행중"
    case charging = "충전중"
    case unknown = "알 수 없음"
}

enum CarType: String, Codable {
    case electricCar = "전기차"
    case gasolineCar = "가솔린차"
    case hybridCar = "하이브리드"
    case dieselCar = "디젤차"
}

struct CarStatus: Codable {
    var status = CarStatusType.parking
    var batteryLevel: Double = 0.56
    var location: String = "서울시 용산구"
    var doorLock: Bool = true
    var carName: String = "EV6"
    var carType = CarType.electricCar
    var isFanOn: Bool = false
    var carTemp: Double = 22.0
    var outsideTemp: Double = 26.0
    var setTemp: Double = 22.0 {
        didSet {
            if setTemp > maxTemperature {
                setTemp = maxTemperature
            }
            if setTemp <  minTemperature {
                setTemp = minTemperature
            }
        }
    }
    private var maxTemperature: Double = 27.0
    private var minTemperature: Double = 18.0
    
}
