//
//  TokenProvider.swift
//  projectDate
//
//  Created by DotZ3R0 on 12/11/22.
//

import Foundation

enum TokenProviderError: Error {
    case invalidURL
    case invalidRequestPayload
    case invalidResponseFormat
    case tokenMissing
    case networkError(reason: String?)
}

class TokenProvider {
    struct Constants {
        static let tokenEndpoint = "https://prod-in2.100ms.live/hmsapi/dotZ3R0.app.100ms.live/"
        static let roomID = "638d9e07aee54625da64dfe2"
    }
    
    func getToken(for userID: String, role: String, completion: @escaping (String?, Error?) -> Void) {
        let tokenRequest: URLRequest
        
        do {
            tokenRequest = try request(for: userID, role: role)
        } catch {
            completion(nil, error)
            return
        }

        URLSession.shared.dataTask(with: tokenRequest) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.process(data: data, error: error, completion: completion)
            }
        }.resume()
    }

    private func request(for userID: String, role: String) throws -> URLRequest {
        guard let url = URL(string: Constants.tokenEndpoint + "api/token") else {
            throw TokenProviderError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let body = ["room_id": Constants.roomID,
                    "user_id": userID,
                    "role": role]

        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        return request
    }
    
    private func process(data: Data?, error: Error?, completion: (String?, Error?) -> Void) {
        guard error == nil, let data = data else {
            completion(nil, TokenProviderError.networkError(reason: error?.localizedDescription))
            return
        }

        let token: String
        do {
            token = try parseToken(from: data)
        } catch {
            completion(nil, error)
            return
        }
        
        completion(token, nil)
    }

    private func parseToken(from data: Data) throws -> String {
        let json = try JSONSerialization.jsonObject(with: data)
        
        guard let responseDictionary = json as? [String: Any]  else {
            throw TokenProviderError.invalidResponseFormat
        }
        
        guard let token = responseDictionary["token"] as? String else {
            throw TokenProviderError.tokenMissing
        }

        return token
    }
}
