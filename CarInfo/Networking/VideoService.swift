//
//  VideoService.swift
//  CarInfo
//
//  Created by window1 on 10/17/25.
//

import Foundation
import Supabase

struct VideoService {
    private let client: SupabaseClient
    
    init() {
        self.client = SupabaseClient.init(
            supabaseURL: Config.Supabase.supabaseURL,
            supabaseKey: Config.Supabase.supabaseAPI
        )
    }
    
    let bucketName = "SecurityCamera"
    
    func getPublicVideoURL(path: String) async throws -> URL? {
        let url = try client
            .storage
            .from(bucketName)
            .getPublicURL(path: path)
        return url
    }
    
    func getSignedVideoURL(path: String, expiresIn: Int = 1800) async throws -> URL? {
        let url = try await client
            .storage
            .from(bucketName)
            .createSignedURL(path: path, expiresIn: expiresIn)
        return url
    }
}
