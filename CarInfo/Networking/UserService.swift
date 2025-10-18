//
//  SupabaseService.swift
//  CarInfo
//
//  Created by window1 on 10/14/25.
//

import Foundation
import Supabase

struct UserService {
    private let client: SupabaseClient
    
    init() {
        self.client = SupabaseClient.init(
            supabaseURL: Config.Supabase.supabaseURL,
            supabaseKey: Config.Supabase.supabaseAPI)
    }
    
    func fetchCurrentUser() async throws -> User {
        let user = try await client.auth.session.user
        return try await client.from("users")
            .select()
            .eq("id", value: user.id.uuidString)
            .single()
            .execute()
            .value
    }
    
    func uploadCurrentUserCarRegistration() async throws {
        //let data = try await
    }
}
