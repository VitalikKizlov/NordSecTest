//
//  RequestProviding.swift
//  NordSecTest (iOS)
//
//  Created by Vitalii Kizlov on 06.05.2021.
//

import Foundation

protocol RequestProviding {
    func urlRequest() -> URLRequest
}

enum Endpoint: RequestProviding {
    case getToken(creds: UserCredentials)
    case getServerList
    
    private static let baseURLString = "playground.tesonet.lt"
    
    private enum HTTPMethod {
        case get
        case post
        
        var value: String {
            switch self {
            case .get: return "GET"
            case .post: return "POST"
            }
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .getToken:
            return .post
        case .getServerList:
            return .get
        }
    }
    
    private var path: String {
        switch self {
        case .getToken:
            return "/v1/tokens"
        case .getServerList:
            return "/v1/servers"
        }
    }
    
    private var parameters: [String: String] {
        switch self {
        case .getToken(let creds):
            return ["username": creds.name, "password": creds.pass]
        case .getServerList:
            return [:]
        }
    }
    
    func urlRequest() -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Endpoint.baseURLString
        components.path = path
        components.queryItems = parameters.compactMap { URLQueryItem(name: $0.key, value: $0.value)}
        
        guard let url = components.url else {
            preconditionFailure("Can't create URL")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.value
        let token = KeychainWrapper.shared.getValueFor(service: .token)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print("Request ----", request)
        return request
    }
}
