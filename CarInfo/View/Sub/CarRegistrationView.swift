//
//  CarRegistrationView.swift
//  CarInfo
//
//  Created by window1 on 10/14/25.
//

import SwiftUI

struct CarRegistrationView: View {
    @Environment(UserManager.self) var userVM
    @Environment(AuthViewModel.self) var authVM
    @State private var vehicleId = ""
    @State private var isCheckId: Bool = false
    
    var body: some View {
        VStack {
            Text("소유차량등록하기")
                .font(.system(size: 20, weight: .medium))
            TextField(text: $vehicleId, label: {
                Text("차대번호")
                    .foregroundStyle(Color.primary)
            })
            .font(.system(size: 18, weight: .light))
            .padding(15)
            .background(Color.gray.secondary)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .onChange(of: vehicleId) { newValue, oldValue in
                
            }
            
            Button {
                //KMHEL13CPYA000001
                if userVM.checkCarCodeLength(carId: vehicleId) {
                    isCheckId = true
                    Task {
                        await userVM.registrationCar(carId: vehicleId)
                    }
                } else {
                    isCheckId = false
                }
            } label: {
                Text("등록")
                    .padding(15)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            
            Text(isCheckId ? "등록성공" : "차대번호 17자리를 확인해주세요")  
            
        }
        .padding()
    }
}

#Preview {
    CarRegistrationView()
        .environment(UserManager())
        .environment(AuthViewModel())
}
