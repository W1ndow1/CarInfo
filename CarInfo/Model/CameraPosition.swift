//
//  CameraPosition.swift
//  CarInfo
//
//  Created by window1 on 10/3/25.
//

import Foundation
import SwiftUICore

enum CameraPosition: String, Codable {
    case left = "좌측 뒤"
    case right = "우측 뒤"
    case front = "전면"
    case back = "후면"
    case inner = "내부"
    
    var fovData: FOVData {
        switch self {
        case .front:
            return FOVData(
                startAngle: .degrees(190),
                endAngle: .degrees(-10),
                radius: 160,
                rotation: .degrees(0),
                offsetX: 0,
                offsetY: 100
            )
        case .left:
            return FOVData(
                startAngle: .degrees(200),
                endAngle: .degrees(-20),
                radius: 140,
                rotation: .degrees(-90),
                offsetX: 100,
                offsetY: 0
            )
        case .right:
            return FOVData(
                startAngle: .degrees(200),
                endAngle: .degrees(-20),
                radius: 140,
                rotation: .degrees(90),
                offsetX: -100,
                offsetY: 0
            )
        case .back:
            return FOVData(
                startAngle: .degrees(200),
                endAngle: .degrees(-20),
                radius: 160,
                rotation: .degrees(180),
                offsetX: 0,
                offsetY: -100
            )
        case .inner:
            return FOVData(
                startAngle: .degrees(180),
                endAngle: .degrees(0),
                radius: 100,
                rotation: .degrees(180),
                offsetX: 0,
                offsetY: 0
            )
        }
    }
}

struct FOVData {
    let startAngle: Angle
    let endAngle: Angle
    let radius: CGFloat
    let rotation: Angle
    let offsetX: CGFloat
    let offsetY: CGFloat
}

