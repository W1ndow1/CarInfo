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

struct CarStatus: Codable, Identifiable {
    
    var id = UUID().uuidString
    var user_id = UUID().uuidString
    
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
    var maxTemperature: Double = 27.0
    var minTemperature: Double = 18.0
    
    enum CodingKeys: String, CodingKey {
        case id, user_id, location, status
        
        case batteryLevel = "battery_level"
        case carName = "car_name"
        case carType = "car_type"
        case isFanOn = "is_fan_on"
        case carTemp = "car_temp"
        case outsideTemp = "outside_temp"
        case setTemp = "set_temp"
        case doorLock = "door_lock"
    }
    
}

extension CarStatus {
    static func mock() -> CarStatus {
        CarStatus(
            id: UUID().uuidString,
            user_id: UUID().uuidString,
            status: CarStatusType.parking,
            batteryLevel: 0.62,
            location: "서울시 용산구",
            doorLock: true,
            carName: "마이카",
            carType: CarType.electricCar,
            isFanOn: false,
            carTemp: 22.0,
            outsideTemp: 26.0,
            setTemp: 22.0
            )
    }
}
