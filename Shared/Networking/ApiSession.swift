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
    
    let decoder = JSONDecoder()
    
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
                
                let context = Database.shared.viewContext()
                decoder.userInfo[CodingUserInfoKey.context!] = context
                
                context.performAndWait {
                    do {
                        try context.save()
                    } catch let error {
                        print("Error: \(error.localizedDescription)")
                    }
                }
                
                return element.data
            }
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
}
