//
//  Database.swift
//  Marvel Super Heroes
//
//  Created by Marcelo Bogdanovicz on 28/07/19.
//  Copyright © 2019 Marvel. All rights reserved.
//

import UIKit
import CoreData

class Database {

    private static let entityName = "Heroes"
    
    static func loadFavorite() -> [Int] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        var favoriteCharacterIds = [Int]()
        
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                favoriteCharacterIds.append(data.value(forKey: "heroId") as! Int)
            }
        } catch {
            print("Failed")
        }
        
        return favoriteCharacterIds
    }
    
    static func addToFavorite(_ character: Character) {
        
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        
        let hero = NSManagedObject(entity: entity!, insertInto: context)
        hero.setValue(character.id, forKey: "heroId")
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    static func removeFromFavorite(_ character: Character) {
        
        let context = getContext()
        let fetchRequest = getFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "heroId = %i", character.id)
        let result = try! context.fetch(fetchRequest)
        
        for data in result as! [NSManagedObject] {
            context.delete(data)
        }
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    static func reset() {
        
        let context = getContext()
        let fetchRequest = getFetchRequest()
        let result = try! context.fetch(fetchRequest)
        
        for data in result as! [NSManagedObject] {
            context.delete(data)
        }
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    private static func getFetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        
        return NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    }
    
    private static func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
