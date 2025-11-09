//
//  AuthViewModel.swift
//  CarInfo
//
//  Created by window1 on 10/6/25.
//

import Foundation
import Supabase
import Combine


@Observable
@MainActor

class AuthViewModel: ObservableObject {
    var session: Session? = nil
    var isLoading = false
    var errorMessage: String?
    var currentUserID: String?
    var authState: AuthState = .checking
    
    private var authService = SupabaseAuthService()
    
    init(authService: SupabaseAuthService = SupabaseAuthService()) {
        self.authService = authService
    }
        
    func signUp(email: String, password: String, username: String) async {
        do {
            self.currentUserID = try await authService.signUp(email: email, password: password, username: username)
            self.authState = .authenticated
        } catch {
            print("DEBUG: Sign up Error:\(error.localizedDescription)")
        }
    }
    
    func signIn(email: String, password: String) async {
        do {
            self.currentUserID = try await authService.signIn(email: email, password: password)
            self.authState = .authenticated
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
        } catch {
            print("DEBUG: Refresh User Error:\(error.localizedDescription)")
            currentUserID = nil
        }
    }
}
