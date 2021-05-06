//
//  ApiSession.swift
//  NordSecTest (iOS)
//
//  Created by Vitalii Kizlov on 06.05.2021.
//

import Foundation
import Combine

struct ApiSession: APISessionProviding {
    private let apiQueue = DispatchQueue(label: "API",
                                         qos: .default,
                                         attributes: .concurrent)
    
    func execute<T>(_ requestProvider: RequestProviding) -> AnyPublisher<T, Error> where T : Codable {
        return URLSession.shared.dataTaskPublisher(for: requestProvider.urlRequest())
            .receive(on: apiQueue)
            .tryMap() { element -> Data in
                
                guard let httpResponse = element.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                
                if httpResponse.statusCode == 401 {
                    throw URLError(.userAuthenticationRequired)
                }
                
                return element.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}
