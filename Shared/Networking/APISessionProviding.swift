//
//  APISessionProviding.swift
//  NordSecTest (iOS)
//
//  Created by Vitalii Kizlov on 06.05.2021.
//

import Foundation
import Combine

protocol APISessionProviding {
  func execute<T: Codable>(_ requestProvider: RequestProviding) -> AnyPublisher<T, Error>
}
