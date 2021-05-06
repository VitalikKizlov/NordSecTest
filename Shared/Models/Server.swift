//
//  Server.swift
//  NordSecTest (iOS)
//
//  Created by Vitalii Kizlov on 06.05.2021.
//

import Foundation

struct Server: Codable, Identifiable {
    var id = UUID()
    let name: String
    let distance: Int
    
    enum CodingKeys: String, CodingKey {
        case name, distance
    }
}
