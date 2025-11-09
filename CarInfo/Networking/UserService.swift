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
    
    func fetchCarStatusesForCurrentUser() async throws -> [CarStatus] {
        let user = try await client.auth.session.user
        let carStatuses: [CarStatus] = try await client.from("cars")
            .select("*")
            .eq("user_id", value: user.id.uuidString)
            .execute()
            .value

        return carStatuses
    }
    
    func registerCar(carId: String) async throws -> CarStatus {
        // 파라미터로 userId를 받지 않고, 인증 세션에서 직접 가져옵니다.
        let currentUserId = try await client.auth.session.user.id

        let newCar = CarStatus(id: carId, user_id: currentUserId.uuidString)
        let createdCar: CarStatus = try await client.from("cars")
            .insert(newCar)
            .select()
            .single()
            .execute()
            .value
        return createdCar

    }
}

