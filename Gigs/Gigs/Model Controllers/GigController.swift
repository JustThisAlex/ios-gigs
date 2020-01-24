//
//  GigController.swift
//  Gigs
//
//  Created by Alexander Supe on 1/15/20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import Foundation

class GigController {
    var authController = AuthController()
    var gigs: [Gig] = []
    
    func fetchGigs(completion: @escaping (NetworkError?) -> Void) {
        guard let bearer = authController.bearer else { completion(.noAuth); return }
        let finalUrl = authController.baseUrl.appendingPathComponent("")
        var request = URLRequest(url: finalUrl)
        request.httpMethod = "POST"
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.badAuth)
                return
            }
            if let error = error {
                print("Error receiving: \(error)")
                completion(.otherError)
                return
            }
            guard let data = data else {
                completion(.badData)
                return
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let receivedData = try decoder.decode([Gig].self, from: data)
                completion(nil)
                self.gigs = receivedData
            } catch {
                print("Error decoding object: \(error)")
                completion(.noDecode)
                return
            }
        }.resume()
    }
    
    
}
