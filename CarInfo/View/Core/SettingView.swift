//
//  SettingView.swift
//  CarInfo
//
//  Created by window1 on 10/10/25.
//

import SwiftUI

struct SettingView: View {
    @Environment(AuthViewModel.self) private var authVM
    var body: some View {
        List {
            Button {
                Task {
                    await authVM.signOut()
                }
            } label: {
                
                HStack {
                    Image(systemName: "poweroutlet.type.e.square")
                        .font(.system(size: 20, weight: .light))
                        .foregroundStyle(.red)
                    Text("로그아웃")
                        .foregroundStyle(.pink)
                        .font(.system(size: 18, weight: .light))
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Text("123")
                }
            }
        }
    }
}

#Preview {
    SettingView()
        .environment(AuthViewModel())
}
