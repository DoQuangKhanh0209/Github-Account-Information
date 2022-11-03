//
//  UserRepositoryType.swift
//  Github-account-information
//
//  Created by Quang Khánh on 03/11/2022.
//

import Foundation

protocol RepositoryType {
    associatedtype DomainUser
    associatedtype DomainProject
    
    func getAllUser(urlApi: String, completion: @escaping ([DomainUser]?, Error?) -> Void)
    func getUserDetail(urlApi: String, completion: @escaping (DomainUser?, Error?) -> (Void))
    func getAllRelationshipOfUser(urlApi: String, completion: @escaping ([DomainUser]?, Error?) -> Void)
    func getAllRepositoryOfUser(urlApi: String, completion: @escaping ([DomainProject]?, Error?) -> Void)
}

final class UserRepositoryType: RepositoryType {

    private var network = APIService.shareDataAPI
    
    func getAllUser(urlApi: String, completion: @escaping ([DomainUser]?, Error?) -> Void) {
        network.getJSON(urlApi: urlApi) { (data: Users?, error) in
            var domainUserList = [DomainUser]()
            if let data = data {
                for user in data.items {
                    domainUserList.append(DomainUser(
                        login: user.login,
                        id: user.id,
                        avatarUrl: user.avatarURL,
                        htmlUrl: user.htmlURL,
                        followersUrl: user.followersURL,
                        followingUrl: user.followingURL,
                        reposUrl: user.reposURL
                    ))
                }
                DispatchQueue.main.async {
                    completion(domainUserList, nil)
                }
            }
        }
    }
    
    func getUserDetail(urlApi: String, completion: @escaping (DomainUser?, Error?) -> (Void)) {
        network.getJSON(urlApi: urlApi) { (data: User?, error) in
            if let data = data {
                let domainUser = DomainUser(
                    login: data.login,
                    id: data.id,
                    avatarUrl: data.avatarURL,
                    htmlUrl: data.htmlURL,
                    followersUrl: data.followersURL,
                    followingUrl: data.followingURL,
                    reposUrl: data.reposURL
                )
                DispatchQueue.main.async {
                    completion(domainUser, nil)
                }
            }
        }
    }
    
    func getAllRelationshipOfUser(urlApi: String, completion: @escaping ([DomainUser]?, Error?) -> Void) {
        network.getJSON(urlApi: urlApi) { (data: [User]?, error) in
            var domainUserList = [DomainUser]()
            if let data = data {
                for user in data {
                    domainUserList.append(DomainUser(
                        login: user.login,
                        id: user.id,
                        avatarUrl: user.avatarURL,
                        htmlUrl: user.htmlURL,
                        followersUrl: user.followersURL,
                        followingUrl: user.followingURL,
                        reposUrl: user.reposURL
                    ))
                }
                DispatchQueue.main.async {
                    completion(domainUserList, nil)
                }
            }
        }
    }
    
    func getAllRepositoryOfUser(urlApi: String, completion: @escaping ([DomainProject]?, Error?) -> Void) {
        network.getJSON(urlApi: urlApi) { (data: [Project]?, error) in
            var domainRepoList = [DomainProject]()
            if let data = data {
                for repo in data {
                    domainRepoList.append(DomainProject(
                        id: repo.id,
                        name: repo.name
                    ))
                }
                DispatchQueue.main.async {
                    completion(domainRepoList, nil)
                }
            }
        }
    }
}
