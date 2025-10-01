//
//  SeatItem.swift
//  CarInfo
//
//  Created by window1 on 9/28/25.
//

import Foundation


enum SeatPosition: String, Codable {
    case driver = "운전석"
    case passenger = "조수석"
    case rearLeft = "뒷좌석 좌측"
    case rearRight = "뒷좌석 우측"
}

struct SeatHeaterStatus {
    //0: 꺼짐, 1~3:단계
    var level: Int
}
