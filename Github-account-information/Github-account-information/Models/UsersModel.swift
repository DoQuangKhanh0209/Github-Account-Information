//
//  UsersModel.swift
//  User-Information-Management
//
//  Created by Quang Khánh on 02/11/2022.
//

import Foundation

struct Project: Codable {
    let id: Int
    let name: String
}

struct Users: Codable {
    let totalCount: Int
    let items: [User]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }
}

struct User: Codable {
    let login: String
    let id: Int
    let avatarURL: String
    let htmlURL: String
    let followersURL: String
    let followingURL: String
    let reposURL: String
    
    enum CodingKeys: String, CodingKey {
        case login
        case id
        case avatarURL = "avatar_url"
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case reposURL = "repos_url"
    }
}
