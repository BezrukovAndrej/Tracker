//
//  CoreDataManager.swift
//  Tracker
//
//  Created by Andrey Bezrukov on 14.08.2023.
//

import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print(error)
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}
