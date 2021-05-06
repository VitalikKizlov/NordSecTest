//
//  TokenProvider.swift
//  NordSecTest (iOS)
//
//  Created by Vitalii Kizlov on 06.05.2021.
//

import Foundation
import Combine

protocol TokenProviding {
    func getToken(for credentials: UserCredentials) -> AnyPublisher<Token, Error>
}

struct UserCredentials {
    let name: String
    let pass: String
}

struct TokenProvider: TokenProviding {
    let apiSession: APISessionProviding
    
    func getToken(for credentials: UserCredentials) -> AnyPublisher<Token, Error> {
        apiSession.execute(Endpoint.getToken(creds: credentials))
            .eraseToAnyPublisher()
    }
}
