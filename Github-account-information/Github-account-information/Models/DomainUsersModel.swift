//
//  DomainUsers.swift
//  User-Information-Management
//
//  Created by Quang Khánh on 02/11/2022.
//

import Foundation

struct DomainProject {
    let id: Int
    let name: String
}

struct DomainUser {
    let login: String
    let id: Int
    let avatarUrl: String
    let htmlUrl: String
    let followersUrl: String
    let followingUrl: String
    let reposUrl: String
}
