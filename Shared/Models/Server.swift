//
//  Server.swift
//  NordSecTest (iOS)
//
//  Created by Vitalii Kizlov on 06.05.2021.
//

import Foundation
import CoreData

class Server: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case name, distance
    }
    
    public required convenience init(from decoder: Decoder) throws {
        
        guard let key = CodingUserInfoKey.context,
              let context = decoder.userInfo[key] as? NSManagedObjectContext else {
            throw ModelCodingException.managedContextNotFound
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        distance = try container.decode(Int64.self, forKey: .distance)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(distance, forKey: .distance)
    }
}
