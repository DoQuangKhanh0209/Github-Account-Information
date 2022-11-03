//
//  APIService.swift
//  User-Information-Management
//
//  Created by Quang Khánh on 02/11/2022.
//

import Foundation

class APIService {
    
    static let shareDataAPI = APIService()
    let URLsession: URLSession
    
    init() {
        URLsession = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    func getJSON<T: Codable>(urlApi: String, completion: @escaping (T?, Error?) -> Void) {
        guard let url = URL(string: urlApi) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = APIResful.get.rawValue
        
        let task = URLsession.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if let error = error {
                    completion(nil, error)
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            do {
                let results = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(results, nil)
                }
            }
            catch let error {
                print(error)
            }
        }
        task.resume()
    }
    
    func getImageUser(imageURL: String ,completion: @escaping (Data?, Error?) -> (Void)) {
        guard let url = URL(string: imageURL) else {
            return
        }
        let task = URLsession.downloadTask(with: url) { (localUrl: URL?, response: URLResponse?, error: Error?) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            guard let localUrl = localUrl else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            do {
                let data = try Data(contentsOf: localUrl)
                DispatchQueue.main.async {
                    completion(data, nil)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
}
