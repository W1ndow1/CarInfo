//
//  CarRegistrationView.swift
//  CarInfo
//
//  Created by window1 on 10/14/25.
//

import SwiftUI

struct CarRegistrationView: View {
    @State private var vehicleId = ""
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
            
            Button {
                
            } label: {
                Text("등록")
                    .padding(15)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            
        }
        .padding()
    }
}

#Preview {
    CarRegistrationView()
}
