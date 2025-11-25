//
//  CarInfoApp.swift
//  CarInfo
//
//  Created by window1 on 9/9/25.
//

import SwiftUI
import SwiftData
import Supabase

@main
struct CarInfoApp: App {
    @State private var authVM = AuthViewModel()
    @State private var userManager = UserManager()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            groupView
        }
        .environment(authVM)
        .environment(userManager)
        .modelContainer(sharedModelContainer)
    }
    
    @ViewBuilder
    private var groupView: some View {
        switch authVM.authState {
        case .checkingAuth:
            LoadingView()
                .task {
                    await authVM.refreshUser()
                }
        
        case .checkedCarRegistration:
            HomeTabView()
            
        case .unauthenticated:
            LoginView()
            
        case .carNotRegistered:
            CarRegistrationView()
        }
    }
}
