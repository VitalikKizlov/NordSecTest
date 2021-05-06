//
//  ServerListProvider.swift
//  NordSecTest (iOS)
//
//  Created by Vitalii Kizlov on 06.05.2021.
//

import Foundation
import Combine

protocol ServerListProviding {
    func getList() -> AnyPublisher<Token, Error>
}

//struct ServerListProvider: ServerListProviding {
//    func getList() -> AnyPublisher<Token, Error> {
//        
//    }
//}

/*
 .tryCatch({ (error) -> AnyPublisher<Token, Error> in
     let creds = UserCredentials(name: "fsafsd", pass: "fsdf")
     return apiSession.execute(Endpoint.getToken(creds: creds))
 })
 */
