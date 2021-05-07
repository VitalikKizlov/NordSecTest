//
//  Database.swift
//  NordSecTest (iOS)
//
//  Created by Vitalii Kizlov on 07.05.2021.
//

import Foundation
import CoreData

class Database {

    static let shared = Database()
    private init() {}
    
    public static func start() {
        _ = shared.container
    }
    
    private lazy var container: NSPersistentContainer = {
        let value = NSPersistentContainer(name: "Servers")
                
        value.loadPersistentStores { (store, error) in
            store.setOption(FileProtectionType.complete as NSObject, forKey: NSPersistentStoreFileProtectionKey)
            if let error = error {
                fatalError("\(error)")
            }
        }
        value.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        value.viewContext.automaticallyMergesChangesFromParent = true
        return value
    }()
    
    public func backgroundContext() -> NSManagedObjectContext {
        let context = container.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.automaticallyMergesChangesFromParent = true
        return context
    }
    
    public func viewContext() -> NSManagedObjectContext {
        return container.viewContext
    }
}

enum ModelCodingException: Error {
    case valueNilAfterEncoding
    case managedContextNotFound
    case modelDataIsNotReturnedFromResponse
}
