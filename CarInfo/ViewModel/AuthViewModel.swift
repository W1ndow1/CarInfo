//
//  AuthViewModel.swift
//  CarInfo
//
//  Created by window1 on 10/6/25.
//

import Foundation
import Supabase

@Observable
@MainActor

class AuthViewModel: ObservableObject {
    var session: Session? = nil
    var isLoading = false
    var errorMessage: String?
    var currentUserID: String?
    var currentVehicleID: String?
    var authState: AuthState = .checkingAuth

    private var authService: SupabaseAuthService
    private var userService: UserService
    
    init(authService: SupabaseAuthService = SupabaseAuthService(), userService: UserService = UserService()) {
        self.authService = authService
        self.userService = userService
        Task {
            await refreshUser()
        }
    }
        
    func signUp(email: String, password: String, username: String) async {
        do {
            self.currentUserID = try await authService.signUp(email: email, password: password, username: username)
            await checkCarRegistration()
        } catch {
            print("DEBUG: Sign up Error:\(error.localizedDescription)")
        }
    }
    
    func signIn(email: String, password: String) async {
        do {
            self.currentUserID = try await authService.signIn(email: email, password: password)
            await checkCarRegistration()
        } catch {
            print("DEBUG: Sign in Error:\(error.localizedDescription)")
        }
    }
    
    func signOut() async {
        do {
            try await authService.signOut()
            self.currentUserID = nil
            self.authState = .unauthenticated
        } catch {
            print("DEBUG: Sign Out Error:\(error.localizedDescription)")
        }
    }
    
    func refreshUser() async {
        do {
            currentUserID = try await authService.getCurrentUser()
            await checkCarRegistration()
        } catch {
            print("DEBUG: Refresh User Error:\(error.localizedDescription)")
            currentUserID = nil
            self.authState = .unauthenticated
        }
    }
    
    func checkCarRegistration() async {
        do {
            let carStatuses = try await userService.fetchCarStatusesForCurrentUser()
            currentVehicleID = carStatuses.first?.id ?? ""
            self.authState = carStatuses.count > 0
            ? .checkedCarRegistration
            : .carNotRegistered
        } catch {
            self.authState = .carNotRegistered
            print("DEBUG: Check Car Registration Error:\(error.localizedDescription)")
        }
    }
}
