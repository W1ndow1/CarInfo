//
//  ClimateControlView.swift
//  CarInfo
//
//  Created by window1 on 9/24/25.
//

import SwiftUI

struct ClimateControlView: View {
    @EnvironmentObject var vm: ControlViewViewModel
    @Binding var isPresented: Bool
    
    var body: some View {
        if isPresented {
            ZStack {
                //배경
                Color.primary.colorInvert()
                    .foregroundStyle(Color.white)
                    .ignoresSafeArea()
                    .zIndex(0)
                
                VStack(spacing: 30) {
                    //상단 네비게이션바
                    HStack {
                        Button {
                            withAnimation {
                                isPresented = false
                            }
                        } label: {
                            Group {
                                Image(systemName: "chevron.backward")
                                    .font(.system(size: 18, weight: .medium))
                                Text("뒤로")
                            }
                            .foregroundStyle(Color.primary)
                        }
                        .padding(.leading, 20)
                        Spacer()
                        
                    }
                    //차량 좌석
                    RoundedRectangle(cornerRadius: 30)
                        .frame(width: 250, height: 300)
                        .foregroundStyle(Color.gray.gradient)
                        .overlay {
                            VStack(spacing: 20) {
                                Button {
                                    vm.isSteeringWheelHeatOn.toggle()
                                } label: {
                                    Image(systemName: "steeringwheel.and.heat.waves")
                                        .font(.system(size: 40, weight: .light))
                                        .foregroundStyle(vm.isSteeringWheelHeatOn ? Color.red : Color.primary)
                                }
                                .padding(.trailing, 90)
                                .padding(.top, 40)
                                .padding(.bottom, 5)
                                
                                HStack(spacing: 40) {
                                    SeatHeaterControl(position: .driver)
                                    SeatHeaterControl(position: .passenger)
                                }
                                
                                HStack(spacing: 40) {
                                    SeatHeaterControl(position: .rearLeft)
                                    SeatHeaterControl(position: .rearRight)
                                }
                                Spacer()
                            }
                        }
                    Spacer()
                }
                .zIndex(1)
                .sheet(isPresented: .constant(true)) {
                    sheetView()
                        .interactiveDismissDisabled(true)
                        .presentationDetents([.height(300), .height(450)])
                        .presentationDragIndicator(.visible)
                        .presentationBackgroundInteraction(.enabled)
                        .presentationCornerRadius(20)
                    
                }
            }
        }
    }
    
    @ViewBuilder
    func sheetView() -> some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                HStack {
                    Text("실내 \(String(format: "%.0f", vm.currentCarStatus.carTemp))℃")
                    Text("실외 \(String(format: "%.0f", vm.currentCarStatus.outsideTemp))℃")
                }
                .padding(.top, 30)
                //공조 조절 패널
                HStack {
                    VStack(spacing: 10) {
                        Button{
                            vm.isFanOn.toggle()
                        } label: {
                            Image(systemName: "power.circle")
                                .font(.system(size: 30, weight: vm.isFanOn ? .bold : .light))
                                .foregroundStyle(.foreground)
                        }
                        .padding(.horizontal, 40)
                        Text(vm.isFanOn ? "켜짐" : "끔")
                            .font(.system(size: 13, weight: vm.isFanOn ? .bold : .light))
                    }
                    
                    Button {
                        vm.setTemp -= 0.5
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 30, weight: .light))
                            .foregroundStyle(.foreground)
                    }
                    
                    
                    Text("\(String(format: "%.1f", vm.setTemp))℃")
                        .font(.system(size: 30, weight: vm.isFanOn ? .bold : .light))
                        .frame(width: 110)
                        .padding(.horizontal, 15)
                    
                    Button {
                        vm.setTemp += 0.5
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 30, weight: .light))
                            .foregroundStyle(.foreground)
                    }
                    VStack(spacing: 10) {
                        
                        Button{
                            
                        } label: {
                            Image(systemName: "arrowtriangle.up.arrowtriangle.down.window.right")
                                .font(.system(size: 30, weight: .light))
                                .foregroundStyle(.foreground)
                        }
                        .padding(.horizontal, 40)
                        .onLongPressGesture(perform: {
                            
                        })
                        Text("환기")
                            .font(.system(size: 13, weight: .light))
                    }
                    
                }
                Group {
                    //(1)성애 제거
                    Button {
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 1)
                            .overlay{
                                HStack {
                                    Image(systemName: "windshield.front.and.heat.waves")
                                        .font(.system(size: 20))
                                    Text("차 성애 제거")
                                    Spacer()
                                }
                                .padding(.horizontal, 10)
                            }
                    }
                    //2)스마트 모드
                    Button {
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 1)
                            .overlay{
                                HStack {
                                    Image(systemName: "thermometer.variable")
                                        .font(.system(size: 20))
                                        .padding(.horizontal, 10)
                                    Text("스마트 모드")
                                    Spacer()
                                }
                                .padding(.horizontal, 10)
                            }
                    }
                    //3)차박 모드
                    Button {
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 1)
                            .overlay{
                                HStack {
                                    Image(systemName: "tent")
                                        .font(.system(size: 20))
                                    Text("차박 모드")
                                    Spacer()
                                }
                                .padding(.horizontal, 10)
                            }
                    }
                }
                .frame(width: 350, height: 50)
                .foregroundStyle(Color.primary)
                
                Divider()
                    .padding(.horizontal, 27)
                
                Spacer()
                
            }
        }
    }
}

#Preview {
    ClimateControlView(isPresented: .constant(true))
        .environmentObject(ControlViewViewModel())
}


struct SeatHeaterControl: View {
    let position: SeatPosition
    @EnvironmentObject var vm: ControlViewViewModel
    
    private let seatHeaterLevels: [Int] = [0, 3, 2, 1]
    
    var body: some View {
        
        let currentLevel = vm.getHeaterLevel(for: position)
        let currentIndex = seatHeaterLevels.firstIndex(of: currentLevel) ?? 0
        let nextIndex = (currentIndex + 1) % seatHeaterLevels.count
        let nextLevel = seatHeaterLevels[nextIndex]
        
        Button {
            vm.setSeatHeaterLevel(for: position, to: nextLevel )
        } label: {
            VStack {
                Image(systemName: "carseat.left.and.heat.waves")
                    .font(.system(size: 40, weight: .light))
                    .foregroundStyle(currentLevel > 0 ? Color.red : Color.primary)
                Text("\(currentLevel)")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(currentLevel > 0 ? Color.red : Color.primary)
            }
        }
    }
}
