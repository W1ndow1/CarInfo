//
//  User.swift
//  CarInfo
//
//  Created by window1 on 10/7/25.
//

import Foundation


struct User: Codable, Identifiable {
    let id: String
    let email: String
    let username: String
    let createdAt: Date
    var profileImageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id, email, username
        case createdAt = "created_at"
    }
}

//c3f374ec-f7ae-4785-962a-524c47c03766
//c3f374ec-f7ae-4785-962a-524c47c03766
