//
//  ServerListProvider.swift
//  NordSecTest (iOS)
//
//  Created by Vitalii Kizlov on 06.05.2021.
//

import Foundation
import Combine

protocol ServerListProviding {
    func getList() -> AnyPublisher<[Server], Error>
}

struct ServerListProvider: ServerListProviding {
    let apiSession: APISessionProviding
    
    func getList() -> AnyPublisher<[Server], Error> {
        apiSession.execute(Endpoint.getServerList)
            .tryCatch({ (error) -> AnyPublisher<[Server], Error> in
                let username = KeychainWrapper.shared.getValueFor(service: .username)
                let pass = KeychainWrapper.shared.getValueFor(service: .password)
                let creds = UserCredentials(name: username, pass: pass)
                return apiSession.execute(Endpoint.getToken(creds: creds))
            })
            .eraseToAnyPublisher()
    }
}
