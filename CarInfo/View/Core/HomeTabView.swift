//
//  Untitled.swift
//  CarInfo
//
//  Created by window1 on 9/19/25.
//

import SwiftUI

struct HomeTabView: View {
    @Environment(AuthViewModel.self)private var authVM
    @Environment(UserManager.self)private var userVM

    var body: some View {
        HStack {
            if let currentUserID = authVM.currentUserID {
                if userVM.isRegistered {
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
                } else {
                    CarRegistrationView()
                }
            } else {
                LoginView()
            }
        }
        .task {
            await authVM.refreshUser()
            await userVM.loadUserCarStatuses()
        }
    }
}

#Preview {
    HomeTabView()
        .environment(AuthViewModel())
        .environment(UserManager())
}
