//
//  SupabaseAuthService.swift
//  CarInfo
//
//  Created by window1 on 10/7/25.
//

import Foundation
import Supabase

struct SupabaseAuthService {
    private let client: SupabaseClient
    
    init() {
        self.client = SupabaseClient.init(
            supabaseURL: Config.Supabase.supabaseURL,
            supabaseKey: Config.Supabase.supabaseAPI)
    }
    
    func signUp(email: String, password: String) async throws -> User {
        let response = try await client.auth.signUp(email: email, password: password)
        guard let email = response.user.email else {
            print("DEBUG: No Email")
            throw NSError()
        }
        print(response.user)
        return User(id: response.user.aud, email: email, displayName: "", createdAt: Date())
    }
    
    func signIn(email: String, password: String) async throws -> User {
        let response = try await client.auth.signIn(email: email, password: password)
        
        print(response.user)
        
        guard let email = response.user.email else {
            print("DEBUG: No Email")
            throw NSError()
        }
        return User(id: response.user.aud, email: email, displayName: "", createdAt: response.user.createdAt)
    }
    
    
    func signOut() async throws {
        try await client.auth.signOut()
    }
    
    func getCurrentUser() async throws -> User? {
        let suparbaseUser = try await client.auth.session.user
        
        guard let email = suparbaseUser.email else {
            print("DEBUG: No email")
            throw NSError()
        }
        
        return User(id: suparbaseUser.aud, email: email, displayName: "", createdAt: suparbaseUser.createdAt)
    }
}
