//
//  PersistenceManager.swift
//  DisneyCharactersApp
//
//  Created by Kseniya Kuidina on 09/06/2023.
//

import CoreData
import Foundation


class PersistenceManager {
    
    typealias SaveBlock = (NSManagedObjectContext) -> Void
    
    private let persistentContainer: NSPersistentContainer
    private var syncContext: NSManagedObjectContext
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        
        syncContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        syncContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        syncContext.automaticallyMergesChangesFromParent = true
        syncContext.parent = self.persistentContainer.viewContext
    }
    
    //MARK: Data saving
    
    func synchronize() {
        do {
            // We call save on the private context, which moves all of the changes into the main queue context without blocking the main queue.
            try syncContext.save()
            persistentContainer.viewContext.performAndWait {
                do {
                    try persistentContainer.viewContext.save()
                } catch {
                    NSLog("Could not synchonize viewContext data. \(error), \(error.localizedDescription)")
                }
            }
        } catch {
            NSLog("Could not synchonize syncContext data. \(error), \(error.localizedDescription)")
        }
    }
}


extension PersistenceManager : CharacterManager {
    
    func saveCharacters(characters: [Character]) {
        //TODO: improve with NSBatchInsertRequest
        syncContext.perform {
            
            for character in characters {
                if self.characterExists(characterId: character.characterId, inContext: self.syncContext) == false {
                    guard let _ = character.toManagedObject(inContext: self.syncContext) else {
                        return
                    }
                    
                    NSLog("Saved character \(character.name) to DB.")
                }
            }
            self.synchronize()
        }
    }
    
    func getAllCharacters(completion: @escaping ([Character]?) -> Void)  {
        
        syncContext.performAndWait  {
            let fetchRequest = CharacterManagedObject.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            
            do {
                let managedObjects: [CharacterManagedObject] = try self.syncContext.fetch(fetchRequest)
                completion( managedObjects.map { $0.toModelObject() })
                
            } catch let error {
                NSLog("Failed to fetch characters, error=\(error)")
                completion([])
            }
        }
    }
    
    func getCharacter(characterId: Int64) -> Character? {
        
        guard let entityName = CharacterManagedObject.entity().name else {
            return nil
        }
        
        let request = NSFetchRequest<CharacterManagedObject>(entityName: entityName)
        let predicate = NSPredicate(format: "characterId == %ld", characterId)
        request.predicate = predicate
        request.fetchLimit = 1
        
        do {
            let managedObjects: [CharacterManagedObject] = try persistentContainer.viewContext.fetch(request)
            
            let  characters = managedObjects.map { $0.toModelObject() }
            return characters.first
            
        } catch let error {
            NSLog("Failed to fetch characters, error=\(error)")
            return nil
        }
    }
    
    func characterExists(characterId: Int64, inContext: NSManagedObjectContext) -> Bool {
        
        let request = CharacterManagedObject.fetchRequest()
        let predicate = NSPredicate(format: "characterId == %ld", characterId)
        request.predicate = predicate
        request.fetchLimit = 1
        
        do {
            let count = try inContext.count(for: request)
            NSLog(count > 0 ? "Character with ID=\(characterId) found!" : "Character with ID=\(characterId) not found")
            
            return count > 0
        } catch let error as NSError {
            NSLog("Could not fetch \(error), \(error.userInfo)")
        }
        
        return false
    }
    
    func createCharacter(character: Character, inContext: NSManagedObjectContext) {
        _ =  character.toManagedObject(inContext: inContext)
    }
    
    //TODO:
    func deleteCharacter(characterId: Int64) -> Bool {
        return false
    }
    
    //TODO:
    func deleteAllCharacters() -> Bool {
        return false
    }
}
