//
//  CarControlService.swift
//  CarInfo
//
//  Created by window1 on 11/14/25.
//

import Foundation
import Supabase

protocol CarControlServiceProtocol {
    func updateVehicleStatus<T:Encodable>(vehicleId: String, column: String, value: T) async throws -> CarStatus
}

struct CarControlService: CarControlServiceProtocol {
    
    private let client: SupabaseClient
    
    init(client: SupabaseClient = .shared) {
        self.client = client
    }
    
    func updateVehicleStatus<T:Encodable>(vehicleId: String, column: String, value: T) async throws -> CarStatus {
        let updateQuery: CarStatus = try await client
            .from("cars")
            .update([column: value])
            .eq("id", value: vehicleId)
            .select()
            .single()
            .execute()
            .value
        return updateQuery
    }
    
    func fetchVehicleStatus(vId: String) async throws -> CarStatus {
        let fetchQuery: CarStatus = try await client
            .from("cars")
            .select("*")
            .eq("id", value: vId)
            .single()
            .execute()
            .value
        print("fetchQuery: \(fetchQuery.carName)")
        return fetchQuery
    }
}
