//
//  AuthController.swift
//  Gigs
//
//  Created by Alexander Supe on 1/15/20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import Foundation

class AuthController {
    
    // MARK: - Attributes
    let baseUrl = URL(string: "https://lambdagigs.vapor.cloud/api")!
    var bearer: Bearer?
    var isLoggedIn: Bool { if bearer == nil { return false } else { return true } }
    
    // MARK: - Base Functions
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
        postRequest(kind: "SignUp", path: "/users/signup", user: user, completion: completion)
    }
    
    func signIn(with user: User, completion: @escaping (Error?) -> ()) {
        postRequest(kind: "SignIn", path: "/users/login", user: user, completion: completion)
    }
    
    // MARK: - Helper Functions
    func postRequest(kind: String, path: String, user: User, completion: @escaping (Error?) -> ()) {
        let finalUrl = baseUrl.appendingPathComponent(path)
        
        var request = URLRequest(url: finalUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do { request.httpBody = try jsonEncoder.encode(user) }
        catch { print("Error encoding user object: \(error)")
            completion(error); return }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            if let error = error { completion(error); return }
            
            if kind == "SignIn" {
                guard let data = data else { completion(NSError()); return }
                let decoder = JSONDecoder()
                do {
                    self.bearer = try decoder.decode(Bearer.self, from: data)
                } catch {
                    print("Error decoding bearer object: \(error)")
                    completion(error)
                    return
                }
            }
            completion(nil)
        }.resume()
    }
}

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
}
