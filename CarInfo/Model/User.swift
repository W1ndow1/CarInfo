//
//  User.swift
//  CarInfo
//
//  Created by window1 on 10/7/25.
//

import Foundation


struct User: Identifiable {
    let id: String
    let email: String
    let displayName: String
    let createdAt: Date
    var profileImageURL: String?
}
