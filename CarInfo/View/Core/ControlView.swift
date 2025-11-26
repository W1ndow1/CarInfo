//
//  ControlView.swift
//  CarInfo
//
//  Created by window1 on 9/19/25.
//

import SwiftUI

struct ControlView: View {
    @Environment(UserManager.self)private var userVM
    @StateObject private var vm = ControlViewViewModel()
    @State private var isDoorLock = true
    @State private var isFanOn = false
    @State private var isChargeOn = false
    @State private var chargeValue: CGFloat = 80
    @State private var isWindowOpen = false
    @State private var isFanOptionOn = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                ClimateControlView(isPresented: $isFanOptionOn)
                    .environmentObject(vm)
                    .zIndex(1)
                VStack(spacing: 20) {
                    //Header
                    HStack {
                        VStack(alignment: .leading, spacing: -5){
                            Text(vm.carStatus?.carName ?? "마이카")
                                .font(.system(size: 20, weight: .bold))
                            DynamicBatteryView(batteryLevel: vm.currentCarStatus.batteryLevel)
                                .frame(width: 40, height: 35)
                            Text(vm.carStatus?.status.rawValue ?? "")
                                .font(.system(size: 15, weight: .light))
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            HStack {
                                Image(systemName: "cloud.rain")
                                    .font(.system(size: 20))
                                Text("흐림")
                                    .font(.system(size: 20, weight: .light))
                            }
                            Text(String(format:"%.0f", vm.carStatus?.outsideTemp ?? "") + "℃")
                        }
                    }
                    .padding(.horizontal, 5)
                    
                    //Image
                    Image(systemName: "car")
                        .font(.system(size: 140, weight: .ultraLight))
                        .frame(width: 100, height: 250)
                    
                    //Body
                    scrollViewSection()
                }
                .zIndex(0)
            }
            .onAppear() {
                //vm.carStatus = userVM.currentCarStatus?.first
            }
        }
    }
    
    @ViewBuilder
    func scrollViewSection() -> some View {
        ScrollView {
            bodyButtonGroup()
                .padding(.vertical, 10)
            if isChargeOn {
                chargeSection()
            }
            if isWindowOpen {
                windowSection()
            }
            
            VStack(alignment: .leading, spacing: 0) {
                //공조
                Button {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isFanOptionOn.toggle()
                    }
                } label: {
                    HStack {
                        Image(systemName: "fan")
                            .font(.system(size: 30, weight: .light))
                        VStack(alignment:.leading) {
                            Text("실내온도")
                            HStack {
                                if vm.carStatus?.isFanOn ?? false {
                                    Text("활성")
                                }
                                Text(String(format:"%.1f", vm.carStatus?.setTemp ?? "22") + "℃")
                            }
                        }
                        Spacer()
                        Image(systemName: "chevron.forward")
                    }
                    .foregroundStyle(Color.primary)
                }
                .padding(15)
               
                //카메라
                NavigationLink(destination: SecurityCameraView().environmentObject(vm)) {
                    HStack {
                        Image(systemName: "video")
                            .font(.system(size: 30, weight: .light))
                        VStack(alignment:.leading) {
                            Text("카메라")
                        }
                        Spacer()
                        Image(systemName: "chevron.forward")
                    }
                }
                .foregroundStyle(Color.primary)
                .padding(15)
                
                //차량상태
                NavigationLink(destination: StatusView()) {
                    HStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 30, weight: .light))
                        VStack(alignment:.leading) {
                            Text("차량상태")
                        }
                        Spacer()
                        Image(systemName: "chevron.forward")
                    }
                }
                .foregroundStyle(Color.primary)
                .padding(15)
            }
        }
    }
   
    @ViewBuilder
    func windowSection() -> some View {
        VStack(alignment: .leading) {
            Group {
                HStack(spacing: 30) {
                    Button {
                        vm.isWindowOpen = false
                    } label: {
                        VStack(spacing: 5) {
                            Image(systemName: "arrow.up.to.line")
                                .font(.system(size: 30, weight: .light))
                            Text("창문닫기")
                                .font(.system(size: 18, weight: .bold))
                        }
                    }
                    
                    Button {
                        vm.isWindowOpen = true
                    } label: {
                        VStack(spacing: 5) {
                            Image(systemName: "arrow.down.to.line")
                                .font(.system(size: 30, weight: .light))
                            Text("창문열기")
                                .font(.system(size: 18, weight: .bold))
                        }
                    }
                }
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 118)
            .background(Color.gray.opacity(0.25))
            .foregroundStyle(Color.primary)
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }
    
    @ViewBuilder
    func chargeSection() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Group {
                HStack {
                    Text("충전한도")
                        .font(.system(size: 18, weight: .bold))
                    Text(String(format: "%.0f", chargeValue) + "%")
                        .font(.system(size: 20, weight: .light))
                }
                Slider(value: $chargeValue, in: 50...100)
                    .frame(width: 350)
            }
        }
        .padding(.vertical, 25)
        .padding(.horizontal, 20)
        .background(Color.gray.opacity(0.25))
        .foregroundStyle(Color.primary)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
    
    @ViewBuilder
    func bodyButtonGroup() -> some View {
        HStack(spacing: 35) {
            //도어락
            Button {
                isDoorLock.toggle()
                vm.toggleDoorControl(isLock: isDoorLock)
            } label: {
                Image(systemName: isDoorLock ? "lock" : "lock.open")
                    .font(.system(size: 30, weight: .light))
                    .foregroundStyle(.foreground)
                    .scaleEffect(x: -1, y: 1)
                    .frame(width: 30, height: 30)
            }
            //공조
            Button {
                vm.isFanOn.toggle()
                vm.toggleFanControl(isOn: vm.isFanOn)
            } label: {
                Image(systemName: vm.isFanOn ? "fan" : "fan.slash")
                    .font(.system(size: 30, weight: .light))
                    .foregroundStyle(.foreground)
                    .frame(width: 30, height: 30)
            }
            //충전
            Button {
                withAnimation {
                    isChargeOn.toggle()
                }
            } label: {
                Image(systemName: "bolt")
                    .font(.system(size: 30, weight: .light))
                    .foregroundStyle(.foreground)
                    .frame(width: 30, height: 30)
            }
            //창문
            Button {
                withAnimation {
                    isWindowOpen.toggle()
                }
            } label: {
                Image(systemName: "arrowtriangle.up.arrowtriangle.down.window.right")
                    .font(.system(size: 30, weight: .light))
                    .foregroundStyle(.foreground)
                    .frame(width: 30, height: 30)
            }
            //테일게이트
            Button {
                
            } label: {
                Image(systemName: "car.side.rear.open.crop")
                    .font(.system(size: 30, weight: .light))
                    .foregroundStyle(.foreground)
                    .frame(width: 30, height: 30)
            }
        }
    }
}

#Preview {
    HomeTabView()
        .environment(AuthViewModel())
        .environment(UserManager())
}


struct DynamicBatteryView: View {
    var batteryLevel: CGFloat
    
    var body: some View {
        GeometryReader{ geo in
            ZStack(alignment: .leading, content: {
                Text(String(format: "%.0f", batteryLevel * 100) + "%")
                    .font(.system(size: 10))
                    .zIndex(2)
                    .padding(.leading, 7)
                Image(systemName: "battery.0percent")
                    .resizable()
                    .scaledToFit()
                    .zIndex(1)
                
                Rectangle()
                    .fill(batteryLevel > 0.2 ? Color.green : Color.red)
                    .frame(width: geo.size.width * batteryLevel * 0.8, height: geo.size.height * 0.45)
                    .padding(.horizontal, 2)
                    .zIndex(0)
                
                
            })
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}
