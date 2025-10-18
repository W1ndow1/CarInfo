//
//  Untitled.swift
//  CarInfo
//
//  Created by window1 on 9/19/25.
//

import SwiftUI

struct HomeTabView: View {
    @Environment(AuthViewModel.self)private var authVM
    @Environment(UserManager.self)private var userManager
    
    var body: some View {
        HStack {
            if let currentUserID = authVM.currentUserID {
                TabView {
                    
                    ControlView(currentUserID: currentUserID)
                        .tag(0)
                        .tabItem({
                            Label("제어", systemImage: "car.side")
                        })
                    LocationTrackerView()
                        .tag(1)
                        .tabItem({
                            Label("탐색", systemImage: "map")
                        })
                    SettingView()
                        .environment(authVM)
                        .tag(2)
                        .tabItem({
                            Label("설정", systemImage: "gear")
                        })
                }
                .environment(userManager)
            } else {
                LoginView()
                    .environment(authVM)
            }
        }
        .task { await authVM.refreshUser() }
    }
}

#Preview {
    HomeTabView()
        .environment(AuthViewModel())
        .environment(UserManager())
}
