//
//  SecurityCameraView.swift
//  CarInfo
//
//  Created by window1 on 9/24/25.
//

import SwiftUI

struct SecurityCameraView: View {
    @EnvironmentObject var vm: ControlViewViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 1) {
            HStack(spacing: 1) {
                Rectangle()
                    .frame(width: 200, height: 120)
                Rectangle()
                    .frame(width: 200, height: 120)
            }
            HStack(spacing: 1) {
                Rectangle()
                    .frame(width: 200, height: 120)
                Rectangle()
                    .frame(width: 200, height: 120)
            }
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .foregroundStyle(Color.gray.gradient)
                    .frame(width: 200, height: 250)
                    .zIndex(1)
                CameraButtonControl(position: CameraPosition.inner)
                    .offset(y: -90)
                    .zIndex(2)
                CameraButtonControl(position: CameraPosition.front)
                    .offset(y: -150)
                    .zIndex(0)
                CameraButtonControl(position: CameraPosition.left)
                    .offset(x: -150, y: 0)
                    .zIndex(0)
                CameraButtonControl(position: CameraPosition.right)
                    .offset(x: 150, y: 0)
                    .zIndex(0)
                CameraButtonControl(position: CameraPosition.back)
                    .offset(y: 150)
                    .zIndex(0)
            }
            .frame(width: 400, height: 400)
            
            HStack(spacing: 180){
                Group {
                    Button {
                        
                    } label: {
                        VStack(alignment: .center, spacing:10) {
                            Image(systemName: "horn.blast")
                                .font(.system(size:20))
                            Text("경적")
                        }
                    }
                    Button {
                        
                    } label: {
                        VStack(alignment: .center, spacing:10) {
                            Image(systemName: "headlight.high.beam")
                                .font(.system(size:20))
                            Text("라이트")
                            
                        }
                    }
                }
                .foregroundStyle(Color.primary)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle("라이브 카메라")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading, content: {
                Button {
                    dismiss()
                } label: {
                     Image(systemName: "chevron.left")
                        .foregroundStyle(Color.primary)
                }
                    
            })
            ToolbarItem(placement: .topBarTrailing, content: {
                Button {
                    
                } label: {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 30, height: 30)
                }
            })
            
        }
    }
}


#Preview {
    SecurityCameraView()
        .environmentObject(ControlViewViewModel())
}



struct CameraVisioinRange: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var radius: CGFloat
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.midY))
        
        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.minY),
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false)
        path.closeSubpath()
        return path
    }
}


struct CameraButtonControl: View {
    let position: CameraPosition
    @EnvironmentObject var vm: ControlViewViewModel
    
    var body: some View {
        
        let currentStatus = vm.getCameraStatus(for: position)
        let fov = position.fovData
        
        VStack {
            Button {
                vm.setCameraStatus(for: position)
            } label: {
                Circle()
                    .stroke(style: .init(lineWidth: 1))
                    .foregroundStyle(Color.blue)
                    .frame(width: 15)
                    .overlay {
                        if currentStatus {
                            Circle()
                                .fill(Color.blue)
                        }
                    }
            }
            .overlay(content: {
                if currentStatus {
                    CameraVisioinRange(
                        startAngle: fov.startAngle,
                        endAngle: fov.endAngle,
                        radius: fov.radius,
                    )
                    .fill(
                        RadialGradient(
                            gradient:Gradient(stops: [
                                .init(color: Color.blue.opacity(0.8), location: 0),
                                .init(color: Color.blue.opacity(0.5), location: 0.7),
                                .init(color: Color.blue.opacity(0.0), location: 1),
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 180
                        )
                    )
                    .frame(width: 150, height: 150)
                    .rotationEffect(fov.rotation)
                    .offset(x:fov.offsetX, y: fov.offsetY)
                    
                        
                }
            })
            Text("\(position.rawValue)")
                .font(.system(size: 13, weight: .light))
        }
        .padding()
    }
}
