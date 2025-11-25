//
//  SupabaseClient+Shared.swift
//  CarInfo
//
//  Created by window1 on 11/11/25.
//

import Foundation
import Supabase

extension SupabaseClient {
    static let shared = SupabaseClient(
        supabaseURL: Config.Supabase.supabaseURL,
        supabaseKey: Config.Supabase.supabaseAPI
    )
}
